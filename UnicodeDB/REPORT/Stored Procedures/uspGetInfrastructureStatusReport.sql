/*****************************************************************************************************************
Created by: Santanu Maity
Date: 20/07/2007
Description:Fetches the infrastructure status
Parameters: @sHierarchyList, @iBrandID
******************************************************************************************************************/

CREATE PROCEDURE [REPORT].[uspGetInfrastructureStatusReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int
)
AS

BEGIN TRY 

	DECLARE @InvoiceDetail TABLE
	(
		CenterCode VARCHAR(50),
		S_Center_Name VARCHAR(100),
		S_Item_Name VARCHAR(20),
		S_Item_Description VARCHAR(200),
		S_Value VARCHAR(50),
		InstanceChain VARCHAR(200)
	)

	INSERT INTO @InvoiceDetail
	SELECT 
		FN1.CenterCode,
		FN1.CenterName,
		PM.S_Premise_Name,
		PD.S_Act_Spec,
		PD.S_Act_No,
		FN2.InstanceChain
	FROM  
		  dbo.T_Brand_Master BRM 
		  INNER JOIN dbo.T_Brand_Center_Details	 BCM 
		  ON BCM.I_Brand_ID = BRM.I_Brand_ID
		  INNER JOIN dbo.T_Centre_Master CEM 
		  ON BCM.I_Centre_Id = CEM.I_Centre_Id
		  INNER JOIN T_Country_Master 	COM 
		  ON CEM.I_Country_ID = COM.I_Country_ID
		  LEFT OUTER JOIN NETWORK.T_Premise_Details PD
		  ON PD.I_Centre_Id = CEM.I_Centre_Id
		  INNER JOIN NETWORK.T_Premise_Master PM
		  ON PD.I_Premise_ID = PM.I_Premise_ID
		  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		  ON CEM.I_Centre_Id=FN1.CenterID
		  INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		  ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	WHERE CEM.I_Status=1

	INSERT INTO @InvoiceDetail
	SELECT 
		FN1.CenterCode,
		FN1.CenterName,
		HM.S_Hardware_Item,
		HD.S_Act_Spec,
		HD.S_Act_No,
		FN2.InstanceChain	
	FROM  
		  dbo.T_Brand_Master BRM 
		  INNER JOIN dbo.T_Brand_Center_Details	 BCM 
		  ON BCM.I_Brand_ID = BRM.I_Brand_ID
		  INNER JOIN dbo.T_Centre_Master CEM 
		  ON BCM.I_Centre_Id = CEM.I_Centre_Id
		  INNER JOIN T_Country_Master 	COM 
		  ON CEM.I_Country_ID = COM.I_Country_ID
		  LEFT OUTER JOIN NETWORK.T_Hardware_Detail HD
		  ON HD.I_Centre_Id = CEM.I_Centre_Id 	
		  INNER JOIN NETWORK.T_Hardware_Master HM
		  ON HD.I_Hardware_ID = HM.I_Hardware_ID	
		  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		  ON CEM.I_Centre_Id=FN1.CenterID
		  INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		  ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	WHERE CEM.I_Status=1

	INSERT INTO @InvoiceDetail
	SELECT 
		FN1.CenterCode,
		FN1.CenterName,
		SM.S_Software_Name,
		SD.S_Act_Version,
		SD.S_Act_License_No,
		FN2.InstanceChain
	FROM  
		  dbo.T_Brand_Master BRM 
		  INNER JOIN dbo.T_Brand_Center_Details	 BCM 
		  ON BCM.I_Brand_ID = BRM.I_Brand_ID
		  INNER JOIN dbo.T_Centre_Master CEM 
		  ON BCM.I_Centre_Id = CEM.I_Centre_Id
		  INNER JOIN T_Country_Master 	COM 
		  ON CEM.I_Country_ID = COM.I_Country_ID
		  LEFT OUTER JOIN NETWORK.T_Software_Detail SD
		  ON SD.I_Centre_Id = CEM.I_Centre_Id	
		  INNER JOIN NETWORK.T_Software_Master SM
		  ON SD.I_Software_ID = SM.I_Software_ID

		  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		  ON CEM.I_Centre_Id=FN1.CenterID
		  INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		  ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	WHERE CEM.I_Status=1

	SELECT * FROM @InvoiceDetail
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
