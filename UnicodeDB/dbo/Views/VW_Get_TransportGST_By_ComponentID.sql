-- =======================================================================
-- Author : Surya Narayan Chakraborty.
-- Created on : 03/11/2025
-- =======================================================================

-- SELECT * FROM [dbo].[VW_Get_TransportGST_By_ComponentID];
CREATE VIEW [dbo].[VW_Get_TransportGST_By_ComponentID]
AS
SELECT 
    fcm.I_Fee_Component_ID, 
    fcm.S_Component_Code ,
    fcm.S_Component_Name,
    gic.S_GST_FeeComponent_Category_Type AS GST_Category_Name,
    gcd.N_CGST, 
    gcd.N_IGST, 
    gcd.N_SGST,
    gcd.N_Start_Amount,
    gcd.N_End_Amount   
FROM T_Fee_Component_Master AS fcm
INNER JOIN T_ERP_GST_Component_Mapping AS gcm 
    ON fcm.I_Fee_Component_ID = gcm.I_Fee_Component_ID
INNER JOIN T_ERP_GST_Item_Category AS gic 
    ON gcm.I_GST_FeeComponent_Catagory_ID = gic.I_GST_FeeComponent_Catagory_ID
INNER JOIN T_ERP_GST_Configuration_Details AS gcd 
    ON gic.I_GST_FeeComponent_Catagory_ID = gcd.I_GST_FeeComponent_Catagory_ID
WHERE fcm.S_Individual_Comp_Type = 'T'
AND fcm.I_Status =1 ;
    
