
CREATE PROCEDURE [dbo].[KPMG_uspGetAllItemCodes]

AS
BEGIN
	
	SET NOCOUNT ON;
	select distinct(Fld_KPMG_ItemCode) as ItemId from Tbl_KPMG_SM_List (nolock)	
	
END
