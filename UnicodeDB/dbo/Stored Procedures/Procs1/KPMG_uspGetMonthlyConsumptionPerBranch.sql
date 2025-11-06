
CREATE PROCEDURE [dbo].[KPMG_uspGetMonthlyConsumptionPerBranch]
@BranchId NVARCHAR(MAX),
@StartMonth INT,
@EndMonth INT
AS
BEGIN
	
	SET NOCOUNT ON;
	--DECLARE @BranchId INT
	DECLARE @rowCount INT
	DECLARE @counter INT
	Declare @tempTable table (Id int identity,StockId int, ItemCode varchar(50), MoveOrderId varchar(50), MonthVal INT)
	Declare @finalTable table (Id int identity,StockId int, ItemCode varchar(50),CourseName varchar(100), MoveOrderId varchar(50), MonthVal INT, TotalAmount INT)
	
	--SELECT @BranchId = I_Center_ID FROM T_Center_Hierarchy_Name_Details WHERE S_Center_Name = ISNULL(@BranchName,'')
	print '1'
	IF ISNULL(@BranchId,0) > 0
	BEGIN
		INSERT INTO @tempTable(StockId , ItemCode,MoveOrderId , MonthVal)
		select A.Fld_KPMG_Stock_Id, A.Fld_KPMG_ItemCode,A.Fld_KPMG_Mo_Id,datepart(month,A.Fld_KPMG_LastRecvDate)		
		from Tbl_KPMG_StockMaster A		
		where A.Fld_KPMG_Branch_Id = @BranchId and A.Fld_KPMG_FromBranch_Id = @BranchId
		AND datepart(month,A.Fld_KPMG_LastRecvDate) between @StartMonth AND @EndMonth
		print '2'
		DECLARE @itemCount INT
		DECLARE @stockId INT
		DECLARE @itemCode INT
		DECLARE @monthVal INT
		DECLARE @courseName varchar(255)
		SELECT @rowCount =  COUNT(1) FROM @tempTable
		SET @counter = 1
		WHILE @counter <= @rowCount
		BEGIN
			print '3'
			SELECT @stockId = StockId,@itemCode = ItemCode,@monthVal = MonthVal  FROM @tempTable WHERE Id = @counter
			IF EXISTS (SELECT 1 FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id = @stockId AND Fld_KPMG_Status =  3)
			BEGIN
				SELECT @itemCount =  COUNT(1) FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Stock_Id = @stockId AND Fld_KPMG_Status =  3
				
				IF EXISTS(SELECT 1 FROM @finalTable WHERE ItemCode = @itemCode AND MonthVal = @monthVal)
				BEGIN
					print '3'
					UPDATE @finalTable SET TotalAmount = (TotalAmount + @itemCount) WHERE ItemCode = @itemCode AND MonthVal = @monthVal
				END
				ELSE
				BEGIN
					print @itemCode
					SELECT @courseName = S_Course_Code FROM T_Course_Master WHERE I_Course_ID = 
					(SELECT Fld_KPMG_CourseId FROm Tbl_KPMG_SM_List WHERE Fld_KPMG_ItemCode = @itemCode )
					print '44'
					INSERT INTO @finalTable (StockId , ItemCode ,CourseName , MonthVal , TotalAmount)
					SELECT @stockId,@itemCode,@courseName,@monthVal,@itemCount
					print '5'
				END
				
			END
						
			SET @counter = @counter + 1
			SET @itemCount = 0
		END
	END
	
	SELECT StockId , ItemCode ,CourseName , MonthVal , TotalAmount FROM  @finalTable 
	
	
END

