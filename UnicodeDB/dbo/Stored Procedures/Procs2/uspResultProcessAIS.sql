--exec uspResultProcess '4',NULL
CREATE PROCEDURE [dbo].[uspResultProcessAIS]
    (
      @iExamScheduleID int ,
      @iStudentDetailID int = null
    )
AS
    BEGIN
		
		IF OBJECT_ID(N'tempdb..#TermTotalTemp') IS NOT NULL
		BEGIN
			DROP TABLE #TermTotalTemp
		END
		
		CREATE TABLE #TermTotalTemp
		(
			ExamComponentID INT,
			TermTotal DECIMAL(14,2),
			MarksRank INT
		)

		IF OBJECT_ID(N'tempdb..#tempStudent') IS NOT NULL
		BEGIN
			DROP TABLE #tempStudent
		END
		
		CREATE TABLE #tempStudent
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
			ModuleGrade VARCHAR(50),
			ModuleRemarks VARCHAR(MAX),
			ModuleAttendance INT,
			ModuleAllottedDays INT,
			Grade VARCHAR(50),
			TermTotal DECIMAL(14,2),
			HighestMarks DECIMAL(14,2),
			HighestGrade VARCHAR(50),
			SequenceNo INT,
			TermAttendance INT,
			CumMarks DECIMAL(14,2),
			ClassTeacherRemarks VARCHAR(MAX),
			AllottedClasses INT,
			ModuleEvalID INT
		)

		IF OBJECT_ID(N'tempdb..#tblRemarkMst') IS NOT NULL
		BEGIN
			DROP TABLE #tblRemarkMst
		END
		

		CREATE TABLE #tblRemarkMst
		(
			ID INT IDENTITY,
			Mark INT,
			Remark VARCHAR(MAX)
		)

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

INSERT INTO #tempStudent
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
	CumMarks,
	ModuleEvalID
)
SELECT DISTINCT TSD.S_Student_ID,TSD.I_Student_Detail_ID,TCM.I_Course_ID,TSBM.I_Batch_ID,TBEM.I_Term_ID,TTM.S_Term_Name,
TBEM.I_Module_ID,TMM.S_Module_Name,
TMES.I_Exam_Component_ID,TECM.S_Component_Name,
TMES.I_TotMarks,TMES.N_Weightage,
ISNULL(TSM.I_Exam_Total,NULL),
CASE WHEN (TMES.N_Weightage=100.00 OR TMES.N_Weightage=0.00) THEN ISNULL(TSM.I_Exam_Total,0) ELSE ROUND((ISNULL(TSM.I_Exam_Total,0)*TMES.N_Weightage)/TMES.I_TotMarks,0) END,
TMTM.I_Sequence,0,TMES.I_Module_Strategy_ID
FROM EXAMINATION.T_Student_Marks AS TSM
INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
-- INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSM.I_Center_ID
INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
INNER JOIN T_Module_Term_Map TMTM on TMM.I_Module_ID=TMTM.I_Module_ID and TTM.I_Term_ID=TMTM.I_Term_ID and TMTM.I_Status=1
INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
INNER JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Module_ID=TBEM.I_Module_ID 
	AND TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID 
	AND TMES.I_Term_ID = TBEM.I_Term_ID AND TMES.I_Status=1 AND TMES.I_Course_ID=TCM.I_Course_ID
INNER JOIN dbo.T_Result_Exam_Schedule as TRES on TCM.I_Course_ID = TRES.I_Course_ID AND TTM.I_Term_ID = TRES.I_Term_ID
INNER JOIN dbo.T_School_Academic_Session_Master as TSSM ON TSSM.I_School_Session_ID = TRES.I_School_Session_ID
	AND TSSM.I_Brand_ID = TCM.I_Brand_ID
WHERE
TBEM.I_Status=1 
-- AND TCHND.I_Brand_ID=107 -- AND TSM.I_Center_ID=36  
-- AND TCM.I_CourseFamily_ID=66
AND TRES.I_Result_Exam_Schedule_ID =@iExamScheduleID
AND ( @iStudentDetailID IS NULL OR TSM.I_Student_Detail_ID = @iStudentDetailID ) 
-- AND TRES.I_Result_Exam_Schedule_ID in (3,4,5,6,7,8,9,10,11,12,13,14)
;



UPDATE #tempStudent SET SubExamComponentName=SUBSTRING(ExamComponentName,CHARINDEX('-',ExamComponentName)+1,LEN(ExamComponentName)-CHARINDEX('-',ExamComponentName))
UPDATE #tempStudent SET ExamComponentName=REPLACE(ExamComponentName,'-'+SubExamComponentName,'')
UPDATE  #tempStudent
                SET     ModuleRemarks = ( SELECT   TRM.Remark
                                       FROM     #tblRemarkMst AS TRM 
                                       WHERE    CAST(ROUND(MarksObtained, 0) AS INT) = TRM.Mark
									   )


UPDATE T1
SET
T1.TermTotal=T2.TermTotal
FROM
#tempStudent AS T1
INNER JOIN
(
SELECT T.StudentDetailID,T.ExamComponentName,T.TermID,SUM(ISNULL(T.EffectiveMarks,0)) AS TermTotal 
FROM #tempStudent AS T 
GROUP BY T.StudentDetailID,T.ExamComponentName,T.TermID
)T2 ON T2.StudentDetailID = T1.StudentDetailID AND T2.ExamComponentName = T1.ExamComponentName AND T2.TermID = T1.TermID


UPDATE T1
SET
T1.ClassTeacherRemarks=ISNULL(T2.S_Remarks,'')
FROM
#tempStudent AS T1
INNER JOIN
(
	select A.I_Student_Detail_ID,A.I_Course_ID,A.S_Remarks from EXAMINATION.T_Student_Internal_Remarks A
	inner join
	(
		select AX.I_Student_Detail_ID,AX.I_Course_ID,MAX(AX.I_Term_ID) as TermID
		from EXAMINATION.T_Student_Internal_Remarks AX
		inner join T_Term_Master BX on AX.I_Term_ID=BX.I_Term_ID
		where AX.I_Term_ID=BX.I_Term_ID
		group by AX.I_Student_Detail_ID,AX.I_Course_ID
	) B on A.I_Student_Detail_ID=B.I_Student_Detail_ID and A.I_Course_ID=B.I_Course_ID and A.I_Term_ID=B.TermID
) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID and T1.CourseID=T2.I_Course_ID


update T1
set
T1.ModuleAttendance=T2.ModuleAttendance
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_Attendance,0),0) as ModuleAttendance 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NOT NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.ModuleID=T2.I_Module_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID and T1.ExamComponentID=T2.I_Exam_Component_ID


update T1
set
T1.ModuleAttendance=T2.ModuleAttendance
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_Attendance,0),0) as ModuleAttendance 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.ModuleID=T2.I_Module_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID


update T1
set
T1.ModuleAllottedDays=T2.ModuleAllottedDays
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_AllottedClass,0),0) as ModuleAllottedDays 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NOT NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.ModuleID=T2.I_Module_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID and T1.ExamComponentID=T2.I_Exam_Component_ID


update T1
set
T1.ModuleAllottedDays=T2.ModuleAllottedDays
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_AllottedClass,0),0) as ModuleAllottedDays 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.ModuleID=T2.I_Module_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID


update T1
set
T1.TermAttendance=T2.TermAttendance
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Exam_Component_ID,ROUND(ISNULL(N_Attendance,0),0) as TermAttendance 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NOT NULL and I_Module_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID and T1.ExamComponentID=T2.I_Exam_Component_ID


update T1
set
T1.TermAttendance=T2.TermAttendance
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Exam_Component_ID,ROUND(ISNULL(N_Attendance,0),0) as TermAttendance 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NULL and I_Module_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID


update #temp set TermAttendance=REPORT.fnGetStudentAttendanceDetails(StudentDetailID, TermID, BatchID) where TermAttendance<=0
--update #temp set AllottedClasses=REPORT.fnGetStudentInternalAllottedClassDetails(StudentDetailID,TermID,ModuleID,ExamComponentID,'Term')


update T1
set
T1.AllottedClasses=T2.AllottedDays
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_AllottedClass,0),0) as AllottedDays 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NOT NULL and I_Module_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID and T1.ExamComponentID=T2.I_Exam_Component_ID


update T1
set
T1.AllottedClasses=T2.AllottedDays
from
#temp T1
inner join
(
	SELECT I_Student_Detail_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,ROUND(ISNULL(N_AllottedClass,0),0) as AllottedDays 
	FROM EXAMINATION.T_Student_Internal_Attendance where I_Status=1 and I_Exam_Component_ID IS NULL and I_Module_ID IS NULL
) T2 on T1.TermID=T2.I_Term_ID and T1.CourseID=T2.I_Course_ID and T1.StudentDetailID=T2.I_Student_Detail_ID





DELETE t3 from dbo.T_Student_Result_Detail_Breakup as t3 
join dbo.T_Student_Result_Detail as t1 on t3.I_Student_Result_Detail_ID = t1.I_Student_Result_Detail_ID
join dbo.T_Student_Result as t2 on t1.I_Student_Result_ID = t2.I_Student_Result_ID
where t2.I_Result_Exam_Schedule_ID =@iExamScheduleID
AND ( @iStudentDetailID IS NULL OR t2.I_Student_Detail_ID = @iStudentDetailID ) 
;

DELETE t1 from dbo.T_Student_Result_Detail as t1 
join dbo.T_Student_Result as t2 on t1.I_Student_Result_ID = t2.I_Student_Result_ID
where t2.I_Result_Exam_Schedule_ID =@iExamScheduleID
AND ( @iStudentDetailID IS NULL OR t2.I_Student_Detail_ID = @iStudentDetailID ) 
;



DELETE FROM dbo.T_Student_Result 
where I_Result_Exam_Schedule_ID =@iExamScheduleID
AND ( @iStudentDetailID IS NULL OR I_Student_Detail_ID = @iStudentDetailID )  ;


INSERT INTO dbo.T_Student_Result (I_Result_Exam_Schedule_ID,I_Student_Detail_ID,S_Student_ID,I_Section_ID,I_Stream_ID,I_School_Class_Teacher_ID,S_Student_Name
,S_Guardian_FM_Name,S_DOB,I_Aggregate_Full_Marks,I_Aggregate_Obtained_Marks,I_Aggregate_Percentage,I_Total_Attendance,I_Total_Class,S_CT_Remarks,S_Overall_Exam_Attendance)
select 

TRES.I_Result_Exam_Schedule_ID,
t1.StudentDetailID as I_Student_Detail_ID,
t1.StudentID as S_Student_ID
,TSCD.I_Section_ID
,TSCD.I_Stream_ID
,max(TSCT.I_School_Class_Teacher_ID) as I_School_Class_Teacher_ID
,concat(TSD.S_First_Name,case when COALESCE(TSD.S_Middle_Name,'') != '' THEN CONCAT(' ',TSD.S_Middle_Name) ELSE '' END
						,case when COALESCE(TSD.S_Last_Name,'') != '' THEN CONCAT(' ',TSD.S_Last_Name) ELSE '' END) as S_Student_Name
,LTRIM(RTRIM(ERD.S_Father_Name)) as S_Guardian_FM_Name
,TSD.Dt_Birth_Date as S_DOB
-- ,t1.BatchID as I_Batch_ID,t1.CourseID as I_Course_ID,t1.TermID as I_Term_ID
,SUM(ISNULL(t1.FullMarks,0)) as I_Aggregate_Full_Marks
,CASE WHEN MAX(ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	SUM(ISNULL(t1.EffectiveMarks,0)) 
	ELSE NULL 
	END as I_Aggregate_Obtained_Marks
,CASE WHEN MAX(ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	ROUND((SUM(ISNULL(t1.EffectiveMarks,0))/SUM(ISNULL(t1.FullMarks,0)))*100,0) 
	ELSE NULL 
	END  as I_Aggregate_Percentage
,MAX(t1.TermAttendance) as TermAttendance
,MAX(t1.AllottedClasses) as AllottedClasses
,MAX(t1.ClassTeacherRemarks) as ClassTeacherRemarks
,CASE WHEN MAX(ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	'Present'
	ELSE 'Fully Absent' 	
	END as S_Overall_Exam_Attendance
from #tempStudent as t1 
join dbo.T_Result_Exam_Schedule as TRES on t1.CourseID = TRES.I_Course_ID and t1.TermID = TRES.I_Term_ID
join dbo.T_Student_Detail as TSD ON TSD.I_Student_Detail_ID = t1.StudentDetailID
left join dbo.T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID
left JOIN dbo.T_Student_Class_Section as TSCD on TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID 
	AND TSCD.I_School_Session_ID = TRES.I_School_Session_ID
	AND TSCD.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
left join dbo.T_School_Class_Teacher as TSCT ON TSCT.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
	AND ISNULL(TSCT.I_Stream_ID,0) = ISNULL(TSCD.I_Stream_ID,0)
	AND ISNULL(TSCT.I_Section_ID,0) = ISNULL(TSCD.I_Section_ID,0)
	AND TSCT.I_Status='1'
WHERE coalesce(t1.MarksObtained,0) != '0.01' 
GROUP BY 
TRES.I_Result_Exam_Schedule_ID,
t1.StudentDetailID ,
t1.StudentID 

,concat(TSD.S_First_Name,case when COALESCE(TSD.S_Middle_Name,'') != '' THEN CONCAT(' ',TSD.S_Middle_Name) ELSE '' END
						,case when COALESCE(TSD.S_Last_Name,'') != '' THEN CONCAT(' ',TSD.S_Last_Name) ELSE '' END) 
,LTRIM(RTRIM(ERD.S_Father_Name)),TSD.Dt_Birth_Date
,TSCD.I_Section_ID
,TSCD.I_Stream_ID


 UPDATE 
  TSR 
  SET TSR.I_Aggregrate_Class_Average_Percentage = TSR1.I_Aggregrate_Class_Average_Percentage
  ,TSR.I_Aggregate_Class_Highest_Percentage = TSR1.I_Aggregate_Class_Highest_Percentage
  ,TSR.I_Total_Students = TSR1.I_Total_Students
  FROM
  dbo.T_Student_Result as TSR 
  JOIN 
  (
  select I_Result_Exam_Schedule_ID
  ,CAST(AVG(I_Aggregate_Percentage) AS DECIMAL(10,2)) as I_Aggregrate_Class_Average_Percentage
  , MAX(I_Aggregate_Percentage) as I_Aggregate_Class_Highest_Percentage
  ,COUNT(I_Result_Exam_Schedule_ID) as I_Total_Students
  from dbo.T_Student_Result 
  where I_Result_Exam_Schedule_ID = @iExamScheduleID
  and I_Aggregate_Percentage is not null
  GROUP BY I_Result_Exam_Schedule_ID
  ) AS TSR1 ON TSR.I_Result_Exam_Schedule_ID = TSR1.I_Result_Exam_Schedule_ID 
  AND TSR.I_Aggregate_Percentage is not null


  UPDATE 
  TSR 
  SET TSR.I_Aggregate_Section_Highest_Percentage = TSR1.I_Aggregate_Section_Highest_Percentage
  FROM
  dbo.T_Student_Result as TSR 
  JOIN 
  (
  select I_Result_Exam_Schedule_ID,I_Section_ID  
  , MAX(I_Aggregate_Percentage) as I_Aggregate_Section_Highest_Percentage
  from dbo.T_Student_Result 
  where I_Result_Exam_Schedule_ID = @iExamScheduleID
  and I_Aggregate_Percentage is not null
  GROUP BY I_Result_Exam_Schedule_ID,I_Section_ID
  ) AS TSR1 ON TSR.I_Result_Exam_Schedule_ID = TSR1.I_Result_Exam_Schedule_ID 
  AND ISNULL(TSR.I_Section_ID,0) = ISNULL(TSR1.I_Section_ID,0)
  AND TSR.I_Aggregate_Percentage is not null
  
UPDATE TSR  
SET TSR.I_Student_Rank = TSR1.I_Student_Rank
FROM dbo.T_Student_Result AS TSR
JOIN (
 SELECT I_Student_Result_ID, I_Aggregate_Obtained_Marks
,RANK () OVER ( 
		ORDER BY I_Aggregate_Obtained_Marks desc
	) I_Student_Rank 
from dbo.T_Student_Result where I_Result_Exam_Schedule_ID= @iExamScheduleID and I_Aggregate_Percentage is not null
) as TSR1 ON TSR1.I_Student_Result_ID = TSR.I_Student_Result_ID


-- truncate table dbo.T_Student_Result_Detail 

INSERT INTO dbo.T_Student_Result_Detail (I_Student_Result_ID,I_Result_Subject_Rule_ID,I_Full_Marks,I_Obtained_Marks,S_Overall_Exam_Sub_Attendance,I_Sequnce_No)
select 
TSR.I_Student_Result_ID
,TRSR.I_Result_Subject_Rule_ID
,SUM(ISNULL(t1.FullMarks,0))
,CASE WHEN MAX(ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	SUM(ISNULL(t1.EffectiveMarks,0))
	ELSE NULL 
	END AS EffectiveMarks
,CASE WHEN MAX(ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	'Present'
	ELSE 'Fully Absent' 	
	END as S_Overall_Exam_Sub_Attendance
,max(t1.SequenceNo) as SequenceNo
from #tempStudent as t1 
join dbo.T_Result_Exam_Schedule as TRES on t1.CourseID = TRES.I_Course_ID and t1.TermID = TRES.I_Term_ID
join dbo.T_Student_Detail as TSD ON TSD.I_Student_Detail_ID = t1.StudentDetailID
join dbo.T_Student_Result as TSR ON TSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID
	AND TSR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
JOIN T_Result_Subject_Rule AS TRSR ON TRSR.I_Module_ID = t1.ExamComponentID 
	AND TRSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID
where coalesce(t1.MarksObtained,0) != '0.01' 
GROUP BY TSR.I_Student_Result_ID
,TRSR.I_Result_Subject_Rule_ID


UPDATE 
  TSRD 
  SET TSRD.I_Highest_Obtained_Marks = TSRD1.I_Highest_Obtained_Marks
  FROM
  dbo.T_Student_Result as TSR 
  JOIN dbo.T_Student_Result_Detail as TSRD ON TSRD.I_Student_Result_ID = TSR.I_Student_Result_ID
  JOIN 
  (
  select TSR.I_Result_Exam_Schedule_ID,TSRD.I_Result_Subject_Rule_ID 
  , MAX(I_Obtained_Marks) as I_Highest_Obtained_Marks
  from dbo.T_Student_Result as TSR 
  JOIN dbo.T_Student_Result_Detail as TSRD ON TSRD.I_Student_Result_ID = TSR.I_Student_Result_ID
  where I_Result_Exam_Schedule_ID = @iExamScheduleID
  and I_Aggregate_Percentage is not null
  GROUP BY TSR.I_Result_Exam_Schedule_ID,TSRD.I_Result_Subject_Rule_ID
  ) AS TSRD1 ON TSR.I_Result_Exam_Schedule_ID = TSRD1.I_Result_Exam_Schedule_ID
	AND TSRD1.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID
  and TSRD.I_Obtained_Marks is not null


insert into dbo.T_Student_Result_Detail_Breakup (I_Student_Result_Detail_ID,I_Result_Subject_Group_Rule_ID,I_Full_Marks,I_Obtained_Marks,S_Exam_Attendance)
select 
TSRD.I_Student_Result_Detail_ID
,TRSG.I_Result_Subject_Group_Rule_ID
,t1.FullMarks
,CASE WHEN (ISNULL(t1.EffectiveMarks,0)) > 0 THEN t1.EffectiveMarks
	ELSE NULL
	END AS EffectiveMarks
,CASE WHEN (ISNULL(t1.EffectiveMarks,0)) > 0 THEN 
	'Present'
	ELSE 'Absent' 	
	END as S_Exam_Attendance
from #tempStudent as t1 
join dbo.T_Result_Exam_Schedule as TRES on t1.CourseID = TRES.I_Course_ID and t1.TermID = TRES.I_Term_ID
join dbo.T_Student_Detail as TSD ON TSD.I_Student_Detail_ID = t1.StudentDetailID
join dbo.T_Student_Result as TSR ON TSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID
	AND TSR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
JOIN T_Result_Subject_Rule AS TRSR ON TRSR.I_Module_ID = t1.ExamComponentID 
	AND TRSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID
JOIN dbo.T_Student_Result_Detail as TSRD ON  TSRD.I_Student_Result_ID = TSR.I_Student_Result_ID
	AND TSRD.I_Result_Subject_Rule_ID = TRSR.I_Result_Subject_Rule_ID
JOIN T_Result_Subject_Group_Rule AS TRSG ON TRSG.I_Result_Subject_Rule_ID = TRSR.I_Result_Subject_Rule_ID 
	AND TRSG.S_Group_Name = t1.ModuleName
where coalesce(t1.MarksObtained,0) != '0.01' 
order by TSRD.I_Student_Result_Detail_ID,TRSG.I_Result_Subject_Group_Rule_ID


UPDATE 
TSRDB
SET TSRDB.S_Grade_Marks = VEGM.S_Symbol
,TSRDB.I_Exam_Grade_Master_ID = VEGM.I_EXAM_Grade_Master_ID
from #tempStudent as t1 
join dbo.T_Result_Exam_Schedule as TRES on t1.CourseID = TRES.I_Course_ID and t1.TermID = TRES.I_Term_ID
join dbo.T_Student_Detail as TSD ON TSD.I_Student_Detail_ID = t1.StudentDetailID
join dbo.T_Student_Result as TSR ON TSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID
	AND TSR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
JOIN dbo.T_Student_Result_Detail as TSRD ON TSRD.I_Student_Result_ID = TSR.I_Student_Result_ID
join dbo.T_Student_Result_Detail_Breakup as TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID
join dbo.T_School_Group_Class AS TSGC ON TSGC.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
JOIN dbo.V_Exam_Grade_Master as VEGM on VEGM.I_Class_ID = TSGC.I_Class_ID AND VEGM.I_School_Group_ID = TSGC.I_School_Group_ID
--	and (cast(((CAST(TSRDB.I_Obtained_Marks as decimal(8,2))/CAST(TSRDB.I_Full_Marks  as decimal(8,2)))*100) as decimal(8,2))BETWEEN I_Lower_Limit AND I_Upper_Limit)
	and (((TSRDB.I_Obtained_Marks /TSRDB.I_Full_Marks) *100) BETWEEN I_Lower_Limit AND I_Upper_Limit)
where I_Grade_Marks_View=1
;




-- select 1 StatusFlag,'Result Process succesfully' Message


    END
