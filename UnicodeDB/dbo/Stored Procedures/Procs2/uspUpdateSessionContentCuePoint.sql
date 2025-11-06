CREATE PROCEDURE [dbo].[uspUpdateSessionContentCuePoint]  
(  
@I_Cue_Point_Details_ID INT,  
@I_Batch_Content_Details_ID INT,  
@S_Topic_Name NVARCHAR(max),  
@dt_Time DATETIME,  
@S_Crtd_By NVARCHAR(max)=NULL,  
@Dt_Crtd_On DATETIME=NULL,  
@S_Upd_By NVARCHAR(max)=NULL,  
@Dt_Upd_By DATETIME=NULL,  
@Flag BIT  
)  
AS  
begin  
BEGIN TRY  
 IF @Flag=0  
 BEGIN  
 IF @I_Cue_Point_Details_ID=0  
 BEGIN  
  INSERT INTO dbo.T_Session_Content_CuePoint_Details  
          ( I_Batch_Content_Details_ID ,  
            S_Topic_Name ,  
            dt_Time,  
            S_Crtd_By,  
            Dt_Crtd_On  
          )  
  VALUES  ( @I_Batch_Content_Details_ID , -- I_Batch_Content_Details_ID - int  
            @S_Topic_Name , -- S_Topic_Name - nvarchar(max)  
            @dt_Time,  -- dt_Time - datetime  
            @S_Crtd_By,  
            @Dt_Crtd_On  
          )  
 SET @I_Cue_Point_Details_ID=@@IDENTITY  
   
   
 END  
 ELSE  
 UPDATE dbo.T_Session_Content_CuePoint_Details   
 SET I_Batch_Content_Details_ID=@I_Batch_Content_Details_ID,S_Topic_Name=@S_Topic_Name,  
 dt_Time=@dt_Time,S_Upd_By=@S_Upd_By,Dt_Upd_By=@Dt_Upd_By  
 WHERE I_Cue_Point_Details_ID = @I_Cue_Point_Details_ID  
   
 END  
 ELSE  
 DELETE FROM dbo.T_Session_Content_CuePoint_Details  
 WHERE I_Cue_Point_Details_ID=@I_Cue_Point_Details_ID  
   
 SELECT @I_Cue_Point_Details_ID  
END TRY  
BEGIN CATCH   
 DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)   
END CATCH  
end


