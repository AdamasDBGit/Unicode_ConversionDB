
/*****************************************************************************************************************
Created by: Susmita Paul
Date: 2024-Aug-18
Description: Get Onaccount Receipt Details
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[ERP_uspGetOnAccountReceiptDetails]
(
	@iReceiptID int
)

AS
BEGIN



SELECT 
    
	0 DueID,
BCD.I_Brand_ID BrandID,
BCD.I_Centre_Id CenterID,
rh.N_Receipt_Amount Amount,
rh.N_Tax_Amount Tax,
    SUM(CASE WHEN tm.S_Tax_Code = 'CGST' THEN tax.N_Tax_Paid ELSE 0 END) AS CGST,
    SUM(CASE WHEN tm.S_Tax_Code = 'SGST' THEN tax.N_Tax_Paid ELSE 0 END) AS SGST,
    SUM(CASE WHEN tm.S_Tax_Code = 'IGST' THEN tax.N_Tax_Paid ELSE 0 END) AS IGST,
   MAX(CASE WHEN tm.S_Tax_Code = 'CGST' THEN tax.I_Tax_ID ELSE NULL END) AS CGST_Tax_ID,
    MAX(CASE WHEN tm.S_Tax_Code = 'SGST' THEN tax.I_Tax_ID ELSE NULL END) AS SGST_Tax_ID,
     MAX(CASE WHEN tm.S_Tax_Code = 'IGST' THEN tax.I_Tax_ID ELSE NULL END) AS IGST_Tax_ID,
     rh.I_Receipt_Type OnAccReceiptTypeID,
	 rh.I_Enquiry_Regn_ID EnquiryID,
	 rh.I_Receipt_Type ComponetID
FROM 
    T_OnAccount_Receipt_Tax tax
JOIN 
    T_Tax_Master tm ON tax.I_Tax_ID = tm.I_Tax_ID
JOIN 
    T_Receipt_Header rh ON tax.I_Receipt_Header_ID = rh.I_Receipt_Header_ID
	join
T_Brand_Center_Details as BCD on RH.I_Centre_Id=BCD.I_Centre_Id
WHERE 
    tax.I_Receipt_Header_ID = @iReceiptID
GROUP BY 
    rh.I_Receipt_Header_ID,
	BCD.I_Brand_ID ,
BCD.I_Centre_Id ,
rh.N_Receipt_Amount ,
rh.N_Tax_Amount ,
 rh.I_Receipt_Type ,
	 rh.I_Enquiry_Regn_ID ,
	 rh.I_Receipt_Type 





END
