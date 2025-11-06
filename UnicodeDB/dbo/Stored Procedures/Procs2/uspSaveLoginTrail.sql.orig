CREATE PROCEDURE [dbo].[uspSaveLoginTrail]     
(    
 @iUserID INT,    
 @dCurrentDate DATETIME,    
 @iFlag INT,    
 @sUserSessionStateID VARCHAR(50),  
 @sIPAddress VARCHAR(50)    
)    
    
AS    
BEGIN TRY    
 SET NOCOUNT ON;    
    
 IF(@iFlag=2)    
 BEGIN    
  DECLARE @iLoginTrailID INT    
  SET @iLoginTrailID = (SELECT TOP 1 I_Login_Trail_ID FROM dbo.T_Login_Trail WHERE I_User_ID= @iUserID AND Dt_Logout_Time IS NULL ORDER BY Dt_Login_Time DESC)    
    
  UPDATE dbo.T_Login_Trail    
  SET Dt_Logout_Time = @dCurrentDate    
  WHERE I_Login_Trail_ID=@iLoginTrailID AND S_UserSessionID=@sUserSessionStateID    
 END     
    
 IF(@iFlag=1)    
 BEGIN     
  INSERT INTO dbo.T_Login_Trail(I_User_ID,Dt_Login_Time,S_UserSessionID,S_IP_Address)    
  VALUES ( @iUserID,@dCurrentDate,@sUserSessionStateID,@sIPAddress)  
  set @iLoginTrailID = @@identity  
 END    
 select @iLoginTrailID   
END TRY    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
