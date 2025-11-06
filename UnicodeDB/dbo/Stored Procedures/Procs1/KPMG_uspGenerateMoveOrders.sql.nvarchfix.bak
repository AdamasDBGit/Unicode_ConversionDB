
CREATE PROCEDURE [dbo].[KPMG_uspGenerateMoveOrders] 
	
AS
BEGIN Try	    
		DECLARE @idMax INT
		DECLARE @idMaxLast INT
		DECLARE @idMap INT
		DECLARE @idmaster INT

		-- Select @idMap = MAX(Fld_KPMG_MoStudentMapId) from Tbl_KPMG_MoStudentMap
		Select @idMap = 1;
		Create Table #MoQty ([Fld_Id] [int] IDENTITY(1,1) NOT NULL primary key,[Centre_Id] [int] NULL,[Course_ID] [int] NULL,[ItemCode] [int] NULL,[Quantity] [int] NULL)
		Insert into #MoQty (Centre_Id,Course_ID,ItemCode,Quantity)Select I_Centre_Id,I_Course_ID,Fld_KPMG_ItemCode,COUNT(Fld_KPMG_ItemCode) AS Quantity
		FROM Vu_KPMG_MoItems where Vu_KPMG_MoItems.I_Installment_No <> '1' 
		Group BY Fld_KPMG_ItemCode,I_Course_ID,I_Centre_Id
		-- Insert into #MoQty (Centre_Id,Course_ID,ItemCode,Quantity)Select I_Centre_Id,I_Course_ID,Fld_KPMG_ItemCode,dbo.Func_KPMG_MO_QtyByItem(Fld_KPMG_ItemCode,I_Course_ID,I_Centre_Id) AS Quantity FROM Vu_KPMG_MoItems where Vu_KPMG_MoItems.I_Installment_No = '1' Group BY Fld_KPMG_ItemCode,I_Course_ID,I_Centre_Id
				
		Insert into #MoQty (Centre_Id,Course_ID,ItemCode,Quantity)		
		SELECT a.Fld_KPMG_Branch_Id,b.Fld_KPMG_CourseId,b.Fld_KPMG_ItemCode,dbo.Func_KPMG_MO_QtyByItem(b.Fld_KPMG_ItemCode,b.Fld_KPMG_CourseId,a.Fld_KPMG_Branch_Id) AS Quantity
		FROM Tbl_KPMG_Projection a inner join Tbl_KPMG_SM_List b 
		ON a.Fld_KPMG_Course_Id=b.Fld_KPMG_CourseId AND b.Fld_KPMG_I_Installment_No = '1'
						
		--Select I_Centre_Id,I_Course_ID,Fld_KPMG_ItemCode,dbo.Func_KPMG_MO_QtyByItem(Fld_KPMG_ItemCode,I_Course_ID,I_Centre_Id) AS Quantity FROM Tbl_KPMG_Projection Group BY Fld_KPMG_ItemCode,I_Course_ID,I_Centre_Id
				 
		Insert into dbo.Tbl_KPMG_MoStudentMap(Fld_KPMG_I_Student_Detail_ID,Fld_KPMG_I_Installment_No)
		Select I_Student_Detail_ID,I_Installment_No from Vu_KPMG_MoItems
		
		-- Select @idMaxLast = MAX(Fld_KPMG_MoStudentMapId) from Tbl_KPMG_MoStudentMap
		Select @idMaxLast = MAX(Fld_Id)from #MoQty		

		WHILE @idMap <= @idMaxLast
			BEGIN
				-- Insert into Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id)values('2')
		
				Insert into Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id)Select Centre_Id from #MoQty where Fld_Id = @idMap
				Select @idmaster = @@IDENTITY
				
				Insert into Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)Select @idmaster,ItemCode,Quantity from #MoQty where #MoQty.Fld_Id = @idMap
		 
				-- SELECT @idMaxLast = @idMaxLast - 1	
				SELECT @idMap = @idMap + 1
			END

		Drop table #MoQty

END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg Nnvarchar(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
