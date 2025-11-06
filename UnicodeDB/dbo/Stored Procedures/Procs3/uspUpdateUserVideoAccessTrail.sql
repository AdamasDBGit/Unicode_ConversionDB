CREATE PROCEDURE [dbo].[uspUpdateUserVideoAccessTrail]  
(  
@iVideoAccessTrailID INT,  
@dtLogoutTime DATETIME  
)  
AS  
BEGIN  
 BEGIN TRY  
    
  UPDATE dbo.T_User_Video_Access_Trail
  SET Dt_Logout_Time = @dtLogoutTime WHERE I_Video_Access_Trail_ID = @iVideoAccessTrailID
 
 END TRY  
 BEGIN CATCH   
  DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
  SELECT @ErrMsg = ERROR_MESSAGE(),    
  @ErrSeverity = ERROR_SEVERITY()    
  
  RAISERROR(@ErrMsg, @ErrSeverity, 1)     
 END CATCH   
END
