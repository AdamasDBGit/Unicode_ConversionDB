/*******************************************************
Author	:     Subhendu Chatterjee
Date	:	  28/04/2011
Description : This SP retrieves the Refund Receipt Data
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetReportOnRefundReceipt] 
(
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@sHierarchyList varchar (MAX),
	@dtStartDate datetime=NULL,
	@dtEndDate datetime=NULL
)
AS
BEGIN TRY
	
SELECT	[TBCD].[I_Brand_ID],
		[TBM].[S_Brand_Code],
		[TCM].centerName AS S_Center_Name, 
		[TSD].[S_Student_ID],
		tsd.S_First_Name+' '+ tsd.[S_Middle_Name]+' '+tsd.S_Last_Name as Stud_name,
		[TRH].[S_Receipt_No],
		[TRH].[Dt_Receipt_Date],
		[TRH].[N_Receipt_Amount], 
		[TRH].[N_Tax_Amount],
		[IP].S_Invoice_No,
		IP.N_Invoice_Amount,
		IP.N_Tax_Amount AS InvoiceTaxAmount,
		[TRH].I_Status,
		TSBM.S_Batch_Name
FROM [dbo].[T_Receipt_Header] AS TRH
		INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) TCM
		ON [TRH].[I_Centre_Id] = [TCM].centerID
		INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
		ON [TCM].centerID = [TBCD].[I_Centre_Id]
		INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID=TBM.I_Brand_ID
		INNER JOIN [dbo].[T_Student_Detail] AS TSD
		ON [TSD].[I_Student_Detail_ID] = [TRH].[I_Student_Detail_ID]
		
		Inner JOIN dbo.T_Student_Batch_Details TSBD WITH(NOLOCK)
		ON TSBD.I_Student_ID=TSD.I_Student_Detail_ID
		Inner JOIN dbo.T_Student_Batch_Master TSBM WITH(NOLOCK)
		ON TSBD.I_Batch_ID=TSBM.I_Batch_ID

		LEFT JOIN dbo.T_Invoice_Parent IP on TRH.I_Invoice_Header_ID=IP.I_Invoice_Header_ID
WHERE ([TRH].[I_Receipt_Type] IN (21) or [TRH].I_Status=0)
		AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtStartDate,[TRH].[Dt_Receipt_Date])) <= 0
		AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtEndDate,[TRH].[Dt_Receipt_Date])) >= 0
		AND TBCD.I_Brand_ID=ISNULL(@iBrandID,TBCD.I_Brand_ID)
ORDER BY [TBM].[S_Brand_Code], [TRH].[I_Receipt_Header_ID]
			
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
