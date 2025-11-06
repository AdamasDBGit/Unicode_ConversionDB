--exec [dbo].[uspGetGatePass] null,'9038325725'
CREATE PROCEDURE [dbo].[ERP_uspPreviewTaxComponent]

AS
BEGIN
select 
t1.I_Fee_Component_ID ,
t1.S_Component_Name,
t3.N_Start_Amount,
t3.N_End_Amount,
t3.N_SGST,
t3.N_CGST,
t3.N_IGST
from T_Fee_Component_Master t1 inner join T_ERP_GST_Item_Category t2 
on t1.I_Fee_Component_ID=t2.I_Fee_Component_ID
inner join T_ERP_GST_Configuration_Details t3 
on t3.I_GST_FeeComponent_Catagory_ID= t2.I_GST_FeeComponent_Catagory_ID
END
