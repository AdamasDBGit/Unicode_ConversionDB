--SELECT * FROM dbo.T_Batch_Content_Details AS tbcd    
    
--sp_helptext uspSaveInOtherBatches    
    
CREATE PROCEDURE [dbo].[uspSaveInOtherBatches]                  
(                
 @I_Batch_Content_Details_ID INT,                  
 @I_Batch_ID INT,                  
 @I_Term_ID INT,                  
 @I_Module_ID INT,                  
 @I_Session_ID INT,                  
 @S_Session_Alias VARCHAR(250),                  
 @S_Session_Chapter VARCHAR(250),                  
 @S_Session_Description VARCHAR(500),                  
 @S_Content_URL VARCHAR(500),                  
 @S_Crtd_By VARCHAR(20)=NULL,                  
 @Dt_Crtd_On DATETIME=NULL,        
 @iSrcBatchContentId INT,      
 @IsActive BIT  ,    
 @I_Folder_Id INT,  
 @S_Session_Name VARCHAR(500),  
 @S_Session_Topic VARCHAR(500)           
)                
AS                   
BEGIN TRY                  
 DECLARE @destinationBatchContentId INT     
 IF(@I_Session_ID IS NOT NULL)  
  BEGIN  
  SELECT @destinationBatchContentId = I_Batch_Content_Details_ID FROM dbo.T_Batch_Content_Details WHERE I_Batch_ID = @I_Batch_ID AND I_Term_ID = @I_Term_ID AND I_Module_ID = @I_Module_ID AND I_Session_ID = @I_Session_ID          
    IF(@destinationBatchContentId > 0)              
   BEGIN              
     UPDATE dbo.T_Batch_Content_Details SET S_Session_Alias = @S_Session_Alias,S_Session_Chapter = @S_Session_Chapter,S_Session_Description = @S_Session_Description,S_Content_URL = @S_Content_URL,I_Folder_Id = @I_Folder_Id, S_Upd_By = @S_Crtd_By, Dt_Upd_On = @Dt_Crtd_On, B_IsActive
 = @IsActive              
     WHERE I_Batch_ID = @I_Batch_ID AND I_Term_ID = @I_Term_ID AND I_Module_ID = @I_Module_ID AND I_Session_ID = @I_Session_ID        
   END              
  ELSE              
   BEGIN        
     INSERT INTO T_Batch_Content_Details (I_Batch_ID,I_Folder_Id ,I_Term_ID,I_Module_ID, I_Session_ID, S_Session_Alias, S_Session_Chapter, S_Session_Description, S_Content_URL, S_Crtd_By, Dt_Crtd_On,B_IsActive)                
     VALUES(@I_Batch_ID,@I_Folder_Id,@I_Term_ID, @I_Module_ID, @I_Session_ID, @S_Session_Alias, @S_Session_Chapter, @S_Session_Description, @S_Content_URL, @S_Crtd_By, @Dt_Crtd_On,@IsActive)                
             
     SELECT @destinationBatchContentId= @@IDENTITY        
   END               
  END  
 ELSE  
  BEGIN  
  SELECT @destinationBatchContentId = I_Batch_Content_Details_ID FROM dbo.T_Batch_Content_Details WHERE I_Batch_ID = @I_Batch_ID AND I_Term_ID = @I_Term_ID AND I_Module_ID = @I_Module_ID AND S_Session_Name = @S_Session_Name AND S_Session_Topic = @S_Session_Topic          
    IF(@destinationBatchContentId > 0)              
   BEGIN              
     UPDATE dbo.T_Batch_Content_Details SET S_Session_Alias = @S_Session_Alias,S_Session_Chapter = @S_Session_Chapter,S_Session_Description = @S_Session_Description,S_Content_URL = @S_Content_URL,I_Folder_Id = @I_Folder_Id, S_Upd_By = @S_Crtd_By, Dt_Upd_On = @Dt_Crtd_On, B_IsActive
 = @IsActive              
     WHERE I_Batch_ID = @I_Batch_ID AND I_Term_ID = @I_Term_ID AND I_Module_ID = @I_Module_ID AND S_Session_Name = @S_Session_Name AND S_Session_Topic = @S_Session_Topic         
   END              
  ELSE              
   BEGIN        
     INSERT INTO T_Batch_Content_Details (I_Batch_ID,I_Folder_Id ,I_Term_ID,I_Module_ID, I_Session_ID, S_Session_Alias, S_Session_Chapter, S_Session_Description, S_Content_URL, S_Crtd_By, Dt_Crtd_On,B_IsActive,S_Session_Name,S_Session_Topic)              
  
     VALUES(@I_Batch_ID,@I_Folder_Id,@I_Term_ID, @I_Module_ID, @I_Session_ID, @S_Session_Alias, @S_Session_Chapter, @S_Session_Description, @S_Content_URL, @S_Crtd_By, @Dt_Crtd_On,@IsActive,@S_Session_Name,@S_Session_Topic)                
             
     SELECT @destinationBatchContentId= @@IDENTITY        
   END         
  END     
  --Update Cue Points from the source Batch        
  DELETE FROM dbo.T_Session_Content_CuePoint_Details WHERE I_Batch_Content_Details_ID = @destinationBatchContentId        
  INSERT INTO dbo.T_Session_Content_CuePoint_Details        
          ( I_Batch_Content_Details_ID ,        
            S_Topic_Name ,        
            dt_Time ,        
            S_Crtd_By ,        
            Dt_Crtd_On        
          )        
  SELECT @destinationBatchContentId,S_Topic_Name,dt_Time,@S_Crtd_By,@Dt_Crtd_On FROM dbo.T_Session_Content_CuePoint_Details WHERE I_Batch_Content_Details_ID = @iSrcBatchContentId                   
END TRY                  
BEGIN CATCH                  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int                  
 SELECT @ErrMsg = ERROR_MESSAGE(),                  
 @ErrSeverity = ERROR_SEVERITY()                  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)                  
END CATCH
