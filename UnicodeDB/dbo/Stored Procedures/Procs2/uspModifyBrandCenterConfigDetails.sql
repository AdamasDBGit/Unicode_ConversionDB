CREATE PROCEDURE [dbo].[uspModifyBrandCenterConfigDetails]   
(  
 @iBrandID int,   
 @sConfigXML xml,  
 @sCreatedBy Nnvarchar(max),  
 @sCreatedOn datetime,  
 @iFlag int,  
   
 @iCenterDiscountId int,  
    @iHierarchyLevel int,  
 @iHierarchyDetail int,  
 @nDiscountPercent decimal(4,2),  
    @iDiscountAmt int  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT  
 DECLARE @InnerDetailXML XML  
 DECLARE @sConfigCode nvarchar(max)  
 DECLARE @sConfigValue nvarchar(max)  
  
 IF @iBrandID = 0 or @iBrandID is null  
 return;  
  
 IF @iFlag <> 3   
 BEGIN  
    
--  For inserting the values of Center configuration parameters  
  SET @AdjPosition = 1  
  SET @AdjCount = @sConfigXML.value('count((Values/Inserted/Items))','int')  
  WHILE(@AdjPosition<=@AdjCount)  
  BEGIN  
   SET @InnerDetailXML = @sConfigXML.query('/Values/Inserted/Items[position()=sql:variable("@AdjPosition")]')  
   SELECT @sConfigCode = T.a.value('@ConfigCode','nvarchar(max)'),  
     @sConfigValue = T.a.value('@ConfigValue','nvarchar(max)')   
     FROM @InnerDetailXML.nodes('/Items') T(a)  
  
  
   UPDATE  dbo.T_Center_Configuration   
   SET I_Status = 0,  
   Dt_Valid_To = @sCreatedOn,  
   S_Upd_by = @sCreatedBy,  
   Dt_Upd_On = @sCreatedOn  
   WHERE S_Config_Code = @sConfigCode  
   AND I_Center_Id IS NULL  
   AND I_BRAND_ID=@iBrandID  
   AND I_Status = 1  
   AND @sCreatedOn >= ISNULL(Dt_Valid_From,@sCreatedOn)  
   AND @sCreatedOn <= ISNULL(Dt_Valid_To,@sCreatedOn)  
  
   IF (LTRIM(RTRIM(@sConfigValue))<>'')  
   BEGIN  
    INSERT INTO dbo.T_Center_Configuration  
    (I_Center_Id,S_Config_Code,S_Config_Value,  
    I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On,I_Brand_ID)  
    VALUES  
    (NULL,@sConfigCode,@sConfigValue,  
    1,@sCreatedOn,@sCreatedBy,@sCreatedOn,@iBrandID)  
   END  
  
   SET @AdjPosition = @AdjPosition + 1  
  END  
  
--  For updating the values of Center Configuration parameters  
  SET @AdjPosition = 1  
  SET @AdjCount = @sConfigXML.value('count((Values/Modified/Items))','int')  
  WHILE(@AdjPosition<=@AdjCount)  
  BEGIN  
   SET @InnerDetailXML = @sConfigXML.query('/Values/Modified/Items[position()=sql:variable("@AdjPosition")]')  
   SELECT @sConfigCode = T.a.value('@ConfigCode','nvarchar(max)'),  
     @sConfigValue = T.a.value('@ConfigValue','nvarchar(max)')  
   FROM @InnerDetailXML.nodes('/Items') T(a)  
        
   UPDATE  dbo.T_Center_Configuration   
   SET I_Status = 0,  
   Dt_Valid_To = @sCreatedOn,  
   S_Upd_by = @sCreatedBy,  
   Dt_Upd_On = @sCreatedOn  
   WHERE S_Config_Code = @sConfigCode  
   AND I_Brand_ID = @iBrandID  
   AND I_CENTER_ID IS NULL  
   AND I_Status = 1  
   AND @sCreatedOn >= ISNULL(Dt_Valid_From,@sCreatedOn)  
   AND @sCreatedOn <= ISNULL(Dt_Valid_To,@sCreatedOn)  
    
   IF (LTRIM(RTRIM(@sConfigValue))<>'')  
   BEGIN  
    INSERT INTO dbo.T_Center_Configuration  
    (I_Center_Id,S_Config_Code,S_Config_Value,  
    I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On,I_Brand_ID)  
    VALUES  
    (NULL,@sConfigCode,@sConfigValue,  
    1,@sCreatedOn,@sCreatedBy,@sCreatedOn,@iBrandID)  
   END  
  
   SET @AdjPosition = @AdjPosition + 1  
  END  
    
 END  
  
 IF @iFlag = 1  
  BEGIN   
   IF (@iHierarchyLevel <> 0 AND @iHierarchyDetail <> 0)  
   BEGIN  
    IF NOT EXISTS(SELECT 'TRUE' FROM dbo.T_Center_Discount_Details WHERE I_Hierarchy_Level_Id = @iHierarchyLevel AND  
         I_Hierarchy_Detail_ID = @iHierarchyDetail AND I_STATUS=1 AND I_Center_Id IS NULL AND I_Brand_Id= @iBrandID)  
    BEGIN  
     IF (@nDiscountPercent<>0)  
     BEGIN  
      INSERT INTO dbo.T_Center_Discount_Details  
      (I_Center_Id,I_Hierarchy_Level_Id,I_Hierarchy_Detail_ID,  
      N_Discount_Percentage,I_Discount_Amount,I_Status,S_Crtd_By,Dt_Crtd_On,I_Brand_Id)  
      VALUES  
      (Null,  
      @iHierarchyLevel,  
      @iHierarchyDetail,  
      @nDiscountPercent,  
      @iDiscountAmt,  
      1,  
      @sCreatedBy,  
      @sCreatedOn,  
      @iBrandID)  
     END  
    END  
   END  
  END  
 ELSE IF @iFlag = 3  
  BEGIN  
   UPDATE dbo.T_Center_Discount_Details SET   
   S_Upd_By = @sCreatedBy,  
   Dt_Upd_On = @sCreatedOn,  
   I_Status = 0   
   WHERE I_Center_Discount_Id = @iCenterDiscountId  
  END  
 ELSE  
  BEGIN  
   IF (@iHierarchyLevel <> 0 AND @iHierarchyDetail <> 0)  
   BEGIN  
    IF (@nDiscountPercent<>0)  
    BEGIN  
     UPDATE dbo.T_Center_Discount_Details SET  
     I_Hierarchy_Level_Id = @iHierarchyLevel,  
     I_Hierarchy_Detail_ID = @iHierarchyDetail,  
     N_Discount_Percentage = @nDiscountPercent,  
     I_Discount_Amount = @iDiscountAmt,  
     S_Upd_By = @sCreatedBy,  
     Dt_Upd_On = @sCreatedOn  
     WHERE I_Center_Discount_Id = @iCenterDiscountId    
    END  
   END  
  END  
END

