
CREATE PROCEDURE [dbo].[KPMG_uspGetPrinterRejectedMaterials]
@ItemCode NVARCHAR(MAX)
AS
BEGIN Try

	IF ISNULL(@ItemCode,'') <> ''
	BEGIN
		SELECT dtl.Fld_KPMG_StockDet_Id as SLNo ,mst.Fld_KPMG_ItemCode as ItemCode,dtl.Fld_KPMG_Barcode as BarCode,
		dtl.Fld_KPMG_Status as Stats,crs.S_Course_Desc as CourseName, 0 as IsIssued
		FROM Tbl_KPMG_StockDetails dtl 
		INNER JOIN Tbl_KPMG_StockMaster mst on  mst.Fld_KPMG_Stock_Id = dtl.Fld_KPMG_Stock_Id		
		INNER JOIN Tbl_KPMG_SM_List smLst ON mst.Fld_KPMG_ItemCode= smLst.Fld_KPMG_ItemCode 
		INNER JOIN T_Course_Master crs ON smLst.Fld_KPMG_CourseId= crs.I_Course_ID 
		AND mst.Fld_KPMG_FromBranch_Id=0 and mst.Fld_KPMG_Branch_Id=0 AND mst.Fld_KPMG_ItemCode = @ItemCode
		AND dtl.Fld_KPMG_Status=5   
		ORDER BY dtl.Fld_KPMG_StockDet_Id
	END
	ELSE
	BEGIN
		
		
		SELECT dtl.Fld_KPMG_StockDet_Id as SLNo ,mst.Fld_KPMG_ItemCode as ItemCode,dtl.Fld_KPMG_Barcode as BarCode,
		dtl.Fld_KPMG_Status as Stats,crs.S_Course_Desc as CourseName, 0 as IsIssued
		FROM Tbl_KPMG_StockDetails dtl 
		INNER JOIN Tbl_KPMG_StockMaster mst on  mst.Fld_KPMG_Stock_Id = dtl.Fld_KPMG_Stock_Id		
		INNER JOIN Tbl_KPMG_SM_List smLst ON mst.Fld_KPMG_ItemCode= smLst.Fld_KPMG_ItemCode 
		INNER JOIN T_Course_Master crs ON smLst.Fld_KPMG_CourseId= crs.I_Course_ID 
		AND mst.Fld_KPMG_FromBranch_Id=0 and mst.Fld_KPMG_Branch_Id=0
		AND dtl.Fld_KPMG_Status=5  ORDER BY dtl.Fld_KPMG_StockDet_Id
		--and b.Fld_KPMG_ItemCode=@ItemCode ORDER BY SLNo
		
		
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

