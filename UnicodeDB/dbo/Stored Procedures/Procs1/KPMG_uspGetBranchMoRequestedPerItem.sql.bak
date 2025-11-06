
CREATE PROCEDURE [dbo].[KPMG_uspGetBranchMoRequestedPerItem]
@FromDate NVARCHAR(MAX),
@ToDate NVARCHAR(MAX),
@BranchName xml,
@ItemCode NVARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	Declare @tempTable table (Id int identity,MoveOrderId int, CreatedDate varchar(50),BranchName varchar(50), BranchId varchar(50),QtyRequested varchar(100),QtyReceived varchar(100),QtyInTransit varchar(100))
	
	
	INSERT INTO @tempTable (MoveOrderId,CreatedDate,BranchName,BranchId,QtyRequested)
	select   Tbl_KPMG_MoMaster.Fld_KPMG_Mo_Id as MoId
			,Tbl_KPMG_MoMaster.[Fld_KPMG_Created Date] as CreatedDate
			,T_Center_Hierarchy_Name_Details.S_Center_Name as CenterName
			,T_Center_Hierarchy_Name_Details.I_Center_ID as CenterId
			--,Tbl_KPMG_MoItems.Fld_KPMG_Itemcode as ItemCode
			,Tbl_KPMG_MoItems.Fld_KPMG_Quantity as Quantity
	from Tbl_KPMG_MoMaster(nolock) join T_Center_Hierarchy_Name_Details(nolock)
		on Tbl_KPMG_MoMaster.Fld_KPMG_Branch_Id = T_Center_Hierarchy_Name_Details.I_Center_ID
	join Tbl_KPMG_MoItems (nolock)
		on Tbl_KPMG_MoMaster.Fld_KPMG_Mo_Id = Tbl_KPMG_MoItems.Fld_KPMG_Mo_Id
	where [Fld_KPMG_Created Date] between @FromDate and @ToDate
	and  T_Center_Hierarchy_Name_Details.S_Center_Name  IN 
		(   SELECT c.value('(.)', 'VARCHAR(50)')FROM @BranchName.nodes('root/name') t(c))
	AND  Tbl_KPMG_MoItems.Fld_KPMG_Itemcode = @ItemCode
--	select distinct(Fld_KPMG_ItemCode) as ItemId from Tbl_KPMG_SM_List (nolock)	

	DECLARE @rowCount int 
	DECLARE @counter int
	DECLARE @moveOrderId varchar(100)
	DECLARE @branchId varchar(100)
	DECLARE @stockId INT
	DECLARE @inTransStockId INT
	SELECT @rowCount = COUNT(1) from @tempTable	
	SET @counter = 1
	WHILE (@counter <= @rowCount)
	BEGIN
		SELECT @moveOrderId = MoveOrderId,@branchId = BranchId  from @tempTable WHERE Id = @counter
		
		SELECT @stockId = Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster (nolock)
		WHERE Fld_KPMG_Mo_Id = @moveOrderId AND Fld_KPMG_Branch_Id = @branchId AND Fld_KPMG_FromBranch_Id =@branchId  AND Fld_KPMG_ItemCode = @ItemCode
		
		SELECT @inTransStockId = Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster (nolock)
		WHERE Fld_KPMG_Mo_Id = @moveOrderId AND Fld_KPMG_Branch_Id = @branchId AND Fld_KPMG_FromBranch_Id =0  AND Fld_KPMG_ItemCode = @ItemCode
		
		
		UPDATE @tempTable SET 
		QtyReceived = (SELECT COUNT(1) FROM Tbl_KPMG_StockDetails(nolock) where Fld_KPMG_Stock_Id
					   IN (SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster (nolock)
						   WHERE Fld_KPMG_Mo_Id = @moveOrderId AND Fld_KPMG_Branch_Id = @branchId AND Fld_KPMG_FromBranch_Id =@branchId  AND Fld_KPMG_ItemCode = @ItemCode ))
		,
		QtyInTransit = (SELECT COUNT(1) FROM Tbl_KPMG_StockDetails(nolock) where Fld_KPMG_Stock_Id
					   IN (SELECT  Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockMaster (nolock)
						   WHERE Fld_KPMG_Mo_Id = @moveOrderId AND Fld_KPMG_Branch_Id = @branchId AND Fld_KPMG_FromBranch_Id =0  AND Fld_KPMG_ItemCode = @ItemCode))
						   						   
		WHERE Id = @counter
		
		SET @moveOrderId = ''
		SET @branchId = ''
		SET @inTransStockId = 0
		SET @stockId = 0
		SET @counter = @counter +  1		 
	END
				  
	SELECT ISNULL(MoveOrderId,0) as MoveOrderId ,ISNULL(CreatedDate,'') as CreatedDate
	,ISNULL(BranchName,'') as BranchName, ISNULL(BranchId,'') as BranchId
	,ISNULL(QtyRequested,'0') as QtyRequested, @ItemCode as ItemCode,
	ISNULL(QtyReceived,'0') as  QtyReceived,ISNULL(QtyInTransit,'0') as QtyInTransit FROM @tempTable 
END

