CREATE PROCEDURE [dbo].[MenuPermissionAddUpdate] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 21-09-2023
-- Description:	Menu Permission Add or Update
-- =============================================
-- Add the parameters for the stored procedure here
	
@MenuID int =null,
@UTPermission [UT_Permission] readonly,
@CreatedBy int=null,
@Status int =null

AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
       SET NOCOUNT ON;
	   delete from T_ERP_Menu_Permission where I_Menu_ID = @MenuID
	   INSERT INTO T_ERP_Menu_Permission
	   (
	   I_Menu_ID
	   ,I_Status
	   ,S_Permission_Name
	   ,I_CreatedBy
	   ,Dt_CreatedAt
	   )
	   select @MenuID,1,S_PermissionName,@CreatedBy,GETDATE() from  @UTPermission
	   select 1 as statusFlag, 'Permission updated successfully' as Message

END TRY
BEGIN CATCH  
    
 throw 50001,'Menu Permission Already Exsist',1;  
          
END CATCH; 

END
