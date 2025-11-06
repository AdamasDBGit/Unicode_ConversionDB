
CREATE PROCEDURE [dbo].[KPMG_uspGetGridDateForPO]
@POID	varchar(50),
@ItemID	xml
--@STR_PASSWORD	VARCHAR(255)
--@STR_USERSESSION	VARCHAR(255)
AS
BEGIN
	
	SET NOCOUNT ON;
	--DECLARE @UniqueId	INT
	--DECLARE @SQL_str	VARCHAR(255)
	
	 Declare @TempTable table
    (    
		ID INT,
		PoId varchar(255),
		ItemId varchar(255)
    )
	
	IF ISNULL(CAST(@ItemID as varchar(max)),'') <> ''
	BEGIN
		print '111'
		INSERT INTO @TempTable (ID,PoId,ItemId) 
		SELECT Tbl_KPMG_PoDetails.Fld_KPMG_PoPr_Id,Tbl_KPMG_PoDetails.Fld_KPMG_PO_Id,Tbl_KPMG_PoDetails.Fld_KPMG_Item_Id 
		FROM Tbl_KPMG_PoDetails join @ItemID.nodes('/root/Id') COM(Col)
		ON Tbl_KPMG_PoDetails.Fld_KPMG_Item_Id  = COM.Col.value('.[1]','VARCHAR(100)')
		 WHERE Tbl_KPMG_PoDetails.Fld_KPMG_PO_Id = @POID	
		

		--select  COM.Col.value('.[1]','VARCHAR(100)') FROM @ItemID.nodes('/root/Id') COM(Col)
	END
	ElSE
	BEGIN
		print '222'
		INSERT INTO @TempTable (ID,PoId,ItemId) 
		SELECT Tbl_KPMG_PoDetails.Fld_KPMG_PoPr_Id,Tbl_KPMG_PoDetails.Fld_KPMG_PO_Id,Tbl_KPMG_PoDetails.Fld_KPMG_Item_Id
		FROM Tbl_KPMG_PoDetails WHERE Tbl_KPMG_PoDetails.Fld_KPMG_PO_Id = @POID	
	END
	
	
	 
	
	 ---select * from @TempTable
	SELECT Tbl_KPMG_PoDetails.Fld_KPMG_PoPr_Id as SLNo , Tbl_KPMG_PoDetailItems.Fld_KPMG_Barcode as BarCode,
	 Tbl_KPMG_PoDetails.Fld_KPMG_Item_Id as ItemCode, 0 as IsIssued,T_Course_Master.S_Course_Name AS CourseName
	from Tbl_KPMG_PoDetails(nolock) join Tbl_KPMG_PoDetailItems(nolock) 
	on Tbl_KPMG_PoDetails.Fld_KPMG_PoPr_Id =Tbl_KPMG_PoDetailItems.Fld_KPMG_PoPr_Id
	INNER JOIN Tbl_KPMG_SM_List ON Tbl_KPMG_PoDetails.Fld_KPMG_Item_Id=Tbl_KPMG_SM_List.Fld_KPMG_ItemCode
	INNER JOIN T_Course_Master ON Tbl_KPMG_SM_List.Fld_KPMG_CourseId=T_Course_Master.I_Course_ID
	WHERE Tbl_KPMG_PoDetails.Fld_KPMG_PoPr_Id IN (SELECT ID FROM @TempTable)
	AND Tbl_KPMG_PoDetailItems.Fld_KPMG_Status=0
	--select Fld_KPMG_Item_Id as ItemId from Tbl_KPMG_PoDetails(nolock) where Fld_KPMG_PO_Id=  ISNULL(@POID,0)
	
    
	
END
