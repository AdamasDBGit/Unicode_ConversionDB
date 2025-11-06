-- =============================================  
-- Author:  <Susmita Paul>  
-- Create date: <2025-July-17>  
-- Description: <Update/Apply Adhoc Discounted Invoice Details>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_Update_Invoice_Details_Adhoc_Discount]  
 -- Add the parameters for the stored procedure here  
 @iInvoiceHeaderID int,  
 @iUpdatedby int,  
 @InstallmentComponentWiseDiscount UT_Installment_Component_Wise_Discount  readonly  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 --------Capturing Data into Log Table------  
 insert into T_ERP_Adhoc_Discount_Log  
 (  
 I_Invoice_Header_ID ,  
 I_Invoice_Child_Header_ID,  
 Pre_Annual_Discounted_InvoiceAmount,  
 Pre_Annual_Discounted_InvoiceChild_Amount,  
 I_Invoice_Detail_ID,  
 I_Fee_Component_ID,  
 N_PreBase_Amount, 
 N_Discounted_Amount,  
 Pre_DiscountSchemeID,  
 Pre_Adhoc_Fix_Discount_Value,  
 Pre_Adhoc_Perc_Discount_Value,  
 Pre_CGST,  
 Pre_SGST,  
 Pre_IGST,  
 DiscountAppliedBy,  
 Dt_DiscountAppliedAt,
 N_PreDiscount_Amount
 )  
 select DISTinct @iInvoiceHeaderID,ICH.I_Invoice_Child_Header_ID
,IVP.N_Invoice_Amount,ICH.N_Amount,ICD.I_Invoice_Detail_ID,ICD.I_Fee_Component_ID,ICD.N_Amount_Due,UT.DiscountedBaseAmount,IVP.I_Discount_Scheme_ID
,ICD.N_Fix_Discount,ICD.N_Perc_Discount,ISNULL(OldTAX.CGST,0),ISNULL(OldTAX.SGST,0),ISNULL(OldTAX.IGST,0)
,@iUpdatedby,Getdate(),ICD.N_Disc_Amount  as DiscountAmt
from T_Invoice_Child_Detail ICD 
Inner JOin @InstallmentComponentWiseDiscount UT ON ICD.I_Invoice_Detail_ID=UT.I_Invoice_Detail_ID
Inner Join T_Invoice_Child_Header ICH ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
Inner JOIN T_Invoice_Parent IVP ON IVP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
Left OUTER JOIN (
SELECT 
    I_Invoice_Detail_ID,
    ISNULL([7], 0) AS CGST,
    ISNULL([8], 0) AS SGST,
    ISNULL([9], 0) AS IGST
FROM
(
    SELECT 
        I_Invoice_Detail_ID, 
        I_Tax_ID, 
        N_Tax_Value_Scheduled
    FROM 
        T_Invoice_Detail_Tax
    WHERE 
        I_Tax_ID IN (7,8,9)
) AS SourceTable
PIVOT
(
    SUM(N_Tax_Value_Scheduled)
    FOR I_Tax_ID IN ([7], [8], [9])
) AS PivotTable

) as OldTAX on OldTAX.I_Invoice_Detail_ID=UT.I_Invoice_Detail_ID
Where IVP.I_Invoice_Header_ID=@iInvoiceHeaderID
  
-------***************************------------------------





-----update child detail -------

Update ICD SET ICD.N_Amount_Due=UTU.[DiscountedBaseAmount],ICD.N_Fix_Discount=UTU.Fixed_DiscountValue
,ICD.N_Perc_Discount=UTU.[Perc_DiscountValue],ICD.N_Disc_Amount=ISNULL(ICD.N_Gross_Amount,ICD.N_Amount_Due)-UTU.[DiscountedBaseAmount]
from T_Invoice_Child_Detail ICD
Inner Join @InstallmentComponentWiseDiscount UTU ON UTU.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
and ICD.I_Fee_Component_ID=UTU.I_Fee_Component_ID


-------Update Invoicechild Details TAX-----
Update IDT SET IDT.N_Tax_Value=UTTAX.TaxAmount,IDT.N_Tax_Value_Scheduled=UTTAX.TaxAmount
from T_Invoice_Detail_Tax IDT 
Inner JOin (
SELECT 
    I_Invoice_Detail_ID,
    TaxID,
    TaxAmount
FROM (
    SELECT 
        I_Invoice_Detail_ID,
        DiscountedCGST,
        DiscountedSGST,
        DiscountedIGST
    FROM @InstallmentComponentWiseDiscount
) AS SourceTable
UNPIVOT (
    TaxAmount FOR TaxType IN (DiscountedCGST, DiscountedSGST, DiscountedIGST)
) AS UnpivotedTable
CROSS APPLY (
    SELECT 
        CASE TaxType
            WHEN 'DiscountedCGST' THEN 7
            WHEN 'DiscountedSGST' THEN 8
            WHEN 'DiscountedIGST' THEN 9
        END AS TaxID
) AS TaxMapping
WHERE TaxAmount IS NOT NULL
) as UTTAX On UTTAx.I_Invoice_Detail_ID=IDT.I_Invoice_Detail_ID and UTTAX.TaxID=IDT.I_Tax_ID



----Update Invoice Parent amount---------



---fetch current detail for update

Declare @currTotalInvAmount Numeric(12,2),@currTotalTaxvalue numeric(12,2),@ChildHeaderTotalAMount Numeric(12,2)
,@childheaderTotaltaxAmount Numeric(12,2)
  Select @currTotalInvAmount=SUM(ISNULL(ICD.N_Amount_Due,0)) ,@currTotalTaxvalue=SUM(ISNULL(IDT.N_Tax_Value_Scheduled,0)) 
from T_Invoice_Child_Detail ICD 
Inner Join T_Invoice_Child_Header ICH ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
Inner Join T_Invoice_Parent IVP ON IVP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
Left OUTER Join T_Invoice_Detail_Tax IDT ON IDt.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
where IVP.I_Invoice_Header_ID=@iInvoiceHeaderID




Update T_Invoice_Parent set N_Invoice_Amount=@currTotalInvAmount ,N_Tax_Amount=@currTotalTaxvalue where I_Invoice_Header_ID=@iInvoiceHeaderID

------Updating Child Header------------------------
Update ICH set ich.N_Amount=tich.childheadertotalamount,ICH.N_Tax_Amount=tich.childheadertotalTax

from T_Invoice_Child_Header ICH 
Inner Join (
Select SUM(ISNULL(ICD.N_Amount_Due,0)) childheadertotalamount
,SUM(ISNULL(IDT.N_Tax_Value_Scheduled,0)) as childheadertotalTax
,ICH.I_Invoice_Child_Header_ID 
from T_Invoice_Child_Detail ICD 
Inner Join T_Invoice_Child_Header ICH ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
--and ICH.I_Invoice_Child_Header_ID=@ChildHeaderID
Inner Join T_Invoice_Parent IVP ON IVP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
Left OUTER Join T_Invoice_Detail_Tax IDT ON IDt.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
where IVP.I_Invoice_Header_ID=@iInvoiceHeaderID --and ICH.I_Invoice_Child_Header_ID=@ChildHeaderID
GROUP by ICH.I_Invoice_Child_Header_ID
) tich on tich.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID

------Update Discount Scheme ID =0 and TypeID =2
Update  T_Invoice_Parent set I_Discount_Scheme_ID=0,I_DiscountType_ID=2
 where I_Invoice_Header_ID=@iInvoiceHeaderID

update ICH set ich.I_Discount_Scheme_ID=0 from  T_Invoice_Child_Header ICH 
Inner Join T_Invoice_Parent IVp ON ivp.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
where IVP.I_Invoice_Header_ID=@iInvoiceHeaderID

update ICD set icd.I_DiscountType_ID=2 from T_Invoice_Child_Detail ICD 
Inner Join @InstallmentComponentWiseDiscount Ut on ut.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
and ut.I_Fee_Component_ID=ICD.I_Fee_Component_ID

select 1 StatusFlag,'Adhoc Discount Applied Successfully' Message


END  