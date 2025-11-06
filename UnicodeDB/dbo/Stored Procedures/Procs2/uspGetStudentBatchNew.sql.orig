CREATE PROCEDURE [dbo].[uspGetStudentBatchNew](@StudentID VARCHAR(18), @BrandID INT=NULL)
AS
BEGIN

	IF(@BrandID<=0)
		SET @BrandID=NULL

	SELECT TSBM.I_Course_ID,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	CAST(YEAR(TSBM.Dt_BatchStartDate) AS VARCHAR(4))+'-'+SUBSTRING(CAST(YEAR(TSBM.Dt_Course_Expected_End_Date) AS VARCHAR(4)),3,2) as AcademicSession
	FROM dbo.T_Student_Detail AS TSD
	inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID
	INNER JOIN
	(
		select DISTINCT B.I_Student_Detail_ID,A.I_Batch_ID 
		from EXAMINATION.T_Batch_Exam_Map A
		inner join EXAMINATION.T_Student_Marks B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
		where
		A.I_Status=1
	) TSBD on TSBD.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
	inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
	WHERE TSD.S_Student_ID=@StudentID 
	--AND TSBD.I_Status in (1,2)
	--AND TSBD.I_Status in (1)
	and TSCD.I_Centre_Id in (1,36)
	and TCHND.I_Brand_ID=ISNULL(@BrandID,TCHND.I_Brand_ID)
	ORDER BY TSBM.I_Course_ID

END
