CREATE PROCEDURE [dbo].[uspGetUserPasswordforNonAE] --[dbo].[uspGetUserPasswordforNonAE] '05-0693  
(  
 @sLoginID Nnvarchar(max)  
   
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;    
   
 IF EXISTS ( SELECT I_User_ID FROM dbo.T_User_Master  
    WHERE S_Login_ID = @sLoginID   
    AND I_Status = 1  
    AND S_User_Type <> 'AE')  
 BEGIN  
   
   SELECT S_Password, S_Email_ID  
   FROM dbo.T_User_Master       
   WHERE S_Login_ID = @sLoginID   
   AND I_Status = 1  
   AND S_User_Type <> 'AE'  
 END 
 ELSE
 BEGIN
  
   SELECT ISNULL(S_Password,'') AS S_Password, ISNULL(S_Email_ID,'') AS S_Email_ID  
   FROM dbo.T_User_Master       
   WHERE S_Login_ID = @sLoginID   
   AND I_Status = 1  
   AND S_User_Type <> 'AE'  
 
 end 
    
   
END

