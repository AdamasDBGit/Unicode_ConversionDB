CREATE PROCEDURE [dbo].[uspFTBatchGetAccrualIncomeForCenter] --1,'30-JUN-2008'
	@iCenterID INT,
	@dtCurrentDate DATETIME

AS

BEGIN

	SELECT ISNULL(ICH.N_Amount,0) AS N_Amount,SCD.Dt_Course_Start_Date,
		ISNULL(SCD.Dt_Course_Actual_End_Date,ISNULL(SCD.Dt_Course_Expected_End_Date,@dtCurrentDate)) AS Dt_Course_Actual_End_Date,
		ISNULL(SCD.Dt_Course_Expected_End_Date,@dtCurrentDate) AS Dt_Course_Expected_End_Date
	FROM dbo.T_Invoice_Parent IP
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD
	ON IP.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	AND ICH.I_Course_ID = SCD.I_Course_ID
	WHERE IP.I_Centre_Id = @iCenterID
		AND SCD.I_Status = 1
		AND IP.I_Status = 1

END
