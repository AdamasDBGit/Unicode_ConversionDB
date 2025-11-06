
CREATE PROCEDURE [REPORT].[uspPerformanceReport]  
 
@iBrandId INT ,
@sHierarchyListID VARCHAR(400),  
@CourseIds INT,  
@BatchIds VARCHAR(400),  
@TermIds VARCHAR(400),  
@SubjectIds VARCHAR(400),  
@gradeIds VARCHAR(400)

 
AS  
BEGIN  
SET NOCOUNT ON;  
 if(@BatchIds='ALL')set @BatchIds='';
  if(@TermIds='ALL')set @TermIds='';
   if(@SubjectIds='ALL')set @SubjectIds='';
    if(@gradeIds='ALL')set @gradeIds='';
CREATE TABLE #Ptemp  
(  
StudentID VARCHAR(MAX),  
StudentDetailID INT,  
CourseID INT,  
BatchID INT,  
TermID INT,  
TermName VARCHAR(MAX),  
ModuleID INT,  
ModuleName VARCHAR(MAX),  
ExamComponentID INT,  
ExamComponentName VARCHAR(MAX),  
FullMarks DECIMAL(14,2),  
Weightage DECIMAL(14,2),  
MarksObtained DECIMAL(14,2),  
EffectiveMarks DECIMAL(14,2),  
ModuleGrade VARCHAR(20),  
Grade VARCHAR(20),  
TermTotal DECIMAL(14,2),  
HighestMarks DECIMAL(14,2),  
HighestGrade VARCHAR(10),  
S_Course_Name VARCHAR(MAX),  
S_Course_Desc VARCHAR(MAX),  
SequenceNo INT ,
TermAttendance INT  
)  
CREATE TABLE #temp  
(  
StudentID VARCHAR(MAX),  
StudentDetailID INT,  
CourseID INT,  
BatchID INT,  
TermID INT,  
TermName VARCHAR(MAX),  
ModuleID INT,  
ModuleName VARCHAR(MAX),  
ExamComponentID INT,  
ExamComponentName VARCHAR(MAX),  
FullMarks DECIMAL(14,2),  
Weightage DECIMAL(14,2),  
MarksObtained DECIMAL(14,2),  
EffectiveMarks DECIMAL(14,2),  
ModuleGrade VARCHAR(20),  
Grade VARCHAR(20),  
TermTotal DECIMAL(14,2),  
HighestMarks DECIMAL(14,2),  
HighestGrade VARCHAR(10),  
S_Course_Name VARCHAR(MAX),  
S_Course_Desc VARCHAR(MAX),  
SequenceNo INT,  
TermAttendance INT  
)  
 
INSERT INTO #Ptemp  
(   StudentID,StudentDetailID,CourseID,BatchID,TermID,TermName,ModuleID,ModuleName, ExamComponentID,ExamComponentName,FullMarks,Weightage,  
    MarksObtained,EffectiveMarks,S_Course_Name, S_Course_Desc,SequenceNo  
)  
SELECT DISTINCT T1.S_Student_ID,T1.I_Student_Detail_ID,T1.I_Course_ID,T1.I_Batch_ID,T1.I_Term_ID,T1.S_Term_Name,T1.I_Module_ID,T1.S_Module_Name,  
TMES.I_Exam_Component_ID,T1.S_Component_Name,TMES.I_TotMarks,TMES.N_Weightage,T1.I_Exam_Total,  
CASE WHEN (TMES.N_Weightage=100.00 OR TMES.N_Weightage=0.00) THEN ISNULL(T1.I_Exam_Total,0) ELSE (ROUND(ISNULL(T1.I_Exam_Total,0),0)*TMES.N_Weightage)/TMES.I_TotMarks END,  
T1.S_Course_Name,T1.S_Course_Desc,  
T1.I_Sequence_No  
FROM  
dbo.T_Module_Eval_Strategy AS TMES  
inner JOIN  
(  
SELECT DISTINCT TSD.S_Student_ID,TSD.I_Student_Detail_ID,TCM.I_Course_ID,TSBM.I_Batch_ID,TBEM.I_Term_ID,TTM.S_Term_Name,  
TBEM.I_Module_ID,TMM.S_Module_Name,TBEM.I_Exam_Component_ID,TECM.S_Component_Name,  
ISNULL(TSM.I_Exam_Total,NULL) AS I_Exam_Total,TCM.S_Course_Desc,TCM.S_Course_Name,  
TECM.I_Sequence_No  
FROM  
EXAMINATION.T_Student_Marks AS TSM  
INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID  
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID  
left JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID  
INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID  
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSM.I_Center_ID  
INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID  
INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID  
INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID  
--LEFT JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Module_ID=TBEM.I_Module_ID  
-- AND TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID  
-- AND TMES.I_Term_ID = TBEM.I_Term_ID AND TMES.I_Status=1 AND TMES.I_Course_ID=189  
WHERE  
TBEM.I_Status=1 AND TSBM.I_Course_ID in (select * from fnSplitter(@CourseIds)) 
and (@BatchIds='' or @BatchIds=null) or TSBM.I_Batch_ID in (select * from fnSplitter(@BatchIds))
-- AND TBEM.I_Exam_Component_ID in (select * from fnSplitter(@SubjectIds))--AND TCHND.I_Brand_ID=107 AND TSM.I_Center_ID=1  AND TSBM.I_Course_ID=189 AND TBEM.I_Batch_ID=794  
--AND TBEM.I_Term_ID=ISNULL(17,TTM.I_Term_ID)  
--AND TSD.I_Student_Detail_ID=365529--95212
AND TSM.I_Center_ID IN (SELECT fnCenter.centerID FROM fnGetCentersForReports(@sHierarchyListID,@iBrandId) fnCenter )
) T1 ON T1.I_Course_ID = TMES.I_Course_ID AND T1.I_Exam_Component_ID = TMES.I_Exam_Component_ID AND T1.I_Module_ID = TMES.I_Module_ID  
AND T1.I_Term_ID = TMES.I_Term_ID

if(@TermIds!='' or @TermIds!=null)
 Insert Into #temp ( StudentID,StudentDetailID,CourseID,BatchID,TermID,TermName,ModuleID,ModuleName, ExamComponentID,ExamComponentName,FullMarks,Weightage,  
    MarksObtained,EffectiveMarks,S_Course_Name, S_Course_Desc,SequenceNo 
) (select StudentID,StudentDetailID,CourseID,BatchID,TermID,TermName,ModuleID,ModuleName, ExamComponentID,ExamComponentName,FullMarks,Weightage,  
    MarksObtained,EffectiveMarks,S_Course_Name, S_Course_Desc,SequenceNo from #Ptemp where TermID in (select * from fnSplitter(@TermIds)))

else
Insert Into #temp (  
 StudentID,StudentDetailID,CourseID,BatchID,TermID,TermName,ModuleID,ModuleName, ExamComponentID,ExamComponentName,FullMarks,Weightage,  
    MarksObtained,EffectiveMarks,S_Course_Name, S_Course_Desc,SequenceNo
) select StudentID,StudentDetailID,CourseID,BatchID,TermID,TermName,ModuleID,ModuleName, ExamComponentID,ExamComponentName,FullMarks,Weightage,  
    MarksObtained,EffectiveMarks,S_Course_Name, S_Course_Desc,SequenceNo from #Ptemp 

UPDATE T1  
SET  
T1.TermTotal=T2.TermTotal  
FROM  
#temp AS T1  
INNER JOIN  
(  
SELECT T.StudentDetailID,T.ExamComponentID,T.TermID,SUM(ISNULL(T.EffectiveMarks,0)) AS TermTotal  
FROM #temp AS T GROUP BY T.StudentDetailID,T.ExamComponentID,T.TermID  
)T2 ON T2.StudentDetailID = T1.StudentDetailID AND T2.ExamComponentID = T1.ExamComponentID AND T2.TermID = T1.TermID  
CREATE TABLE #tblGradeMst  
    (  
        ID INT IDENTITY ,  
        FromMarks NUMERIC(8, 2) ,  
        ToMarks NUMERIC(8, 2) ,  
        Grade VARCHAR(10)  
    )  
       
               
INSERT  INTO #tblGradeMst  
        ( FromMarks, ToMarks, Grade )  
VALUES  ( 0, 39, '0-39' )  
INSERT  INTO #tblGradeMst  
        ( FromMarks, ToMarks, Grade )  
VALUES  ( 40, 59, '40-59' )  
INSERT  INTO #tblGradeMst  
        ( FromMarks, ToMarks, Grade )  
VALUES  ( 60, 79, '60-79' )  
INSERT  INTO #tblGradeMst  
        ( FromMarks, ToMarks, Grade )  
VALUES  ( 80, 89, '80-89' )  
INSERT  INTO #tblGradeMst  
        ( FromMarks, ToMarks, Grade )  
VALUES  ( 90, 100, '90-100' )  
 
UPDATE T1  
SET  
T1.TermAttendance=ISNULL(T2.N_Attendance,0)  
FROM  
#temp AS T1  
INNER JOIN EXAMINATION.T_Student_Internal_Attendance AS T2 ON T1.CourseID=T2.I_Course_ID AND T1.TermID=T2.I_Term_ID AND T1.StudentDetailID=T2.I_Student_Detail_ID  
AND T1.ExamComponentID=T2.I_Exam_Component_ID  
 
UPDATE  #temp  
                SET     Grade = ( SELECT   Grade  
                                       FROM     #tblGradeMst  
                                       WHERE    CAST(ROUND(TermTotal, 0) AS INT) >= FromMarks  
                                                AND CAST(ROUND(TermTotal, 0) AS INT) < ToMarks  
                                     )  
 
UPDATE  #temp  
                SET     HighestGrade = ( SELECT Grade  
                                         FROM   #tblGradeMst  
                                         WHERE  CAST(ROUND(HighestMarks, 0) AS INT) >= FromMarks  
                                                AND CAST(ROUND(HighestMarks, 0) AS INT) < ToMarks  
                                       )  
 
--DROP TABLE #temp  
--DROP TABLE #tblGradeMst  
 Select * into #Tottable from (

SELECT * FROM    
( 
  SELECT StudentDetailID,ExamComponentName,ExamComponentID,Grade FROM #temp 
  where (@gradeIds='' or @gradeIds=null) or ModuleID in (select * from fnSplitter(@gradeIds))
  
) t  
PIVOT(  
    COUNT(StudentDetailID)  
    FOR Grade IN (  
        [0-39],  
        [40-59],  
        [60-79],  
        [80-89],  
        [90-100])  
) AS pivot_table ) as s
if(@SubjectIds!='' or @SubjectIds!=null)
SELECT ExamComponentName,[0-39],[40-59],[60-79],[80-89],[90-100],[0-39]+[40-59]+ [60-79]+[80-89]+[90-100] as 'Total' FROM #Tottable where ExamComponentID in (select * from fnSplitter(@SubjectIds))
else
SELECT ExamComponentName,[0-39],[40-59],[60-79],[80-89],[90-100],[0-39]+[40-59]+ [60-79]+[80-89]+[90-100] as 'Total' FROM #Tottable
End
