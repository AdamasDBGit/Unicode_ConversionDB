CREATE PROCEDURE [dbo].[uspGetStudentBatch](@StudentID VARCHAR(18), @BrandID INT=NULL)
AS
BEGIN

	IF(@BrandID<=0)
		SET @BrandID=NULL

	SELECT TOP 1 TSBM.I_Batch_ID,TSBM.S_Batch_Name FROM dbo.T_Student_Detail AS TSD
	inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
	INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
	inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
	WHERE TSD.S_Student_ID=@StudentID 
	--AND TSBD.I_Status in (1,2)
	AND TSBD.I_Status in (1)
	and TSCD.I_Centre_Id in (1,36)
	and TCHND.I_Brand_ID=ISNULL(@BrandID,TCHND.I_Brand_ID)
	ORDER BY TSBD.Dt_Valid_From DESC

END
