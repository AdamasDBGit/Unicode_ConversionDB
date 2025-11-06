CREATE PROCEDURE  [dbo].[MenuPermissionListing]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 21-09-2023
-- Description:	Menu Permission Listing
--exec [dbo].[MenuPermissionListing] 7
-- =============================================
-- Add the parameters for the stored procedure here
@MenuID int =null 

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
	 SET NOCOUNT ON;
	
	



	 IF @MenuID is not Null ---***MENU_ID_PARAMETER_CHEACHING****
	
	   BEGIN
	
	      DECLARE @ID int
	      Set @ID=(select I_Menu_ID from T_ERP_Menu where I_Menu_ID=@MenuID)
  	 
	
          IF @MenuID=@ID ---***MENU_ID_EQUEL_VALUE_CHEACHING****
	
	      select 
	      TEMP.I_Menu_ID as MenuID,
		  TEMP.I_Menu_Permission_ID,
          TEMP.S_Permission_Name as PermissionName,
		  TEMP.I_Status as Permission_Status,
		  TEM.S_Name as Menu_Name 

          from 
		  T_Erp_Menu TEM
          left Join T_Erp_Menu_Permission TEMP on 
	      TEMP.I_Menu_ID=TEM.I_Menu_ID

	      Where 
	      TEMP.I_Menu_ID=@ID ;	
	
	      ELSE 
	      Select 1,'Invalid Menu' Message
	   END
	
	
	IF @MenuID is null---***MENU_ID_NULL_VALUE_CHEACHING****


	select 
	TEMP.I_Menu_ID,
	TEMP.I_Menu_Permission_ID,
    TEMP.S_Permission_Name as PermissionName,
	TEMP.I_Status as Permission_Status,
	TEM.S_Name as Menu_Name 

    from 
	T_Erp_Menu TEM
    left Join T_Erp_Menu_Permission TEMP on 
	TEMP.I_Menu_ID=TEM.I_Menu_ID;




END
