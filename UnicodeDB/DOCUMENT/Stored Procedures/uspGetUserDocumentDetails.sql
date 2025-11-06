--sp_helptext '[DOCUMENT].[uspGetUserDocumentDetails]'  
  
CREATE PROCEDURE [DOCUMENT].[uspGetUserDocumentDetails]     
(            
 -- Add the parameters for the stored procedure here            
 @iCategoryID INT ,            
 @dtStartDate DATETIME = NULL,            
 @dtEndDate DATETIME = NULL,            
 @sFileName varchar(250) = NULL,  
 @iBrandID INT =NULL
)            
            
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 SET NOCOUNT ON           
    DECLARE @dtCurrentDate DATETIME         
            
    SET @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())          
            
    SELECT tud.I_Document_ID,I_Category_ID,tud.I_Brand_ID,S_File_Name,S_File_Path,Dt_Expiry_Date,I_File_Size,I_Hierarchy_Detail_ID,Dt_CreatedOn FROM DOCUMENT.T_User_Documents AS tud        
  WHERE tud.I_Category_ID = @iCategoryID AND 
  tud.I_Brand_ID=ISNULL(@iBrandID,tud.I_Brand_ID)        
  AND tud.S_File_Name = ISNULL(@sFileName,tud.S_File_Name)         
  AND CAST(CONVERT(VARCHAR(10), tud.Dt_CreatedOn, 101) AS DATETIME) >= ISNULL(@dtStartDate,tud.Dt_CreatedOn)         
  AND CAST(CONVERT(VARCHAR(10), tud.Dt_CreatedOn, 101) AS DATETIME) <= ISNULL(@dtEndDate, tud.Dt_CreatedOn)    
  AND tud.Dt_Expiry_Date >= @dtCurrentDate    
      
      
      
END
