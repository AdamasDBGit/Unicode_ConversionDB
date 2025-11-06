CREATE PROCEDURE [EOS].[uspSaveSkillListForRole]
(	
	@iRoleID INT,
	@sSkillIDs VARCHAR(1000),
	@iBrandID INT,
	@sCreatedBy VARCHAR(20),	
	@sUpdatedBy VARCHAR(20),
	@DtCreatedOn DATETIME,
	@DtUpdatedOn DATETIME,
	@iCenterID INT = NULL
)
	
AS
BEGIN TRY
	BEGIN TRANSACTION
	INSERT INTO EOS.T_Role_Skill_Map_Audit
		(
			I_Role_Skill_ID,I_Brand_ID,I_Centre_ID,I_Role_ID,I_Skill_ID,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
		)
	SELECT 
		I_Role_Skill_ID,
		I_Brand_ID,
		I_Centre_ID,
		I_Role_ID,
		I_Skill_ID,
		I_Status,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On 
	FROM 
		EOS.T_Role_Skill_Map WITH(NOLOCK)
	WHERE
		I_Role_ID = @iRoleID
		AND I_Brand_ID = @iBrandID
		
	IF (@iCenterID IS NULL)
	BEGIN
		DELETE FROM EOS.T_Role_Skill_Map WHERE I_Role_ID = @iRoleID AND I_Centre_ID IS NULL
		AND I_Brand_ID = @iBrandID
	END	
	ELSE
	BEGIN
		DELETE FROM EOS.T_Role_Skill_Map WHERE I_Role_ID = @iRoleID AND I_Centre_ID = @iCenterID
		AND I_Brand_ID = @iBrandID
	END
	
	INSERT INTO EOS.T_Role_Skill_Map
		(
			I_Centre_ID,I_Brand_ID,I_Role_ID,I_Skill_ID,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
		)
	SELECT @iCenterID, @iBrandID, @iRoleID, *, 1, @sCreatedBy, @sUpdatedBy, @DtCreatedOn, @DtUpdatedOn FROM dbo.fnString2Rows(@sSkillIDs, ',')
	COMMIT TRANSACTION
END TRY 
BEGIN CATCH    
	 ROLLBACK TRANSACTION   
	 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
	 SELECT @ErrMsg = ERROR_MESSAGE(),    
	   @ErrSeverity = ERROR_SEVERITY()    
	    
	 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
