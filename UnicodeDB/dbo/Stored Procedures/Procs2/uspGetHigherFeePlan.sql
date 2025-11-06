--Debarshi Basu 19 September 2010
 
CREATE PROCEDURE [dbo].[uspGetHigherFeePlan]
-- Add the parameters for the stored procedure here
	@iDestBatchID INT,
	@iOriginCenterID INT,
	@iDestCenterID INT
AS
BEGIN
		
	SELECT TOP 1 CBD.I_Course_Fee_Plan_ID,CBD.I_Minimum_Regn_Amt,CBD.I_Centre_Id,
	CFP.N_TotalLumpSum,CFP.S_Fee_Plan_Name,CM.S_Course_Code,CM.S_Course_Name,
	DP.S_Pattern_Name,CFP.N_TotalInstallment,DP.I_Delivery_Pattern_ID,CM.I_Course_ID
	FROM dbo.T_Center_Batch_Details CBD
	INNER JOIN dbo.T_Course_Fee_Plan CFP
	ON CBD.I_Course_Fee_Plan_ID = CFP.I_Course_Fee_Plan_ID
	INNER JOIN dbo.T_Student_Batch_Master SBM
	ON CFP.I_Course_ID = SBM.I_Course_ID
	INNER JOIN dbo.T_Course_Master CM
	ON SBM.I_Course_ID = CM.I_Course_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master DP
	ON SBM.I_Delivery_Pattern_ID = DP.I_Delivery_Pattern_ID
	WHERE CBD.I_Centre_Id IN (@iOriginCenterID,@iDestCenterID)
	AND SBM.I_Batch_ID = @iDestBatchID
	ORDER BY N_TotalLumpSum DESC
END
