/**************************************************************************************************************
Created by  : Swagata De
Date		: 21.06.2007
Description : This SP will retrieve the KRAs for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetKRAListForEmployee]
(	
	@iEmployeeID INT,
	@bForRole BIT
)	
AS
BEGIN
	DECLARE @tempBrand TABLE
	(
		I_Brand_ID INT
	)
	
	DECLARE @tempKRAs TABLE
	(
		I_KRA_ID INT,
		I_KRA_Index_ID INT,
		S_KRA_Desc VARCHAR(200),
		N_Weightage NUMERIC(18,0)
	)
			
	INSERT INTO @tempBrand
	SELECT I_Brand_ID FROM dbo.T_Brand_Center_Details
	WHERE I_Centre_ID IN (SELECT I_Centre_Id FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmployeeID)

	IF (@bForRole = 1)
	BEGIN
		DECLARE @iUserID INT,
				@nWeightage NUMERIC
				
		SET @nWeightage=0.00

		SET @iUserID = (SELECT TOP 1 I_User_ID FROM dbo.T_User_Master WHERE I_Reference_ID=@iEmployeeID AND I_Status =1 AND S_User_Type <> 'ST' AND S_User_Type <> 'EM')

		--Get the entire KRA List for all roles corresponding to the employee first
		INSERT INTO @tempKRAs
		SELECT 
				DISTINCT TKM.I_KRA_ID,TRKM.I_KRA_Index_ID,TKM.S_KRA_Desc,@nWeightage AS N_Weightage
		FROM 
				EOS.T_KRA_Master TKM WITH(NOLOCK)
			INNER JOIN EOS.T_Role_KRA_Map TRKM
				ON TKM.I_KRA_ID = TRKM.I_KRA_ID
			INNER JOIN dbo.T_User_Role_Details TURD
				ON TRKM.I_Role_ID = TURD.I_Role_ID
		WHERE	TURD.I_User_ID = @iUserID
			--AND TRKM.I_Brand_ID IN (SELECT I_Brand_ID FROM @tempBrand)
			
		SELECT I_KRA_ID,I_KRA_Index_ID,S_KRA_Desc,N_Weightage FROM @tempKRAs
			
		-- Get the SubKRAs for the same Brand, Role & KRAs
		SELECT 
				DISTINCT TKM.I_KRA_ID,TRKM.I_KRA_Index_ID,TKM.S_KRA_Desc,TRKS.I_SubKRA_ID,TRKS.I_SubKRA_Index_ID, TKM1.S_KRA_Desc AS S_SubKRA_Desc, @nWeightage AS N_Weightage
		FROM
				EOS.T_Role_KRA_SubKRA TRKS WITH(NOLOCK)
			INNER JOIN EOS.T_KRA_Master TKM1 WITH(NOLOCK)
				ON 	TRKS.I_SubKRA_ID = TKM1.I_KRA_ID	
			INNER JOIN EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON TRKS.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM
				ON TKM.I_KRA_ID = TRKM.I_KRA_ID
			INNER JOIN dbo.T_User_Role_Details TURD
				ON TRKM.I_Role_ID = TURD.I_Role_ID	
				AND TRKS.I_Role_ID = TURD.I_Role_ID		
		WHERE	TURD.I_User_ID = @iUserID
			--AND TRKM.I_Brand_ID IN (SELECT I_Brand_ID FROM @tempBrand)
			AND TRKS.I_KRA_ID IN (SELECT I_KRA_ID FROM @tempKRAs)			
	END
	ELSE
		BEGIN
		--Now get the KRAs present in the employee KRA Map

		SELECT 
				DISTINCT TKM.I_KRA_ID,TRKM.I_KRA_Index_ID,TKM.S_KRA_Desc,TEKM.N_Weightage
		FROM 
				EOS.T_KRA_Master TKM WITH(NOLOCK)
			INNER JOIN EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
				ON TKM.I_KRA_ID = TEKM.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM
				ON TKM.I_KRA_ID = TRKM.I_KRA_ID
			WHERE TEKM.I_Employee_ID = @iEmployeeID
				AND TEKM.I_Status=1
				AND (TEKM.I_SubKRA_Id IS NULL) OR (TEKM.I_SubKRA_Id = 0)
				
		SELECT 
				DISTINCT TKM.I_KRA_ID,TRKM.I_KRA_Index_ID,TKM.S_KRA_Desc,TEKM.I_SubKRA_ID, TKM1.I_KRA_Index_ID AS I_SubKRA_Index_ID,TKM1.S_KRA_Desc AS S_SubKRA_Desc,TEKM.N_Weightage
		FROM 				
				EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
			INNER JOIN EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON 	TEKM.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM
				ON TKM.I_KRA_ID = TRKM.I_KRA_ID
			INNER JOIN EOS.T_KRA_Master TKM1 WITH(NOLOCK)
				ON TKM1.I_KRA_ID = TEKM.I_SubKRA_ID
			WHERE TEKM.I_Employee_ID = @iEmployeeID
				AND TEKM.I_Status=1
				AND (TEKM.I_SubKRA_Id IS NOT NULL) AND (TEKM.I_SubKRA_Id != 0)
	END

END
