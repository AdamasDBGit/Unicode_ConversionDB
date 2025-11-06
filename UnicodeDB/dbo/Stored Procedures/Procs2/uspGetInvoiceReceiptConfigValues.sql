CREATE PROCEDURE [dbo].[uspGetInvoiceReceiptConfigValues]  
(  
 @iHierarchyDetailID INT  
)    
AS  
BEGIN  
--------------------------------------------------------------------------------   
DECLARE @sSearchCriteria nvarchar(max)  
  
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
  CENTERNAME nvarchar(max)  
 ,IUH nvarchar(max)  
 ,ILH nvarchar(max)  
 ,ICN nvarchar(max)  
 ,ICT nvarchar(max)  
 ,IRO nvarchar(max)  
 ,RUH nvarchar(max)  
 ,RLH nvarchar(max)  
 ,RCN nvarchar(max)  
 ,RCT nvarchar(max)  
 ,RTC nvarchar(max)  
 ,RRO nvarchar(max)  
   
)  
  
DECLARE @min INT  
DECLARE @max INT  
---------------------------------  
DECLARE @sCenterName nvarchar(max)  
DECLARE @iCenterID INT  
DECLARE @sIUH nvarchar(max)  
DECLARE @sILH nvarchar(max)  
DECLARE @sICN nvarchar(max)  
DECLARE @sICT nvarchar(max)  
DECLARE @sIRO nvarchar(max)  
DECLARE @sRUH nvarchar(max)  
DECLARE @sRLH nvarchar(max)  
DECLARE @sRCN nvarchar(max)  
DECLARE @sRCT nvarchar(max)  
DECLARE @sRTC nvarchar(max)  
DECLARE @sRRO nvarchar(max)  
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
