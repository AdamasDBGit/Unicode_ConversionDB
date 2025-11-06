-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <15th February 2024>
-- Description:	<to get the class>
-- exec [usp_ERP_GetGSTConfig] 107,null
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetGSTConfig]
	@iBrandID int null,
	@FeeComponentCatagoryID int null

AS
BEGIN
	SET NOCOUNT ON;
	select GIC.I_GST_FeeComponent_Catagory_ID as ComponentCatagoryID,
GIC.S_GST_FeeComponent_Category_Type as ComponentCatagoryType,
GIC.S_GST_FeeComponent_Description as ComponentDesc,
GIC.Is_Active as Active
from T_ERP_GST_Item_Category as GIC 
where GIC.I_Brand_Id=@iBrandID 
and GIC.I_GST_FeeComponent_Catagory_ID=ISNULL(@FeeComponentCatagoryID,GIC.I_GST_FeeComponent_Catagory_ID)
and GIC.S_GST_FeeComponent_Category_Type NOT Like 'Default_ZERO%'
order by ComponentCatagoryID
select GCD.I_GST_Configuration_ID as ConfigurationID,
GCD.I_GST_FeeComponent_Catagory_ID as ComponentCatagoryID,
GCD.N_Start_Amount as StartAmount,
GCD.N_End_Amount as EndAmount,
GCD.N_CGST as CGST,
GCD.N_SGST as SGST,
GCD.N_IGST as IGST,
GCD.Is_Active as Active
from T_ERP_GST_Configuration_Details as GCD
Inner Join T_ERP_GST_Item_Category GIC on GIC.I_GST_FeeComponent_Catagory_ID=GCD.I_GST_FeeComponent_Catagory_ID
where GCD.I_GST_FeeComponent_Catagory_ID=ISNULL(@FeeComponentCatagoryID,GCD.I_GST_FeeComponent_Catagory_ID) and GCD.Is_Active=1
and GIC.S_GST_FeeComponent_Category_Type NOT Like 'Default_ZERO%'

	END
