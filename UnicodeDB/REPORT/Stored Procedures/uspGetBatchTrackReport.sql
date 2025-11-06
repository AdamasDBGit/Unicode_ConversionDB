CREATE PROCEDURE [REPORT].[uspGetBatchTrackReport]
AS
BEGIN


select TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
TSBM.Dt_BatchStartDate,STSTRENGTH.StartingBatchStrength,CURRSTRENGTH.CurrentBatchStrength,LASTSM.S_Term_Name
from T_Student_Batch_Master TSBM
LEFT JOIN
(
	select A.I_Batch_ID,COUNT(DISTINCT B.I_Student_ID) AS StartingBatchStrength 
	from T_Student_Batch_Master A
	inner join T_Student_Batch_Details B on A.I_Batch_ID=B.I_Batch_ID
	where
	CONVERT(DATE,B.Dt_Valid_From)<=CONVERT(DATE,A.Dt_BatchStartDate)
	and B.I_Status in (0,1,2)
	group by A.I_Batch_ID
) STSTRENGTH ON TSBM.I_Batch_ID=STSTRENGTH.I_Batch_ID
LEFT JOIN
(
	select A.I_Batch_ID,COUNT(DISTINCT B.I_Student_ID) AS CurrentBatchStrength 
	from T_Student_Batch_Master A
	inner join T_Student_Batch_Details B on A.I_Batch_ID=B.I_Batch_ID
	where B.I_Status in (1)
	group by A.I_Batch_ID
) CURRSTRENGTH ON TSBM.I_Batch_ID=CURRSTRENGTH.I_Batch_ID
LEFT JOIN
(
	select T1.I_Batch_ID,TTM.S_Term_Name from
	(
		select A.I_Batch_ID,MAX(A.I_Term_ID) as MaxTermID from EXAMINATION.T_Batch_Exam_Map A
		inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
		group by A.I_Batch_ID
	) T1
	inner join T_Term_Master TTM on T1.MaxTermID=TTM.I_Term_ID
) LASTSM on TSBM.I_Batch_ID=LASTSM.I_Batch_ID
INNER JOIN T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
INNER JOIN T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
INNER JOIN T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TCBD.I_Centre_Id
where
TCHND.I_Brand_ID=109 and TSBM.S_Batch_Code='GCGEN2021063'


END
