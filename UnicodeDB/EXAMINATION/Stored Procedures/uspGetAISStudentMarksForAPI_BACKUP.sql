CREATE PROCEDURE [EXAMINATION].[uspGetAISStudentMarksForAPI_BACKUP](@BrandID INT, @CentreID INT, @CourseID INT, @StudentDetailID INT, @TermID INT=NULL)
AS
BEGIN

--EXEC EXAMINATION.uspGetStudentMarksForAPI @BrandID = 107,@CentreID = 1,@BatchID = 9677, @StudentDetailID=44354-- int

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
SubExamComponentName VARCHAR(MAX),
FullMarks DECIMAL(14,2),
Weightage DECIMAL(14,2),
MarksObtained DECIMAL(14,2),
EffectiveMarks DECIMAL(14,2),
ModuleGrade VARCHAR(20),
ModuleRemarks VARCHAR(MAX),
ModuleAttendance INT,
ModuleAllottedDays INT,
Grade VARCHAR(20),
TermTotal DECIMAL(14,2),
HighestMarks DECIMAL(14,2),
HighestGrade VARCHAR(10),
SequenceNo INT,
TermAttendance INT,
NoofDays INT,
CumMarks DECIMAL(14,2),
ClassTeacherRemarks VARCHAR(MAX)
)

CREATE TABLE #tblGradeMst 
    ( 
        ID INT IDENTITY , 
        FromMarks NUMERIC(8, 2) , 
        ToMarks NUMERIC(8, 2) , 
        Grade VARCHAR(5) 
    )
	
CREATE TABLE #tblRemarkMst
(
ID INT IDENTITY,
Mark INT,
Remark VARCHAR(MAX)
)
              
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( -1, -1, 'Abs' )               
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 0, 39, 'E' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 40, 49, 'C' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 50, 59, 'C+' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 60, 69, 'B' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 70, 79, 'B+' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 80, 89, 'A' ) 
INSERT  INTO #tblGradeMst 
        ( FromMarks, ToMarks, Grade ) 
VALUES  ( 90, 100, 'A+' ) 



INSERT INTO #tblRemarkMst
    (
        Mark,
        Remark
    )
VALUES
    (
        4, -- Mark - int
        'Exceeds Expectations' -- Remark - varchar(max)
    )

INSERT INTO #tblRemarkMst
    (
        Mark,
        Remark
    )
VALUES
    (
        3, -- Mark - int
        'Meets Expectations' -- Remark - varchar(max)
    )

INSERT INTO #tblRemarkMst
    (
        Mark,
        Remark
    )
VALUES
    (
        2, -- Mark - int
        'Developing' -- Remark - varchar(max)
    )

INSERT INTO #tblRemarkMst
    (
        Mark,
        Remark
    )
VALUES
    (
        1, -- Mark - int
        'Needs to Improve' -- Remark - varchar(max)
    )
DECLARE @BatchID INT
DECLARE @PromotedBatch VARCHAR(MAX)
DECLARE @ClassTeacher VARCHAR(MAX)

SELECT @BatchID=TSBD.I_Batch_ID FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN
(
SELECT TSBM.I_Course_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
WHERE TSBD.I_Student_ID=@StudentDetailID AND TSBD.I_Status IN (0,1,2) AND TSBM.I_Course_ID=@CourseID
GROUP BY TSBM.I_Course_ID
) T1 ON TSBD.I_Student_Batch_ID=T1.StdBatchID


PRINT @BatchID

select @ClassTeacher=B.S_First_Name+' '+ISNULL(B.S_Middle_Name,'')+' '+B.S_Last_Name 
from T_Center_Batch_Details A
inner join T_Employee_Dtls B on A.I_Employee_ID=B.I_Employee_ID
where A.I_Batch_ID=@BatchID

--select @PromotedBatch=ISNULL(B.S_Batch_Name,'') from T_Student_Batch_Details A
--inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
--where A.I_Student_ID=@StudentDetailID and (A.I_Status=3 or (A.I_Status=1 and B.I_Course_ID>@CourseID))


select @PromotedBatch=ISNULL(TSBM.S_Batch_Name,'') from T_Student_Batch_Details TSBD
inner join
(
	select A.I_Student_ID,MIN(A.I_Student_Batch_ID) as StdBatchID from T_Student_Batch_Details A
	inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
	inner join T_Course_Master C on B.I_Course_ID=C.I_Course_ID
	where
	A.I_Student_ID=@StudentDetailID and A.I_Status in (0,1,2,3) and C.I_CourseFamily_ID>
	(
		select I_CourseFamily_ID from T_Course_Master where I_Course_ID=@CourseID
	)
	and A.I_FromBatch_ID IS NOT NULL --added on 1.3.2022
	group by A.I_Student_ID
) T1 on TSBD.I_Student_Batch_ID=T1.StdBatchID
inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID



INSERT INTO #temp
(
    StudentID,
    StudentDetailID,
    CourseID,
    BatchID,
    TermID,
	TermName,
    ModuleID,
	ModuleName,
    ExamComponentID,
	ExamComponentName,
	FullMarks,
	Weightage,
    MarksObtained,
    EffectiveMarks,
	SequenceNo,
	ClassTeacherRemarks
)
SELECT DISTINCT TSD.S_Student_ID,TSD.I_Student_Detail_ID,TCM.I_Course_ID,TSBM.I_Batch_ID,TBEM.I_Term_ID,TTM.S_Term_Name,
TBEM.I_Module_ID,TMM.S_Module_Name,TMES.I_Exam_Component_ID,TECM.S_Component_Name,TMES.I_TotMarks,TMES.N_Weightage,
ISNULL(TSM.I_Exam_Total,NULL),
--CASE WHEN (TMES.N_Weightage=100.00 OR TMES.N_Weightage=0.00) THEN ROUND(ISNULL(TSM.I_Exam_Total,0),0) ELSE ROUND((ISNULL(TSM.I_Exam_Total,0)*TMES.N_Weightage)/TMES.I_TotMarks,0) END,
CASE WHEN (TMES.N_Weightage=100.00) THEN ROUND(ISNULL(TSM.I_Exam_Total,0),0) ELSE ROUND((ISNULL(TSM.I_Exam_Total,0)*TMES.N_Weightage)/TMES.I_TotMarks,0) END,
TECM.I_Sequence_No,''
FROM EXAMINATION.T_Student_Marks AS TSM
INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSM.I_Center_ID
INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
INNER JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Module_ID=TBEM.I_Module_ID 
												AND TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID 
												AND TMES.I_Term_ID = TBEM.I_Term_ID AND TMES.I_Status=1 AND TMES.I_Course_ID=@CourseID
WHERE
TBEM.I_Status=1 AND TCHND.I_Brand_ID=@BrandID AND TSM.I_Center_ID=@CentreID  
AND TSBM.I_Course_ID=@CourseID AND TBEM.I_Batch_ID=@BatchID
AND TBEM.I_Term_ID=ISNULL(@TermID,TTM.I_Term_ID)
AND TSD.I_Student_Detail_ID=@StudentDetailID--95212


UPDATE #temp SET SubExamComponentName=SUBSTRING(ExamComponentName,CHARINDEX('-',ExamComponentName)+1,LEN(ExamComponentName)-CHARINDEX('-',ExamComponentName))
UPDATE #temp SET ExamComponentName=REPLACE(ExamComponentName,'-'+SubExamComponentName,'')
UPDATE  #temp
                SET     ModuleRemarks = ( SELECT   TRM.Remark
                                       FROM     #tblRemarkMst AS TRM 
                                       WHERE    CAST(ROUND(MarksObtained, 0) AS INT) = TRM.Mark
									   )




UPDATE  T 
        SET     HighestMarks = VR.Marks 
        FROM    #temp T 
                INNER JOIN ( SELECT V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID , 
                                    MAX(V.Marks) Marks 
                             FROM   ( SELECT   T1.I_Course_ID , 
                                                T1.I_Term_ID , 
                                                T1.I_Exam_Component_ID , 
                                                T1.I_Student_Detail_ID , 
                                                SUM((ROUND(ISNULL(I_Exam_Total, 
                                                              0), 0)*T1.N_Weightage)/T1.I_TotMarks ) Marks  --Changed As Per New Format 2018-19
                                      FROM
									  (
									  SELECT DISTINCT tsbm.I_Course_ID , 
                                                tmtm.I_Term_ID , 
												tmtm.I_Module_ID,
                                                tbem.I_Exam_Component_ID , 
                                                tsm.I_Student_Detail_ID ,
												I_Exam_Total,
												tmes.N_Weightage,
												tmes.I_TotMarks
												FROM EXAMINATION.T_Student_Marks AS tsm 
                                                WITH ( NOLOCK ) 
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem 
                                                WITH ( NOLOCK ) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID AND tbem.I_Status=1
                                                INNER JOIN ( SELECT 
                                                              I_Student_ID , 
                                                              I_Batch_ID , 
                                                              MAX(I_Status) I_Status 
                                                             FROM 
                                                              dbo.T_Student_Batch_Details 
                                                             GROUP BY I_Student_ID , 
                                                              I_Batch_ID 
                                                           ) AS tsbd ON tsbd.I_Batch_ID = tbem.I_Batch_ID 
                                                              AND tsbd.I_Student_ID = tsm.I_Student_Detail_ID 
                                                              AND tsbd.I_Status IN ( 
                                                              0, 1, 2 ) 
                                                INNER JOIN dbo.T_Student_Batch_Master tsbm 
                                                WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID
																		AND tsbm.I_Course_ID = @CourseID 
                                                INNER JOIN dbo.T_Module_Term_Map 
                                                AS tmtm WITH ( NOLOCK ) ON tbem.I_Module_ID = tmtm.I_Module_ID 
                                                              AND tbem.I_Term_ID = tmtm.I_Term_ID 
                                                              AND tmtm.I_Status = 1 
                                                INNER JOIN dbo.T_Module_Eval_Strategy 
                                                AS tmes WITH ( NOLOCK ) ON tmes.I_Module_ID = tbem.I_Module_ID 
                                                              AND tmes.I_Term_ID = tbem.I_Term_ID 
                                                              AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID 
                                                              AND tmes.I_Status = 1 
                                                INNER JOIN dbo.T_Exam_Component_Master 
                                                AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
												) T1
                                      GROUP BY  T1.I_Course_ID , 
                                                T1.I_Term_ID , 
                                                T1.I_Exam_Component_ID , 
                                                T1.I_Student_Detail_ID 
                                    ) V 
                             GROUP BY V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID 
                           ) VR ON T.CourseID = VR.I_Course_ID 
                                   AND T.TermID = VR.I_Term_ID 
                                   AND VR.I_Exam_Component_ID = T.ExamComponentID

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


UPDATE T1
SET
T1.CumMarks=T2.CumMarks
FROM
#temp AS T1
INNER JOIN
(
select B.StudentDetailID,B.TermID,B.ExamComponentID,
CASE WHEN A.I_Sequence=1 THEN (B.TermTotal*40)/100
WHEN A.I_Sequence=2 THEN (B.TermTotal*60)/100 END AS CumMarks
from T_Term_Course_Map A
inner join #temp B on A.I_Course_ID=B.CourseID and A.I_Term_ID=B.TermID
) T2 on T1.StudentDetailID=T2.StudentDetailID and T1.TermID=T2.TermID and T1.ExamComponentID=T2.ExamComponentID

/*
UPDATE T1
SET
T1.TermAttendance=ISNULL(T2.N_Attendance,0),T1.NoofDays=ISNULL(T2.N_AllottedClass,0)
FROM
#temp AS T1
INNER JOIN EXAMINATION.T_Student_Internal_Attendance AS T2 ON T1.CourseID=T2.I_Course_ID AND T1.TermID=T2.I_Term_ID AND T1.StudentDetailID=T2.I_Student_Detail_ID
															AND T1.ExamComponentID=T2.I_Exam_Component_ID


--if(@CourseID=684 OR @CourseID=685 OR @CourseID=686 OR @CourseID=679 OR @CourseID=680 OR @CourseID=682 OR @CourseID=681 OR @CourseID=683)
if((select MAX(ISNULL(TermAttendance,0)) from #temp)<=0)
BEGIN

UPDATE T1
SET
T1.TermAttendance=ISNULL(T2.N_Attendance,0),T1.NoofDays=ISNULL(T2.N_AllottedClass,0)
FROM
#temp AS T1
INNER JOIN EXAMINATION.T_Student_Internal_Attendance AS T2 ON T1.CourseID=T2.I_Course_ID AND T1.TermID=T2.I_Term_ID AND T1.StudentDetailID=T2.I_Student_Detail_ID
															AND T2.I_Exam_Component_ID IS NULL

END
*/
															




				UPDATE  #temp
                SET     ModuleGrade = ( SELECT   Grade 
                                       FROM     #tblGradeMst 
                                       WHERE    (CAST(ROUND(MarksObtained, 0) AS INT)*100)/CAST(ROUND(FullMarks, 0) AS INT)>=FromMarks
									   AND (CAST(ROUND(MarksObtained, 0) AS INT)*100)/CAST(ROUND(FullMarks, 0) AS INT)<=ToMarks
                                     ) 

				UPDATE  #temp
                SET     Grade = ( SELECT   Grade 
                                       FROM     #tblGradeMst 
                                       WHERE    CAST(ROUND(TermTotal, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(TermTotal, 0) AS INT) <= ToMarks 
                                     ) 
                --WHERE   ExamComponentID IN ( 25, 46, 59 ) 

                UPDATE  #temp 
                SET     Grade = 'A+' 
                WHERE   CAST(ROUND(TermTotal, 0) AS INT) = 100 
                        --AND ExamComponentID IN ( 25, 46, 59 ) 


                UPDATE  #temp
                SET     HighestGrade = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(HighestMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(HighestMarks, 0) AS INT) < ToMarks 
                                       ) 
                --WHERE   ExamComponentID IN ( 25, 46, 59 ) 

				UPDATE  #temp 
                SET     HighestGrade = 'A+' 
                WHERE   CAST(ROUND(HighestMarks, 0) AS INT) = 100 


				




UPDATE #temp SET BatchID=@BatchID WHERE CourseID=@CourseID

--update #temp SET ModuleRemarks='.' where ModuleRemarks is null

if (@BrandID=107)
begin
SELECT T.StudentID,
       T.StudentDetailID,
       T.CourseID,
       T.BatchID,
       T.TermID,
       T.TermName,
       T.ModuleID,
       T.ModuleName,
       T.ExamComponentID,
       REPLACE(REPLACE(REPLACE(T.ExamComponentName,'T_',''),'N_',''),'K_','') AS ExamComponentName,
	   REPLACE(T.SubExamComponentName,'_T2','') as SubExamComponentName,
       T.FullMarks,
       T.Weightage,
       T.MarksObtained,
       T.EffectiveMarks,
       T.ModuleGrade,
	   T.ModuleRemarks,
	   REPORT.fnGetStudentInternalAttendanceDetails(T.StudentDetailID,T.TermID,T.ModuleID,T.ExamComponentID,'Module') as ModuleAttendance,
	   REPORT.fnGetStudentInternalAllottedClassDetails(T.StudentDetailID,T.TermID,T.ModuleID,T.ExamComponentID,'Module') as ModuleAllottedDays,
       T.Grade,
       T.TermTotal,
       T.HighestMarks,
       T.HighestGrade,
       T.SequenceNo,
       CASE WHEN ISNULL(REPORT.fnGetStudentInternalAttendanceDetails(T.StudentDetailID,T.TermID,T.ModuleID,T.ExamComponentID,'Term'),0)<=0 THEN REPORT.fnGetStudentAttendanceDetails(T.StudentDetailID, T.TermID, T.BatchID)
	   ELSE REPORT.fnGetStudentInternalAttendanceDetails(T.StudentDetailID,T.TermID,T.ModuleID,T.ExamComponentID,'Term') END AS TermAttendance,
	   @PromotedBatch as PromotedBatch,
	   @ClassTeacher as ClassTeacher,
	   ROUND(T.CumMarks,0) as CumMarks,
	   T.ClassTeacherRemarks,
	   REPORT.fnGetStudentInternalAllottedClassDetails(T.StudentDetailID,T.TermID,T.ModuleID,T.ExamComponentID,'Term') as AllottedClasses,
	   0 as OverallTermTotal,
	   0 as OverallTermPerc
	   FROM #temp AS T ORDER BY T.StudentDetailID,T.TermID,T.SequenceNo,T.ModuleID
end
--else if (@BrandID=110)
--begin

--SELECT T.StudentID,
--       T.StudentDetailID,
--       T.CourseID,
--       T.BatchID,
--       T.TermID,
--       T.TermName,
--       T.ExamComponentID AS ModuleID,
--       REPLACE(REPLACE(REPLACE(T.ExamComponentName,'T_',''),'N_',''),'K_','') AS ModuleName,
--       T.ModuleID AS ExamComponentID,
--       REPLACE(REPLACE(REPLACE(T.ModuleName,'T1_',''),'T2_',''),'_',' ') AS ExamComponentName,
--	   REPLACE(T.ModuleName,'T2','') as SubExamComponentName,
--       T.FullMarks,
--       T.Weightage,
--       T.MarksObtained,
--       T.EffectiveMarks,
--       T.ModuleGrade,
--	   T.ModuleRemarks,
--       T.Grade,
--       T.TermTotal,
--       T.HighestMarks,
--       T.HighestGrade,
--       T.SequenceNo,
--       CASE WHEN T.TermAttendance IS NULL THEN REPORT.fnGetStudentAttendanceDetails(T.StudentDetailID, T.TermID, T.BatchID)
--	   ELSE T.TermAttendance END AS TermAttendance,
--	   @PromotedBatch as PromotedBatch,
--	   @ClassTeacher as ClassTeacher
--	   FROM #temp AS T ORDER BY T.StudentDetailID,T.TermID,T.SequenceNo,T.ModuleID

--end

END



