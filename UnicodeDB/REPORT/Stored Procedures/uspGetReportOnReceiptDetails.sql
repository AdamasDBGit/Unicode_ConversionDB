/*******************************************************
Author	:     Subhendu Chatterjee
Date	:	  26/04/2011
Description : This SP retrieves the Receipt Datails
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetReportOnReceiptDetails] 
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar (MAX),
	@dtStartDate datetime=NULL,
	@dtEndDate datetime=NULL,
	@iBrandID INT
)
AS
BEGIN TRY
	
-- For Invoice Based Payments

SELECT DISTINCT
'IBP' AS RType, 
[TIP].[I_Invoice_Header_ID] AS DocHeaderID,
[TIP].[Dt_Invoice_Date] AS DocDate,
[FN1].[centerCode] as S_Center_Code, 
[FN1].[centerName] as S_Center_Name,
[TSD].[S_Student_ID],
[TSD].[S_First_Name],
[TSD].[S_Middle_Name], 
[TSD].[S_Last_Name], 
[TIP].[S_Invoice_No],
[TIP].[I_Status],
[TCM2].[S_Course_Name],
[TICD1].[I_Installment_No],
[TICD1].[N_Amount_Due] AS Amount_Due_1st,
[TICD2].[N_Amount_Due] AS Amount_Due_2nd,
[TICH].[C_Is_LumpSum],
[TCFP].[S_Fee_Plan_Name],
'INR' AS INR,
[TIP].[N_Invoice_Amount] AS Amount,
[TIP].[N_Invoice_Amount] + [TIP].[N_Tax_Amount] AS AmountWithTax,
[TIP].[N_Discount_Amount],
[TSBM].[Dt_BatchStartDate], 
ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date]) AS Course_Expected_End_Date,
DATEDIFF(dd,[TSBM].[Dt_BatchStartDate],ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date])) AS DiffOfDays
FROM [dbo].[T_Receipt_Header] AS TRH
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON TRH.I_Centre_Id=FN1.centerID
INNER JOIN [dbo].[T_Invoice_Parent] AS TIP
ON [TIP].[I_Invoice_Header_ID] = [TRH].[I_Invoice_Header_ID]
INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH
ON [TRH].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]
INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
ON FN1.centerID = [TBCD].[I_Centre_Id]
INNER JOIN [dbo].[T_Student_Detail] AS TSD
ON [TRH].[I_Student_Detail_ID] = [TSD].[I_Student_Detail_ID]
INNER JOIN [dbo].[T_Course_Master] AS TCM2
ON [TICH].[I_Course_ID] = [TCM2].[I_Course_ID]
INNER JOIN [dbo].[T_Course_Fee_Plan] AS TCFP
ON [TCFP].[I_Course_Fee_Plan_ID] = [TICH].[I_Course_FeePlan_ID]
----------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD
----------ON [TICH].[I_Course_ID] = [TSCD].[I_Course_ID]
----------AND [TSCD].[I_Student_Detail_ID] = [TSD].[I_Student_Detail_ID]
INNER JOIN dbo.T_Student_Batch_Details AS tsbd
ON tsbd.I_Student_ID = [TSD].[I_Student_Detail_ID]
INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
ON [TSBM].[I_Batch_ID] = tsbd.[I_Batch_ID]
LEFT OUTER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD1
ON [TICH].[I_Invoice_Child_Header_ID] = [TICD1].[I_Invoice_Child_Header_ID]
AND [TICD1].[I_Fee_Component_ID] = 21
LEFT OUTER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD2
ON [TICH].[I_Invoice_Child_Header_ID] = [TICD2].[I_Invoice_Child_Header_ID]
AND [TICD2].[I_Fee_Component_ID] = 23
WHERE [TBCD].[I_Brand_ID] = @iBrandID
AND DATEDIFF(dd,[TIP].[Dt_Invoice_Date],ISNULL(@dtStartDate,[TIP].[Dt_Invoice_Date])) <= 0
AND DATEDIFF(dd,[TIP].[Dt_Invoice_Date],ISNULL(@dtEndDate,[TIP].[Dt_Invoice_Date])) >= 0
--ORDER BY [TCM].[S_Center_Code], [TSD].[S_Student_ID]

Union
-- For On-Account Receipts

SELECT DISTINCT 
'OAR' AS RType,
[TRH].[I_Receipt_Header_ID] AS DocHeaderID,
[TRH].[Dt_Receipt_Date] AS DocDate,
[TCM].[centerCode] S_Center_Code, 
[TCM].[centerName] S_Center_Name,
[TSD].[S_Student_ID],
[TSD].[S_First_Name],
[TSD].[S_Middle_Name],
[TSD].[S_Last_Name],
NULL AS S_Invoice_No,
NULL AS I_Status,
--'',
[TCM2].[S_Course_Name],
NULL AS I_Installment_No,
0 AS Amount_Due_1st,
0 AS Amount_Due_2nd,
NULL AS C_Is_LumpSum,
NULL AS S_Fee_Plan_Name,
'INR' AS INR,
[TRH].[N_Receipt_Amount] AS Amount,
[TRH].[N_Receipt_Amount] + [TRH].[N_Tax_Amount] AS AmountWithTax,
0 AS N_Discount_Amount,
[TSBM].[Dt_BatchStartDate], 
ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date]) AS Course_Expected_End_Date,
DATEDIFF(dd,[TSBM].[Dt_BatchStartDate],ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date])) AS DiffOfDays
FROM [dbo].[T_Receipt_Header] AS TRH
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) AS TCM
ON [TRH].[I_Centre_Id] = [TCM].centerID
INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
ON [TCM].centerID = [TBCD].[I_Centre_Id]
INNER JOIN [dbo].[T_Student_Detail] AS TSD
ON [TSD].[I_Student_Detail_ID] = [TRH].[I_Student_Detail_ID]
--------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD
--------ON [TRH].[I_Student_Detail_ID] = [TSCD].[I_Student_Detail_ID]
INNER JOIN dbo.T_Student_Batch_Details AS tsbd
ON tsbd.I_Student_ID = TSD.I_Student_Detail_ID
INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
ON [TSBM].[I_Batch_ID] = [tsbd].[I_Batch_ID]
INNER JOIN [dbo].[T_Course_Master] AS TCM2
ON TSBM.[I_Course_ID] = [TCM2].[I_Course_ID]
WHERE [TRH].[I_Invoice_Header_ID] IS NULL
AND [TBCD].[I_Brand_ID] = @IBrandID
AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtStartDate,[TRH].[Dt_Receipt_Date])) <= 0
AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtEndDate,[TRH].[Dt_Receipt_Date])) >= 0
--ORDER BY [TCM].[S_Center_Code], [TSD].[S_Student_ID]
union
-- For Registration Receipts

SELECT DISTINCT
'RR' AS RType, 
[TRH].[I_Receipt_Header_ID] AS DocHeaderID,
[TRH].[Dt_Receipt_Date] AS DocDate,
[TCM].[centerCode] AS S_Center_Code, 
[TCM].[centerName] AS S_Center_Name,
Cast(TERD.[I_Enquiry_Regn_ID] as VARCHAR(500)) As S_Student_ID,
TERD.[S_First_Name],
TERD.[S_Middle_Name],
TERD.[S_Last_Name],
NULL AS S_Invoice_No,
NULL AS I_Status,
--'',
[TCM3].[S_Course_Name],
NULL AS I_Installment_No,
0 AS Amount_Due_1st,
0 AS Amount_Due_2nd,
NULL AS C_Is_LumpSum,
NULL AS S_Fee_Plan_Name,
'INR' AS INR,
[TRH].[N_Receipt_Amount] AS Amount,
[TRH].[N_Receipt_Amount] + [TRH].[N_Tax_Amount] AS AmountWithTax,
0 AS N_Discount_Amount,
[TSBM].[Dt_BatchStartDate], 
ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date]) AS Course_Expected_End_Date,
DATEDIFF(dd,[TSBM].[Dt_BatchStartDate],ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date])) AS DiffOfDays
FROM [dbo].[T_Receipt_Header] AS TRH
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) AS TCM
ON [TRH].[I_Centre_Id] = [TCM].centerID
INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
ON [TCM].centerID = [TBCD].[I_Centre_Id]
INNER JOIN [dbo].[T_Enquiry_Regn_Detail] AS TERD
ON [TRH].[I_Enquiry_Regn_ID] = [TERD].[I_Enquiry_Regn_ID]
INNER JOIN [dbo].[T_Student_Registration_Details] AS TSRD
ON [TERD].[I_Enquiry_Regn_ID] = [TSRD].[I_Enquiry_Regn_ID]
INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
ON [TSBM].[I_Batch_ID] = TSRD.[I_Batch_ID]
INNER JOIN [dbo].[T_Course_Master] AS TCM3
ON [TCM3].[I_Course_ID] = [TSBM].[I_Course_ID]
WHERE [TRH].[I_Invoice_Header_ID] IS NULL
AND [TBCD].[I_Brand_ID] = @iBrandID
AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtStartDate,[TRH].[Dt_Receipt_Date])) <= 0
AND DATEDIFF(dd,[TRH].[Dt_Receipt_Date],ISNULL(@dtEndDate,[TRH].[Dt_Receipt_Date])) >= 0
ORDER BY RType,S_Center_Code, S_Student_ID


			
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
