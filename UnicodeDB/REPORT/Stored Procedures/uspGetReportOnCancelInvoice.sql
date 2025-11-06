/*******************************************************
Author	:     Subhendu Chatterjee
Date	:	  28/04/2011
Description : This SP retrieves the Cancelled Invoice Data
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetReportOnCancelInvoice] 
(
	-- Add the parameters for the stored procedure here
	@dtStartDate datetime=NULL,
	@dtEndDate datetime=NULL,
	@iBrandID INT,
	@sHierarchyList varchar (MAX)
)
AS
BEGIN TRY
	
SELECT	TCM.[BrandID] AS I_BRAND_ID,[TBM].[S_Brand_Code],[TCM].[centerName] AS S_Center_Name,[TSD].[S_Student_ID],[TIP].[S_Invoice_No],
		[TIP].[N_Invoice_Amount],[TIP].[N_Discount_Amount],[TIP].[N_Tax_Amount],[TIP].[Dt_Invoice_Date],
		[TIP].[Dt_Upd_On] AS Invoice_Cancelled_On
FROM [dbo].[T_Invoice_Parent] AS TIP 
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) TCM
ON [TIP].[I_Centre_Id] = [TCM].centerID
INNER JOIN dbo.T_Brand_Master TBM ON TCM.BrandID=TBM.I_Brand_ID
INNER JOIN [dbo].[T_Student_Detail] AS TSD
ON [TSD].[I_Student_Detail_ID] = [TIP].[I_Student_Detail_ID]
WHERE [TIP].[I_Status] = 0
AND DATEDIFF(dd,[TIP].[Dt_Upd_On],ISNULL(@dtStartDate,[TIP].[Dt_Upd_On])) <= 0
AND DATEDIFF(dd,[TIP].[Dt_Upd_On],ISNULL(@dtEndDate,[TIP].[Dt_Upd_On])) >= 0
AND TCM.brandID=@iBrandID
ORDER BY [TBM].[S_Brand_Code], [TIP].[I_Invoice_Header_ID]

			
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
