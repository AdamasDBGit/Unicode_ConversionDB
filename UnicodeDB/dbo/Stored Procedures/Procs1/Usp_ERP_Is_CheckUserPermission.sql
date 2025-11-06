CREATE Proc [dbo].[Usp_ERP_Is_CheckUserPermission](    
 @Userid int,@Permissionname NVARCHAR(MAX)  =null  
 )    
 As Begin     
 Declare @Flag int    
 IF Exists (    
 Select 1 from T_ERP_Users_Role_Permission_Map RPM    
 Inner Join T_ERP_Permission P on P.I_Permission_ID=RPM.Permission_ID    
 where RPM.I_User_Id=@Userid 
 --and P.S_PageUniqueCode=@Permissionname
 )    
 Begin      
 SET @Flag=1    
 End     
 Else    
 Begin    
 SET @Flag=0    
 End     
 Select @Flag as CheckAllow    
 End

