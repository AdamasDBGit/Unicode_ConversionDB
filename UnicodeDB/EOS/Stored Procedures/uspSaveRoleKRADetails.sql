/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will Save the KRA Details for the particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveRoleKRADetails]
(	
	@iBrandID INT,
	@iRoleID INT,
	@sKRAXML XML,
	@sCreatedBy VARCHAR(20),
	@sUpdatedBy VARCHAR(20),
	@dtCreatedOn DATETIME,
	@dtUpdatedOn DATETIME
)	
AS
BEGIN
	
	CREATE TABLE #tempTable
	(            
		I_KRA_ID int,
		I_KRA_Index_ID int		
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable
	SELECT	T.c.value('@KRAID','int'),
			T.c.value('@KRAIndexID','int')
	FROM   @sKRAXML.nodes('/RoleKRA/KRA/KRA') T(c)
	
	DELETE FROM EOS.T_Role_KRA_Map
	WHERE	
			I_Brand_ID = @iBrandID
		AND I_Role_ID = @iRoleID
		AND I_KRA_ID NOT IN (SELECT I_KRA_ID FROM #tempTable)
		
	UPDATE EOS.T_Role_KRA_Map
	SET EOS.T_Role_KRA_Map.I_KRA_Index_ID = #tempTable.I_KRA_Index_ID,
		EOS.T_Role_KRA_Map.I_Status = 1,
		EOS.T_Role_KRA_Map.S_Upd_By = @sUpdatedBy,
		EOS.T_Role_KRA_Map.Dt_Upd_On = @dtUpdatedOn
	FROM #tempTable
	WHERE	EOS.T_Role_KRA_Map.I_Brand_ID = @iBrandID
		AND EOS.T_Role_KRA_Map.I_Role_ID = @iRoleID
		AND EOS.T_Role_KRA_Map.I_KRA_ID = #tempTable.I_KRA_ID
		
	INSERT INTO EOS.T_Role_KRA_Map
		(
			I_Brand_ID,
			I_Role_ID,
			I_KRA_ID,
			I_KRA_Index_ID,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On
		)
	SELECT 
			@iBrandID,
			@iRoleID,
			I_KRA_ID,
			I_KRA_Index_ID,
			1,
			@sCreatedBy,
			@sUpdatedBy,
			@dtCreatedOn,
			@dtUpdatedOn
	FROM
			#tempTable
	WHERE	
			I_KRA_ID NOT IN (	
								SELECT I_KRA_ID 
								FROM EOS.T_Role_KRA_Map 
								WHERE	I_Brand_ID = @iBrandID
									AND	I_Role_ID = @iRoleID
							)	

	TRUNCATE TABLE #tempTable	
	DROP TABLE #tempTable									
END
