
CREATE PROCEDURE [dbo].[KPMG_uspMO_LoadAllocation] 
	
AS
BEGIN Try
			
	DECLARE @Qty INT
DECLARE @ItemCode VARCHAR(255)
DECLARE @idMap INT
DECLARE @idMaxLast INT
DECLARE @ItmAmount_TEMP TABLE([Amount_Id] [int] IDENTITY(1,1) NOT NULL,ItemCode VARCHAR(255),Qunty INT, Calc_Date DateTime, ItemStatus INT)

Insert Into @ItmAmount_TEMP(ItemCode,Qunty,Calc_Date,ItemStatus)
Select MvOd.Fld_KPMG_Itemcode,MvOd.Quantity-Qty.Quantity as AllotQty,GETDATE() as InsertDate, 0 as Itm_Status from (
Select Mi.Fld_KPMG_Itemcode,sum(Mi.Fld_KPMG_Quantity) AS Quantity from dbo.Tbl_KPMG_MoMaster Mm INNER JOIN dbo.Tbl_KPMG_MoItems Mi 
ON Mm.Fld_KPMG_Mo_Id = Mi.Fld_KPMG_Mo_Id Group By Mi.Fld_KPMG_Itemcode,Mm.Fld_KPMG_Status Having Mm.Fld_KPMG_Status = '0')MvOd INNER JOIN 

(Select SM.Fld_KPMG_ItemCode,COUNT(Fld_KPMG_StockDet_Id) AS Quantity from dbo.Tbl_KPMG_StockDetails Dtls 
INNER JOIN dbo.Tbl_KPMG_StockMaster SM ON SM.Fld_KPMG_Stock_Id = Dtls.Fld_KPMG_Stock_Id Group BY SM.Fld_KPMG_ItemCode)Qty ON MvOd.Fld_KPMG_Itemcode = Qty.Fld_KPMG_ItemCode 
-- AND MvOd.Quantity-Qty.Quantity < 0

Set @idMap = 0
Select @idMaxLast = MAX(Amount_Id) from @ItmAmount_TEMP

WHILE @idMap <=  @idMaxLast
	BEGIN
		-- Select @Qty = Qunty from @ItmAmount_TEMP where Amount_Id = @idMap
		Select @ItemCode = ItemCode from @ItmAmount_TEMP where Amount_Id = @idMap
		
		--if(@Qty < 0)
		--	Begin
		--		Set @Qty = @Qty -1
		--	End
		
		Exec KPMG_uspInsertLoadAllocation @ItemCode
		
		SET @idMap = @idMap + 1
	END

END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
