  
CREATE PROCEDURE dbo.usp_ERP_UpdatePassword     
    @inUserId INT,      
    @stCurrentPassword NVARCHAR(max),  
    @stNewPassword NVARCHAR(max)  
AS      
BEGIN      
  
        SET NOCOUNT ON;  
  
        DECLARE @oldPassword NVARCHAR(max);  
  
        SELECT   
            @oldPassword = S_Password   
        FROM T_ERP_User   
        WHERE I_User_ID = @inUserId;  
  
        IF @oldPassword != @stCurrentPassword  
        BEGIN  
            SELECT 0 AS StatusFlag, 'The current password you entered is incorrect. Please try again' AS Message;  
            RETURN;  
        END  
        ELSE  
        BEGIN  
            UPDATE T_ERP_User SET      
                S_Password = @stNewPassword,  
                isPasswordChanged = 1  
            WHERE I_User_ID = @inUserId;  
  
            SELECT 1 AS StatusFlag, 'Password reset successfully' AS Message;  
            RETURN;  
        END  
END 
