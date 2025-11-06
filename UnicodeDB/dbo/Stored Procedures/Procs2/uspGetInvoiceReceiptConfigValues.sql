CREATE PROCEDURE [dbo].[uspGetInvoiceReceiptConfigValues]  
(  
 @iHierarchyDetailID INT  
)    
AS  
BEGIN  
--------------------------------------------------------------------------------   
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
DECLARE @CONFIGTABLE TABLE  
(  
  CENTERNAME VARCHAR(100)  
 ,IUH VARCHAR(500)  
 ,ILH VARCHAR(500)  
 ,ICN VARCHAR(500)  
 ,ICT VARCHAR(500)  
 ,IRO VARCHAR(500)  
 ,RUH VARCHAR(500)  
 ,RLH VARCHAR(500)  
 ,RCN VARCHAR(500)  
 ,RCT VARCHAR(500)  
 ,RTC VARCHAR(500)  
 ,RRO VARCHAR(500)  
   
)  
  
DECLARE @min INT  
DECLARE @max INT  
---------------------------------  
DECLARE @sCenterName VARCHAR(100)  
DECLARE @iCenterID INT  
DECLARE @sIUH VARCHAR(500)  
DECLARE @sILH VARCHAR(500)  
DECLARE @sICN VARCHAR(500)  
DECLARE @sICT VARCHAR(500)  
DECLARE @sIRO VARCHAR(500)  
DECLARE @sRUH VARCHAR(500)  
DECLARE @sRLH VARCHAR(500)  
DECLARE @sRCN VARCHAR(500)  
DECLARE @sRCT VARCHAR(500)  
DECLARE @sRTC VARCHAR(500)  
DECLARE @sRRO VARCHAR(500)  
---------------------------------  
SELECT @min = MIN(ROWID), @max = MAX(ROWID) FROM @TempCenter  
  
WHILE @min <= @max  
BEGIN  
 SELECT @iCenterID = I_Center_ID FROM @TempCenter WHERE ROWID = @min  
 SELECT @sCenterName = S_Center_Name FROM dbo.T_Centre_Master WHERE I_Centre_Id = @iCenterID  
 SELECT @sIUH = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'INVOICE_UPPER_HEADER')  
 SELECT @sILH = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'INVOICE_LOWER_HEADER')  
 SELECT @sICN = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'INVOICE_CENTER_NAME')  
 SELECT @sICT = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'INVOICE_CENTER_TYPE')  
 SELECT @sIRO = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'INVOICE_REGISTER_OFFICE')  
 SELECT @sRUH = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_UPPER_HEADER')  
 SELECT @sRLH = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_LOWER_HEADER')  
 SELECT @sRCN = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_CENTER_NAME')  
 SELECT @sRCT = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_CENTER_TYPE')  
 SELECT @sRTC = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_TERMS_AND_CONDITIONS')  
 SELECT @sRRO = ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iCenterID,'RECEIPT_REGISTER_OFFICE')  
   
 INSERT INTO @CONFIGTABLE  
 VALUES(@sCenterName,@sIUH,@sILH,@sICN,@sICT,@sIRO,@sRUH,@sRLH,@sRCN,@sRCT,@sRTC,@sRRO)  
  
 SET @min = @min + 1  
END  
 SELECT * FROM @CONFIGTABLE  
END
