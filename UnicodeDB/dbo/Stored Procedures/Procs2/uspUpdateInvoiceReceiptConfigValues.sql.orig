CREATE PROCEDURE [dbo].[uspUpdateInvoiceReceiptConfigValues]          
 @iFlag INT    
,@iHierarchyDetailID INT    
,@sConfig VARCHAR(8000)    
,@sUserID VARCHAR(500)         
AS          
BEGIN TRY     
-------------------------------------------------------------------------------    
DECLARE @hDoc INT             
EXEC SP_XML_PREPAREDOCUMENT @hDoc OUTPUT,@sConfig    
    
DECLARE @ConfigTable TABLE (ROWID INT IDENTITY(1,1),CONFIG_CODE VARCHAR(50),CONFIG_VALUE VARCHAR(500))    
INSERT INTO @ConfigTable(CONFIG_CODE,CONFIG_VALUE)    
SELECT CONFIG_CODE,CONFIG_VALUE            
FROM OPENXML (@hDoc,'/CONFIG/CONFIGTABLE',2)             
WITH (CONFIG_CODE VARCHAR(50),CONFIG_VALUE VARCHAR(500))       
-------------------------------------------------------------------------------    
DECLARE @sSearchCriteria VARCHAR(100)    
    
DECLARE @TempCenter TABLE(ROWID INT IDENTITY(1,1),I_Center_ID INT)    
    
SELECT @sSearchCriteria= S_Hierarchy_Chain     
FROM T_Hierarchy_Mapping_Details     
WHERE I_Hierarchy_detail_id =@iHierarchyDetailID     
    
INSERT INTO @TempCenter     
SELECT TCHD.I_Center_Id     
FROM T_CENTER_HIERARCHY_DETAILS TCHD WITH(NOLOCK)    
INNER JOIN T_Hierarchy_Mapping_Details HMD WITH(NOLOCK)     
  ON TCHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID    
WHERE HMD.I_Status = 1    
AND TCHD.I_Status = 1    
AND GETDATE() >= ISNULL(HMD.Dt_Valid_From,GETDATE())    
AND GETDATE() <= ISNULL(HMD.Dt_Valid_To,GETDATE())    
AND HMD.S_Hierarchy_Chain LIKE @sSearchCriteria + '%'    
--------------------------------------------------------------------------------    
    
DECLARE @min1 INT    
DECLARE @max1 INT    
DECLARE @min2 INT    
DECLARE @max2 INT    
DECLARE @iCenterID INT    
DECLARE @sCode VARCHAR(50)    
DECLARE @sValue VARCHAR(500)    
    
         
IF ( @iFlag = 1 )    
BEGIN    
    
    
SELECT @min1 = MIN(ROWID), @max1 = MAX(ROWID) FROM @TempCenter    
WHILE @min1 <= @max1    
BEGIN    
    
 SELECT  @min2 = MIN(ROWID), @max2 = MAX(ROWID) FROM @ConfigTable    
 WHILE @min2 <= @max2    
 BEGIN    
  SELECT @iCenterID = I_Center_ID FROM @TempCenter WHERE ROWID = @min1    
  SELECT @sCode = CONFIG_CODE, @sValue = CONFIG_VALUE FROM @ConfigTable WHERE ROWID = @min2    
  ----------------------------------------------------------------------    
  IF NOT EXISTS( SELECT 'TRUE' FROM dbo.T_Center_Configuration     
      WHERE I_Center_Id = @iCenterID AND S_Config_Code = @sCode    
      AND I_Status = 1    
      )    
     BEGIN    
      INSERT INTO dbo.T_Center_Configuration(I_Center_Id,S_Config_Code,S_Config_Value,I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On)    
      VALUES(@iCenterID,@sCode,@sValue,1,GETDATE(),@sUserID,GETDATE())    
     END    
  ELSE    
     BEGIN    
      UPDATE dbo.T_Center_Configuration    
      SET I_Status = 0    
      ,Dt_Upd_On = GETDATE()    
      ,S_Upd_by = @sUserID    
      WHERE I_Center_Id = @iCenterID AND S_Config_Code = @sCode AND I_Status = 1    
    
      INSERT INTO dbo.T_Center_Configuration(I_Center_Id,S_Config_Code,S_Config_Value,I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On)    
      VALUES(@iCenterID,@sCode,@sValue,1,GETDATE(),@sUserID,GETDATE())    
     END    
  ----------------------------------------------------------------------    
  SET @min2 = @min2 + 1    
 END    
    
 SET @min1 = @min1 + 1    
END     
    
    
END    
ELSE IF ( @iFlag = 2 )    
BEGIN    
    
    
SELECT @min1 = MIN(ROWID), @max1 = MAX(ROWID) FROM @TempCenter    
WHILE @min1 <= @max1    
BEGIN    
    
 SELECT  @min2 = MIN(ROWID), @max2 = MAX(ROWID) FROM @ConfigTable    
 WHILE @min2 <= @max2    
 BEGIN    
  SELECT @iCenterID = I_Center_ID FROM @TempCenter WHERE ROWID = @min1    
  SELECT @sCode = CONFIG_CODE, @sValue = CONFIG_VALUE FROM @ConfigTable WHERE ROWID = @min2    
  ----------------------------------------------------------------------    
  IF NOT EXISTS( SELECT 'TRUE' FROM dbo.T_Center_Configuration     
      WHERE I_Center_Id = @iCenterID AND S_Config_Code = @sCode    
      AND I_Status = 1    
      )    
     BEGIN    
      INSERT INTO dbo.T_Center_Configuration(I_Center_Id,S_Config_Code,S_Config_Value,I_Status,Dt_Valid_From,S_Crtd_By,Dt_Crtd_On)    
      VALUES(@iCenterID,@sCode,@sValue,1,GETDATE(),@sUserID,GETDATE())    
     END    
  ----------------------------------------------------------------------    
  SET @min2 = @min2 + 1    
 END    
    
 SET @min1 = @min1 + 1    
END     
    
    
END     
         
END TRY          
BEGIN CATCH          
--Error occurred:            
          
DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
SELECT @ErrMsg = ERROR_MESSAGE(),          
  @ErrSeverity = ERROR_SEVERITY()          
          
RAISERROR(@ErrMsg, @ErrSeverity, 1)          
END CATCH
