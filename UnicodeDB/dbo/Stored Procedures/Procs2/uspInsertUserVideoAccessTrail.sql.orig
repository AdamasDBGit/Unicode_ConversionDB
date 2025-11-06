CREATE PROCEDURE [dbo].[uspInsertUserVideoAccessTrail]  
(  
@iUserID INT,  
@iBatchContentDetailsID INT,  
@sIPAddress VARCHAR(50),
@dtLoginTime DATETIME  
)  
AS  
BEGIN  
 BEGIN TRY  
    
  INSERT INTO dbo.T_User_Video_Access_Trail
          ( I_User_ID,
            I_Batch_Content_Details_ID ,  
            Dt_Login_Time,  
            S_IP_Address 
          )  
  VALUES  ( @iUserID,
			@iBatchContentDetailsID , 
            @dtLoginTime, 
            @sIPAddress
          )  
 
 SELECT @@IDENTITY
 END TRY  
 BEGIN CATCH   
  DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
  SELECT @ErrMsg = ERROR_MESSAGE(),    
  @ErrSeverity = ERROR_SEVERITY()    
  
  RAISERROR(@ErrMsg, @ErrSeverity, 1)     
 END CATCH   
END
