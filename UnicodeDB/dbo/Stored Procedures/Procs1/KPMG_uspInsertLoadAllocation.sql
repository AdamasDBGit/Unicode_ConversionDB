
CREATE PROCEDURE [dbo].[KPMG_uspInsertLoadAllocation]
(
	@Item_Code NVARCHAR(max)
)
AS   
BEGIN Try	    
DECLARE @Ratio_TEMP TABLE(Ratio_Id [int] IDENTITY(1,1) NOT NULL,MoveOrderNo INT, BranchId INT, ItemCode NVARCHAR(max), MoQty INT, RtQty INT)
DECLARE @Fl_TEMP TABLE(Ratio_Id [int] IDENTITY(1,1) NOT NULL,MoveOrderNo INT, BranchId INT, ItemCode NVARCHAR(max), MoQty INT)
DECLARE @TotMoItem_Qty INT
DECLARE @CWH_Qty INT
DECLARE @CountRo INT
DECLARE @BranchId INT
DECLARE @MoId INT
DECLARE @R_Qty INT
DECLARE @FstId INT
DECLARE @LstId INT

Select @TotMoItem_Qty = sum(Fld_KPMG_Quantity) from Tbl_KPMG_MoItems Mi INNER JOIN Tbl_KPMG_MoMaster Mm ON Mm.Fld_KPMG_Mo_Id = Mi.Fld_KPMG_Mo_Id Group By Mi.Fld_KPMG_Itemcode,Mm.Fld_KPMG_Status Having Mm.Fld_KPMG_Status = '0' AND Mi.Fld_KPMG_Itemcode = @Item_Code
Select @CWH_Qty = Count(SD.Fld_KPMG_Barcode) from dbo.Tbl_KPMG_StockDetails SD INNER JOIN dbo.Tbl_KPMG_StockMaster SM ON SM.Fld_KPMG_Stock_Id = SD.Fld_KPMG_Stock_Id 

																	where SM.Fld_KPMG_ItemCode = @Item_Code AND SM.Fld_KPMG_Branch_Id = 0
																	
print 	@TotMoItem_Qty

print 	@CWH_Qty
If (@CWH_Qty<@TotMoItem_Qty)
	BEGIN
	print 1
		Insert into @Ratio_TEMP
		Select Mm.Fld_KPMG_Mo_Id as MoId, Mm.Fld_KPMG_Branch_Id as CentreId,
			   Mi.Fld_KPMG_Itemcode as Itemcode,
			   Mi.Fld_KPMG_Quantity AS Quantity,
			  Floor((Mi.Fld_KPMG_Quantity/@TotMoItem_Qty)*@CWH_Qty) As rtPart from dbo.Tbl_KPMG_MoMaster Mm INNER JOIN dbo.Tbl_KPMG_MoItems Mi ON Mm.Fld_KPMG_Mo_Id = Mi.Fld_KPMG_Mo_Id 
					Group By Mi.Fld_KPMG_Itemcode,Mm.Fld_KPMG_Status,Mm.Fld_KPMG_Mo_Id,Mm.Fld_KPMG_Branch_Id,Mi.Fld_KPMG_Quantity 
					Having Mm.Fld_KPMG_Status = '0' AND Mi.Fld_KPMG_Itemcode = @Item_Code
		
		Set @FstId = 0
		Select @LstId = MAX(Ratio_Id) from @Ratio_TEMP
		
		WHILE @FstId <=  @LstId
			BEGIN	
			print 2	
			select * from @Ratio_TEMP		
				Select @BranchId = BranchId from @Ratio_TEMP where Ratio_Id = @FstId	
				Select @MoId = MoveOrderNo from @Ratio_TEMP where Ratio_Id = @FstId				
				Select @Item_Code = ItemCode from @Ratio_TEMP where Ratio_Id = @FstId
				Select @R_Qty = RtQty from @Ratio_TEMP where Ratio_Id = @FstId
				print @R_Qty
				print 2.1
				Select @CountRo = 0
				-- If the row is already existing
				Select @CountRo = Amount_Id from Tbl_KPMG_LoadAmount where Fld_KPMG_Branch_Id = @BranchId AND Fld_KPMG_Mo_Id = @MoId AND Fld_KPMG_Itemcode = @Item_Code							
				if(@CountRo < 1)
					Begin	
					print 3				
						Insert into Tbl_KPMG_LoadAmount(Fld_KPMG_Branch_Id,Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)
						Select BranchId,ItemCode,RtQty,MoveOrderNo from @Ratio_TEMP
						where Ratio_Id = @FstId
					End
				Else
					Begin	
					print 4					
						Update Tbl_KPMG_LoadAmount set Fld_KPMG_Amount = @R_Qty  where Fld_KPMG_Branch_Id = @BranchId AND Fld_KPMG_Mo_Id = @MoId AND Fld_KPMG_Itemcode = @Item_Code
					End
				
				SET @FstId = @FstId + 1
			END					
	END	
ELSE
	BEGIN	
		Insert into @Fl_TEMP
		Select Mm.Fld_KPMG_Mo_Id as MoId,Mm.Fld_KPMG_Branch_Id as CentreId,Mi.Fld_KPMG_Itemcode as Itemcode,
			   Mi.Fld_KPMG_Quantity AS Quantity from dbo.Tbl_KPMG_MoMaster Mm INNER JOIN dbo.Tbl_KPMG_MoItems Mi ON Mm.Fld_KPMG_Mo_Id = Mi.Fld_KPMG_Mo_Id 
					AND Mm.Fld_KPMG_Status = '0' AND Mi.Fld_KPMG_Itemcode = @Item_Code
		
		Set @FstId = 0
		Select @LstId = MAX(Ratio_Id) from @Fl_TEMP
		
		WHILE @FstId <=  @LstId
			BEGIN				
				Select @BranchId = BranchId from @Fl_TEMP where Ratio_Id = @FstId	-- BranchId may not be required as MOveOrder is unique		
				Select @MoId = MoveOrderNo from @Fl_TEMP where Ratio_Id = @FstId				
				Select @Item_Code = ItemCode from @Fl_TEMP where Ratio_Id = @FstId
				Select @R_Qty = MoQty from @Fl_TEMP where Ratio_Id = @FstId
				
				Select @CountRo = 0
				-- If the row is already existing
				Select @CountRo = Amount_Id from Tbl_KPMG_LoadAmount where Fld_KPMG_Branch_Id = @BranchId AND Fld_KPMG_Mo_Id = @MoId AND Fld_KPMG_Itemcode = @Item_Code							
				if(@CountRo < 1) -- If the record to be inserted for the 1st time
					Begin
					-- (Ratio_Id [int] IDENTITY(1,1) NOT NULL,MoveOrderNo INT, BranchId INT, ItemCode NVARCHAR(255), MoQty INT, RtQty INT)
						Insert into Tbl_KPMG_LoadAmount(Fld_KPMG_Branch_Id,Fld_KPMG_Itemcode,Fld_KPMG_Amount,Fld_KPMG_Mo_Id)
						Select BranchId,ItemCode,MoQty,MoveOrderNo from @Fl_TEMP
						where Ratio_Id = @FstId
					End
				Else  -- If the record was inserted earlier
					Begin						
						Update Tbl_KPMG_LoadAmount set Fld_KPMG_Amount = @R_Qty  where Fld_KPMG_Branch_Id = @BranchId AND Fld_KPMG_Mo_Id = @MoId AND Fld_KPMG_Itemcode = @Item_Code
					End
				
				SET @FstId = @FstId + 1
			END					
	END	
END TRY

BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH


