
CREATE PROCEDURE [dbo].[KPMG_GetitemWiseQuantity]
(
	@MoveOrderId INT,
	@Context NVARCHAR(max)
)
AS   
	BEGIN Try	
		IF (@Context='LOAD')
		BEGIN	
			print '111'		
			SELECT DISTINCT Fld_KPMG_Itemcode AS ItemCode,Fld_KPMG_Amount AS Amount FROM Tbl_KPMG_LoadAmount A
			INNER JOIN Tbl_KPMG_MoMaster B ON A.Fld_KPMG_Mo_Id=B.Fld_KPMG_Mo_Id AND B.Fld_KPMG_Status = 0
			AND A.Fld_KPMG_Mo_Id  = @MoveOrderId
			
		END
		ELSE IF (ISNULL(@Context,'') = 'LOAD REV_MO')
		BEGIN
			select Fld_KPMG_ItemCode AS ItemCode,COUNT(1) AS Amount from Tbl_KPMG_ReverseMOItems	
			where ISNULL(Fld_KPMG_IsLoadedFromBranch,'N') = 'N'	AND Fld_KPMG_MoId = @MoveOrderId	
			group by Fld_KPMG_ItemCode
			
			 --having  where Fld_KPMG_MoId = 238
			
			--SELECT DISTINCT Fld_KPMG_Itemcode AS ItemCode,Fld_KPMG_Amount AS Amount FROM Tbl_KPMG_ReverseMOItems A
			--INNER JOIN Tbl_KPMG_MoMaster B ON A.Fld_KPMG_MoId=B.Fld_KPMG_Mo_Id AND B.Fld_KPMG_Status=0
			--AND B.Fld_KPMG_Mo_Id=@MoveOrderId
			
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


