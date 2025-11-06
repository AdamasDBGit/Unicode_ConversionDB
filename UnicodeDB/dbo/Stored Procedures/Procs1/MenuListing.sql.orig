CREATE PROCEDURE [dbo].[MenuListing] 
-- =============================================
-- Author:		Tridip Chatterjee
-- Create date: 20-09-2023
-- Description:	To Search and get the menu list
-- =============================================
-- Add the parameters for the stored procedure here
@Menuname varchar(255)=null,
@MenuID int = null



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	Select * from T_Erp_Menu where (S_Name=@Menuname or @Menuname is null) and I_Menu_ID =ISNULL(@MenuID,I_Menu_ID); 


END
