CREATE PROC [dbo].[uspCheckUnrestrictedEmail]-- 'aaa@abc.com','9/1/2004 12:00:00 AM'       
(                
 @sEmail varchar(200),  
 @dtBDate DATETIME             
)                
AS                 
BEGIN                
              
SET NOCOUNT ON   
  
DECLARE @Flag INT =0               
      
 IF EXISTS(SELECT I_Enquiry_Regn_ID FROM dbo.T_Enquiry_Regn_Detail WHERE S_Email_ID = @sEmail AND  Dt_Birth_Date = @dtBDate)  
   BEGIN  
   IF EXISTS(SELECT * FROM dbo.T_Unrestricted_EmailId_List WHERE S_Email_Id = @sEmail)   
        BEGIN
        	SET @Flag=1 
			SELECT @Flag
        END
 
   ELSE  
   SELECT @Flag         
END  
ELSE 
 begin
 SET @Flag=1 
SELECT @Flag
end
END
