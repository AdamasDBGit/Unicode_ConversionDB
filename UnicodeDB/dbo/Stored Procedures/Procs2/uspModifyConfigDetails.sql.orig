CREATE PROCEDURE [dbo].[uspModifyConfigDetails] 
(
	@iCenterID INT,
	@iBrandID int,	
	@sConfigXML xml,
	@sCreatedBy varchar(20),
	@sCreatedOn datetime,
	@iFlag int,	
	@iCenterDiscountId int,
    @iHierarchyLevel int,
	@iHierarchyDetail int,
	@nDiscountPercent decimal(4,2)
)

AS
BEGIN TRY
	SET NOCOUNT ON;
	IF @iCenterID = 0 
	BEGIN
		SET @iCenterID = null
	END
	
	IF @iBrandID = 0 
	BEGIN
		SET @iBrandID = null
	END
	
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE	@InnerDetailXML XML
	DECLARE @sConfigCode varchar(50)
	DECLARE @sConfigValue varchar(50)

	BEGIN TRANSACTION
	SET @AdjPosition = 1
	SET @AdjCount = @sConfigXML.value('count((Values/Modified/Items))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @sConfigXML.query('/Values/Modified/Items[position()=sql:variable("@AdjPosition")]')
		SELECT	@sConfigCode = T.a.value('@ConfigCode','varchar(50)'),
				@sConfigValue = T.a.value('@ConfigValue','varchar(50)')
		FROM @InnerDetailXML.nodes('/Items') T(a)
					
		UPDATE 	dbo.T_Center_Configuration	
		SET I_Status = 0,
		Dt_Valid_To = @sCreatedOn,
		S_Upd_by = @sCreatedBy,
		Dt_Upd_On = @sCreatedOn
		WHERE S_Config_Code = @sConfigCode
		AND ISNULL(I_BRAND_ID,0)=ISNULL(@iBrandID,0)
		AND ISNULL(I_Center_Id,0)=ISNULL(@iCenterID,0)
		AND I_Status = 1
		AND @sCreatedOn >= ISNULL(Dt_Valid_From,@sCreatedOn)
		AND @sCreatedOn <= ISNULL(Dt_Valid_To,@sCreatedOn)
	
		IF (LTRIM(RTRIM(@sConfigValue))<>'')
		BEGIN
			INSERT INTO dbo.T_Center_Configuration
			(I_Center_Id,S_Config_Code,S_Config_Value,
			I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On,I_Brand_ID)
			VALUES
			(@iCenterID,@sConfigCode,@sConfigValue,
			1,@sCreatedOn,@sCreatedBy,@sCreatedOn,@iBrandID)
		END

		SET @AdjPosition = @AdjPosition + 1
	END


	IF (@iHierarchyLevel <> 0 AND @iHierarchyDetail <> 0)
	BEGIN
		IF NOT EXISTS(SELECT 'TRUE' FROM dbo.T_Center_Discount_Details WHERE I_Hierarchy_Level_Id = @iHierarchyLevel AND
					  I_Hierarchy_Detail_ID = @iHierarchyDetail AND I_STATUS=1 AND ISNULL(I_Center_Id,0)=ISNULL(@iCenterID,0) AND ISNULL(I_BRAND_ID,0)=ISNULL(@iBrandID,0))
		BEGIN
			INSERT INTO dbo.T_Center_Discount_Details
			(I_Center_Id,I_Hierarchy_Level_Id,I_Hierarchy_Detail_ID,
			N_Discount_Percentage,I_Status,S_Crtd_By,Dt_Crtd_On,I_Brand_Id)
			VALUES
			(@iCenterID,
			@iHierarchyLevel,
			@iHierarchyDetail,
			@nDiscountPercent,
			1,
			@sCreatedBy,
			@sCreatedOn,
			@iBrandID)
		END
		ELSE IF (@nDiscountPercent<>0)
		BEGIN
			UPDATE dbo.T_Center_Discount_Details SET
			I_Hierarchy_Level_Id = @iHierarchyLevel,
			I_Hierarchy_Detail_ID = @iHierarchyDetail,
			N_Discount_Percentage = @nDiscountPercent,
			S_Upd_By = @sCreatedBy, 
			Dt_Upd_On = @sCreatedOn
			WHERE I_Center_Discount_Id = @iCenterDiscountId		
		END
		ELSE IF (@nDiscountPercent = 0)
		BEGIN
			UPDATE dbo.T_Center_Discount_Details SET 
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @sCreatedOn,
			I_Status = 0 
			WHERE I_Center_Discount_Id = @iCenterDiscountId
		END
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
