--[NETWORK].[uspGetRecommendedInfrastructure] 1,'PR'

-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for Software of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetRecommendedInfrastructure]
	@iInfrastructureID INT
	,@sCase VARCHAR(2)
AS
BEGIN
	SET NOCOUNT OFF;
	
	IF @sCase = 'PR'
	BEGIN
		SELECT I_Premise_ID,
			   I_Brand_ID,
			   S_Premise_Name,
			   S_Rec_No,
			   S_Rec_Spec
	FROM NETWORK.T_Premise_Master
	WHERE I_Premise_ID = @iInfrastructureID
		
	END
	
	ELSE IF @sCase = 'HA'
	BEGIN
		SELECT I_Hardware_ID,
			   I_Brand_ID,
			   S_Hardware_Item,
			   S_Rec_Spec,
			   S_Rec_No			  
	FROM NETWORK.T_Hardware_Master 
	WHERE I_Hardware_ID = @iInfrastructureID
		
	END
	
	ELSE IF @sCase = 'SO'
	BEGIN
		SELECT	  I_Software_ID,
				  I_Brand_ID,			  
				  S_Software_Name,
				  S_Rec_Version,
				  S_Rec_License_No	  
	FROM NETWORK.T_Software_Master 
	WHERE I_Software_ID = @iInfrastructureID
		
	END
	
	ELSE IF @sCase = 'ST'
	BEGIN
		SELECT I_Startup_Kit_ID,
			   I_Brand_ID,
			   S_Material_Item,
			   S_Rec_No,
			   S_Rec_Spec
	FROM NETWORK.T_Startup_Kit_Master 
	WHERE I_Startup_Kit_ID = @iInfrastructureID
		
	END
	
	
	
	
END
