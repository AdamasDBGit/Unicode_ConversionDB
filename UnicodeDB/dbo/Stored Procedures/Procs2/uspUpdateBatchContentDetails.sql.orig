--sp_helptext uspUpdateBatchContentDetails

CREATE PROCEDURE [dbo].[uspUpdateBatchContentDetails]      
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
@S_Upd_By VARCHAR(20) = NULL,      
@Dt_Upd_On DATETIME=NULL,    
@IsACtive BIT,  
@sSessionName VARCHAR(500),  
@sSessionTopic VARCHAR(500) 
)        
AS      
begin      
BEGIN TRY      
      
IF @I_Batch_Content_Details_ID=0      
BEGIN      
 INSERT INTO dbo.T_Batch_Content_Details      
   ( I_Batch_ID ,      
     I_Term_ID ,      
     I_Module_ID ,      
     I_Session_ID ,      
     S_Session_Alias ,      
     S_Session_Chapter ,      
     S_Session_Description ,      
     S_Content_URL ,      
     S_Crtd_By ,      
     Dt_Crtd_On,    
     B_IsActive,  
     S_Session_Name,  
     S_Session_Topic       
   )      
 VALUES  ( @I_Batch_ID , -- I_Batch_ID - int      
    @I_Term_ID , -- I_Term_ID - int      
     @I_Module_ID , -- I_Module_ID - int      
     @I_Session_ID , -- I_Session_ID - int      
     @S_Session_Alias , -- S_Session_Alias - varchar(250)      
     @S_Session_Chapter , -- S_Session_Chapter - varchar(250)      
     @S_Session_Description , -- S_Session_Description - varchar(500)      
     @S_Content_URL , -- S_Content_URL - varchar(500)      
     @S_Crtd_By , -- S_Crtd_By - varchar(20)      
     @Dt_Crtd_On,  -- Dt_Crtd_On - datetime      
     @IsACtive,  
     @sSessionName,  
     @sSessionTopic      
   )      
 SET @I_Batch_Content_Details_ID=@@IDENTITY
 --SET @I_Folder_Id = @@IDENTITY
 UPDATE dbo.T_Batch_Content_Details SET I_Folder_Id=@I_Batch_Content_Details_ID WHERE I_Batch_Content_Details_ID=@I_Batch_Content_Details_ID
END      
ELSE      
 UPDATE dbo.T_Batch_Content_Details       
 SET I_Batch_ID=@I_Batch_ID,I_Term_ID=@I_Term_ID,I_Module_ID=@I_Module_ID,I_Session_ID=@I_Session_ID,S_Session_Alias=@S_Session_Alias,      
 S_Session_Chapter=@S_Session_Chapter,S_Session_Description=@S_Session_Description,S_Content_URL=@S_Content_URL,      
 S_Upd_By=@S_Upd_By,Dt_Upd_On=@Dt_Upd_On,B_IsActive = @IsACtive
 WHERE I_Batch_Content_Details_ID=@I_Batch_Content_Details_ID      
       
SELECT @I_Batch_Content_Details_ID      
END TRY      
BEGIN CATCH      
DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)       
       
END catch      
end
