CREATE PROCEDURE [dbo].[uspGetStudentDataForAPI](@StudentID Nnvarchar(max)=null,@BrandID INT,@BatchCode Nnvarchar(max)=NULL)
AS
BEGIN

IF (@BatchCode IS NULL)
BEGIN

	SELECT TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,TSD.S_Mobile_No,TSD.S_Email_ID,
	TCHND.S_Brand_Name,TCHND.S_Center_Name,TCM.S_Course_Name,TSBM.S_Batch_Name,ISNULL(TSD.S_OrgEmailID,'') as OrgEmailID,
	ISNULL(TSD.S_OrgEmailPassword,'') as OrgEmailPassword,TCM.S_Course_Category,TCM.I_Course_ID,TSBM.I_Batch_ID,TCHND.I_Center_ID
	FROM dbo.T_Student_Detail AS TSD
	INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND TSCD.I_Status=1
	INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TSCD.I_Centre_Id=TCHND.I_Center_ID
	LEFT JOIN
	(
		SELECT TSBD.I_Student_ID,TSBD.I_Batch_ID FROM dbo.T_Student_Batch_Details AS TSBD
		INNER JOIN
		(
		SELECT TSBD.I_Student_ID,MAX(ISNULL(TSBD.Dt_Valid_From,GETDATE())) AS MaxValidFrom 
		FROM dbo.T_Student_Batch_Details AS TSBD WHERE TSBD.I_Status=1
		GROUP BY TSBD.I_Student_ID
		) T1 ON T1.I_Student_ID = TSBD.I_Student_ID AND ISNULL(TSBD.Dt_Valid_From,GETDATE())=T1.MaxValidFrom
	) TBATCH ON TSD.I_Student_Detail_ID=TBATCH.I_Student_ID
	LEFT JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBATCH.I_Batch_ID --and TSBM.S_Batch_Code=ISNULL(@BatchCode,TSBM.S_Batch_Code)
	LEFT JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
	WHERE TSD.S_Student_ID=ISNULL(@StudentID,TSD.S_Student_ID) AND TCHND.I_Brand_ID=@BrandID
	and TSD.I_Status=1
	order by TSD.S_Student_ID DESC

END
ELSE
BEGIN

	SELECT TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,TSD.S_Mobile_No,TSD.S_Email_ID,
	TCHND.S_Brand_Name,TCHND.S_Center_Name,TCM.S_Course_Name,TSBM.S_Batch_Name,ISNULL(TSD.S_OrgEmailID,'') as OrgEmailID,
	ISNULL(TSD.S_OrgEmailPassword,'') as OrgEmailPassword,TCM.S_Course_Category,TCM.I_Course_ID,TSBM.I_Batch_ID,TCHND.I_Center_ID
	FROM dbo.T_Student_Detail AS TSD
	INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND TSCD.I_Status=1
	INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TSCD.I_Centre_Id=TCHND.I_Center_ID
	INNER JOIN T_Student_Batch_Details TBATCH on TSD.I_Student_Detail_ID=TBATCH.I_Student_ID and TBATCH.I_Status=1
	INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBATCH.I_Batch_ID --and TSBM.S_Batch_Code=ISNULL(@BatchCode,TSBM.S_Batch_Code)
	INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
	WHERE TSD.S_Student_ID=ISNULL(@StudentID,TSD.S_Student_ID) AND TCHND.I_Brand_ID=@BrandID
	and TSD.I_Status=1 and TSBM.S_Batch_Code=@BatchCode
	order by TSD.S_Student_ID DESC

END

	

END

