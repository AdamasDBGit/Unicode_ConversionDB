  
-- =============================================  
-- Author:  <Swadesh Bhattacharya>  
-- Create date: <24-09-2023>  
-- Description: <User Roll Map Permission Details>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetUserRollMapPermission]-- 2  
 -- Add the parameters for the stored procedure here  
  @UserId int  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
;with UserPermission as    
   (    
    SELECT UN.I_User_ID  
   , S_Username  
   , S_Password  
   , UR.[I_Role_ID]  
   , RL.S_Role_Name   
   , RP.I_Menu_Permission_ID  
   , isnull(MP.S_Permission_Name,'Gatepass') S_Permission_Name  
   , isnull(MN.S_Name,'GatePass') S_Name  
 FROM [dbo].[T_ERP_User] UN  
  JOIN [dbo].[T_ERP_User_Role] UR ON UN.I_User_ID=UR.I_User_ID  
  JOIN [dbo].[T_ERP_Role] RL ON RL.I_Role_ID=UR.I_Role_ID  
 LEFT JOIN [dbo].[T_ERP_Role_Permission] RP ON RL.I_Role_ID=RP.I_Role_ID  
 LEFT JOIN [dbo].[T_ERP_Menu_Permission] MP ON MP.I_Menu_Permission_ID=RP.I_Menu_Permission_ID  
 LEFT JOIN [dbo].[T_ERP_Menu] MN ON MN.I_Menu_ID=MP.I_Menu_ID   
 WHERE UN.I_User_ID=@UserId  
    )    
   
SELECT DISTINCT I_User_ID,S_Username,S_Name,S_Permission_Name FROM UserPermission WHERE S_Permission_Name IS NOT NULL  
END
