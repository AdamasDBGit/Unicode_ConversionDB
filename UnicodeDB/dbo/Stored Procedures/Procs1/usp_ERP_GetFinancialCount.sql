-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Oct-29>
-- Description:	<To Get Dashboard Count>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetFinancialCount] 
	-- Add the parameters for the stored procedure here
	@iBrandID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DECLARE @SessionStartDate datetime,@SessionEndDate datetime,@SessionID int


	Create Table #invoiceDetails
	(
	I_Invoice_Header_ID INT,
	BaseAmountPayable decimal(8,2),
	BaseTaxAmountPayable decimal(8,2),
	InstallmentDate Datetime,
	BaseInstallmentAmount decimal(8,2),
	InstallmentTax decimal(8,2)
	)

	Create Table #receiptDetails
	(
	I_Receipt_Header_ID INT,
	BaseReceiptAmount decimal(8,2),
	ReceiptTax decimal(8,2),
	Is_Adhoc bit
	)



	select @SessionID=I_School_Session_ID,
	@SessionStartDate=Dt_Session_Start_Date,
	@SessionEndDate=Dt_Session_End_Date
	from T_School_Academic_Session_Master where I_Brand_ID=@iBrandID and I_Current_Session=1

	insert into #invoiceDetails
	select TIP.I_Invoice_Header_ID,TIP.N_Invoice_Amount as BaseAmountPayable,TIP.N_Tax_Amount BaseTaxAmountPayable, 
	ICD.Dt_Installment_Date,ICD.N_Amount_Due,ISNULL(ICD.N_CGST,0)+ISNULL(ICD.N_SGST,0)+ISNULL(ICD.N_IGST,0)
	from T_Invoice_Parent as TIP
	inner join
	T_Invoice_Child_Header as ICH on TIP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
	inner join
	T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
	inner join
	T_Brand_Center_Details as BCD on BCD.I_Centre_Id=TIP.I_Centre_Id
	where 
	TIP.I_Status=1 
	and CONVERT(DATE,TIP.Dt_Invoice_Date) >= CONVERT(DATE,@SessionStartDate)
	and CONVERT(DATE,TIP.Dt_Invoice_Date) <= CONVERT(DATE,@SessionEndDate)
	and BCD.I_Brand_ID=@iBrandID

	select * from #invoiceDetails

	select * from #receiptDetails


	insert into #receiptDetails
	select 
	RH.I_Receipt_Header_ID as ReceiptHeader,
	RH.N_Receipt_Amount as BaseAmountPayment,
	RH.N_Tax_Amount BaseTaxAmountPayment,
CASE 
	WHEN RH.I_Invoice_Header_ID IS NULL THEN 'true' 
	ELSE 'false' END as Is_Adhoc
	from T_Receipt_Header as RH
	inner join
	T_Brand_Center_Details as BCD on BCD.I_Centre_Id=RH.I_Centre_Id
	where 
RH.I_Status=1 and BCD.I_Brand_ID=@iBrandID
	and CONVERT(DATE,Dt_Receipt_Date) >= CONVERT(DATE,@SessionStartDate)
	and CONVERT(DATE,Dt_Receipt_Date) <= CONVERT(DATE,@SessionEndDate)


	------ Annual Amount -------

	SELECT 
 (Adhoc.TotalReceiptAmount+ID.TotalBaseAmountPayable)as TotalAnnualBaseAmountPayable,
    RD.TotalReceiptAmount as TotalAnnualPaidAmount,
	(ID.TotalBaseAmountPayable-RD.TotalReceiptAmount) as ForecastedAmount,
	100 as Rate_TotalAnnualPayable,
(RD.TotalReceiptAmount/(Adhoc.TotalReceiptAmount+ID.TotalBaseAmountPayable)*100)as Rate_TotalAnnualForecastedAmount

FROM 
    (SELECT 
    SUM(BaseAmountPayable) + SUM(BaseTaxAmountPayable) AS TotalBaseAmountPayable
FROM 
    (SELECT DISTINCT I_Invoice_Header_ID, BaseAmountPayable, BaseTaxAmountPayable
     FROM #invoiceDetails) AS DistinctInvoiceDetails) as ID
CROSS JOIN 
    (SELECT SUM(BaseReceiptAmount) + SUM(ReceiptTax) AS TotalReceiptAmount
     FROM #receiptDetails) AS RD
 CROSS JOIN
	 (SELECT SUM(BaseReceiptAmount) + SUM(ReceiptTax) AS TotalReceiptAmount
     FROM #receiptDetails where Is_Adhoc='true') Adhoc

--	----- Installment Amount ------

--SELECT 
--    ID.TotalBaseAmountPayable as TotalAnnualBaseAmountPayable,
--    RD.TotalReceiptAmount as TotalAnnualPaidAmount,
--	(ID.TotalBaseAmountPayable-RD.TotalReceiptAmount) as ForecastedAmount,
--	100 as Rate_TotalAnnualPayable,
--(RD.TotalReceiptAmount/ID.TotalBaseAmountPayable)*100 as Rate_TotalAnnualForecastedAmount

--FROM 
--    (SELECT SUM(BaseAmountPayable) + SUM(BaseTaxAmountPayable) AS TotalBaseAmountPayable 
--     FROM #invoiceDetails) AS ID
--CROSS JOIN 
--    (SELECT SUM(BaseReceiptAmount) + SUM(ReceiptTax) AS TotalReceiptAmount
--     FROM #receiptDetails) AS RD;


END
