/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 14 July, 2010
Description: Loads all center/brand/global config to metadata
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetConfigurationMetadata]

AS
BEGIN

	--OLD CODE - BEFORE GST IMPLEMENTATION 
	--SELECT I_Config_ID,
	--	   ISNULL(I_Center_Id,-1) AS I_Center_Id,
	--	   S_Config_Code,
	--	   S_Config_Value,
	--	   CC.I_Status,
	--	   Dt_Valid_From,
	--	   Dt_Valid_To,
	--	   ISNULL(I_Brand_ID ,-1) AS I_Brand_ID	   
	--FROM dbo.T_Center_Configuration CC
	--WHERE CC.I_Status = 1
	
	
	--NEW CODE - AFTER GST IMPLEMENTATION 
	SELECT I_Config_ID,
		   ISNULL(I_Center_Id,-1) AS I_Center_Id,
		   S_Config_Code,
		   S_Config_Value,
		   CC.I_Status,
		   Dt_Valid_From,
		   Dt_Valid_To,
		   ISNULL(I_Brand_ID ,-1) AS I_Brand_ID	   
	FROM dbo.T_Center_Configuration CC
	WHERE CC.I_Status = 1
	UNION
	SELECT
		DISTINCT  
		GCM.I_GST_ID I_Config_ID,
		TCM.I_Centre_Id,
		'COMPANY_GST_TAX_NO' S_Config_Code,
		GCM.S_GST_Code,
		GCM.I_Status,
		GCM.Dt_Crtd_On Dt_Valid_From,
		NULL Dt_Valid_To,
		GCM.I_Brand_ID
	FROM dbo.T_GST_Code_Master AS GCM
	INNER JOIN NETWORK.T_Center_Address AS TCA
	ON GCM.I_State_ID = TCA.I_State_ID
	INNER JOIN dbo.T_Centre_Master AS TCM
	ON TCA.I_Centre_Id = TCM.I_Centre_Id
	AND TCM.I_Status = 1
	INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS CHND
	ON CHND.I_Center_ID = TCA.I_Centre_Id
	AND CHND.I_Brand_ID	= GCM.I_Brand_ID
	WHERE GCM.I_Status = 1
	

END
