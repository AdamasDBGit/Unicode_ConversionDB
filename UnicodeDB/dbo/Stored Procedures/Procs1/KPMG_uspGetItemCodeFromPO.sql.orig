
CREATE PROCEDURE [dbo].[KPMG_uspGetItemCodeFromPO]
@POID	varchar(50)
--@STR_PASSWORD	VARCHAR(255)
--@STR_USERSESSION	VARCHAR(255)
AS
BEGIN
	
	SET NOCOUNT ON;
	--DECLARE @UserId	INT
	select distinct(Fld_KPMG_Item_Id) as ItemId , B.Fld_KPMG_ItemCode_Description AS Description  from Tbl_KPMG_PoDetails(nolock) A
	inner join Tbl_KPMG_SM_List B ON A.Fld_KPMG_Item_Id=B.Fld_KPMG_ItemCode
	 where Fld_KPMG_PO_Id=  ISNULL(@POID,'')
	
    
	
END
