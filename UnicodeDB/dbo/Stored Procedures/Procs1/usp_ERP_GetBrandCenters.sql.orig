
--*********************
--Created By: Debman Mukherjee
--Created Date : 02/03/07
-- Gets all centers for the brands
--**********************


CREATE PROCEDURE [dbo].[usp_ERP_GetBrandCenters]
 (
 @iBrandID INT =NULL,
 @iCenter INT=NULL,
 @sConfigtype varchar(max)=NULL,
 @sConfigCode varchar(max)=NULL
 )
AS
BEGIN

	select	bc.I_Brand_ID BrandID,
			ch.I_Center_Id,
			ch.I_Hierarchy_Detail_ID,
			ch.I_Hierarchy_Master_ID,
			bm.S_Brand_Code BrandCode,
			bm.S_Brand_Name BrandName
		from T_Brand_Center_Details bc
		inner join T_Center_Hierarchy_Details ch
		on bc.I_Centre_Id = ch.I_Center_Id 
		inner join dbo.T_Brand_Master bm
		on bc.I_Brand_ID = bm.I_Brand_ID
		where bc.I_Status <> 0
		and ch.I_Status <> 0
		and bm.I_Status <> 0
		and getdate() >= isnull(bc.Dt_Valid_From, getdate())
		and getdate() <= isnull(bc.Dt_Valid_To, getdate())
		and getdate() >= isnull(ch.Dt_Valid_From, getdate())
		and getdate() <= isnull(ch.Dt_Valid_To, getdate())
		and bc.I_Brand_ID = ISNULL(@iBrandID,bc.I_Brand_ID)
		and bc.I_Centre_Id= ISNULL(@iCenter,bc.I_Centre_Id)


		select ECT.I_Config_Type_ID as ConfigTypeID,ECT.S_Config_Type as ConfigType,
		ECM.I_Config_ID as ConfigID,ECM.S_config_code as ConfigCode,ECM.S_config_Value as ConfigValue
		from 
		T_ERP_Configuration_Master as ECM 
		inner join
		T_ERP_Configuration_Type as ECT on ECM.I_Config_Type_ID=ECT.I_Config_Type_ID
		inner join
		T_Brand_Center_Details  as BCD on BCD.I_Brand_ID=ECM.I_Brand_ID
		where ECT.S_Config_Type=ISNULL(@sConfigtype,ECT.S_Config_Type)
		and ECM.S_config_code=ISNULL(@sConfigCode,ECM.S_config_code)
		and ECM.I_Brand_ID = ISNULL(@iBrandID,ECM.I_Brand_ID)
		and BCD.I_Centre_Id= ISNULL(@iCenter,BCD.I_Centre_Id)


END
