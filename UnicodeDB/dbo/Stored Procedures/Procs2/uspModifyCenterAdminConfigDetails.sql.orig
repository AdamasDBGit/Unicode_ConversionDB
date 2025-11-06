-----------------------------------------------------------------------------------
--Issue No 260
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspModifyCenterAdminConfigDetails] 
(
	@iCenterID int,
	@sConfigXML xml,
	@sCreatedBy varchar(20),
	@sCreatedOn datetime,
	@iFlag int
)

AS
BEGIN TRY
	SET NOCOUNT OFF
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE	@InnerDetailXML XML
	DECLARE @sConfigCode varchar(50)
	DECLARE @sConfigValue varchar(50)

	BEGIN TRANSACTION
	IF @iCenterID = 0
	BEGIN
		SET @iCenterID = null
	END
	
	SET @AdjPosition = 1
	SET @AdjCount = @sConfigXML.value('count((Values/Inserted/Items))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @sConfigXML.query('/Values/Inserted/Items[position()=sql:variable("@AdjPosition")]')
		SELECT	@sConfigCode = T.a.value('@ConfigCode','varchar(50)'),
				@sConfigValue = T.a.value('@ConfigValue','varchar(50)')	
				FROM @InnerDetailXML.nodes('/Items') T(a)

		INSERT INTO dbo.T_Center_Configuration
		(I_Center_Id,S_Config_Code,S_Config_Value,
		I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On)
		VALUES
		(@iCenterID,@sConfigCode,@sConfigValue,
		1,@sCreatedOn,@sCreatedBy,@sCreatedOn)

		SET @AdjPosition = @AdjPosition + 1
	END

	SET @AdjPosition = 1
	SET @AdjCount = @sConfigXML.value('count((Values/Modified/Items))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @sConfigXML.query('/Values/Modified/Items[position()=sql:variable("@AdjPosition")]')
		SELECT	@sConfigCode = T.a.value('@ConfigCode','varchar(50)'),
				@sConfigValue = T.a.value('@ConfigValue','varchar(50)')
				FROM @InnerDetailXML.nodes('/Items') T(a)
		
		IF @iCenterID <> 0
		BEGIN 
			UPDATE 	dbo.T_Center_Configuration	
			SET I_Status = 0,
			Dt_Valid_To = @sCreatedOn,
			S_Upd_by = @sCreatedBy,
			Dt_Upd_On = @sCreatedOn
			WHERE S_Config_Code = @sConfigCode
			AND I_Center_Id = @iCenterID
			AND I_Status = 1
			AND @sCreatedOn >= ISNULL(Dt_Valid_From,@sCreatedOn)
			AND @sCreatedOn <= ISNULL(Dt_Valid_To,@sCreatedOn)
		END
		ELSE
		BEGIN
			UPDATE 	dbo.T_Center_Configuration	
			SET I_Status = 0,
			Dt_Valid_To = @sCreatedOn,
			S_Upd_by = @sCreatedBy,
			Dt_Upd_On = @sCreatedOn
			WHERE S_Config_Code = @sConfigCode
			AND I_Center_Id IS NULL
			AND I_Status = 1
			AND @sCreatedOn >= ISNULL(Dt_Valid_From,@sCreatedOn)
			AND @sCreatedOn <= ISNULL(Dt_Valid_To,@sCreatedOn)
		END
	
		INSERT INTO dbo.T_Center_Configuration
		(I_Center_Id,S_Config_Code,S_Config_Value,
		I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On)
		VALUES
		(@iCenterID,@sConfigCode,@sConfigValue,
		1,@sCreatedOn,@sCreatedBy,@sCreatedOn)

		SET @AdjPosition = @AdjPosition + 1
	END
	COMMIT TRANSACTION 
END TRY

BEGIN CATCH    
	 ROLLBACK TRANSACTION   
	 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
	 SELECT @ErrMsg = ERROR_MESSAGE(),    
	   @ErrSeverity = ERROR_SEVERITY()    
	    
	 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    
END CATCH
