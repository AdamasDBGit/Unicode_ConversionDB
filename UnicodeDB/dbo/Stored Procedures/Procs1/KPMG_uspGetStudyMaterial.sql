
CREATE PROCEDURE [dbo].[KPMG_uspGetStudyMaterial]

@MaterialBarCodeNo nvarchar(255)
--,@ItemCode nvarchar(255) 

AS
BEGIN TRY  



DECLARE @TEMP_TABLE TABLE (ItemCode NVARCHAR(255) ,BarCode NVARCHAR(255),Name NVARCHAR(MAX),CourseName NVARCHAR(255))

 

INSERT INTO @TEMP_TABLE (ItemCode,BarCode)
SELECT B.Fld_KPMG_ItemCode, Fld_KPMG_Barcode

FROM  Tbl_KPMG_StockDetails A 

INNER JOIN Tbl_KPMG_StockMaster B ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id  

AND A.Fld_KPMG_Barcode=@MaterialBarCodeNo

UPDATE A SET Name= CASE WHEN  B.Fld_KPMG_ItemType =0 THEN 'Study Material '+CONVERT(NVARCHAR(10), B.Fld_KPMG_I_Installment_No)
 ELSE  
 CASE WHEN  B.Fld_KPMG_ItemType =1 THEN
 'Homework Material'
 ELSE 'Special Study Material' END
 END,
 CourseName=C.S_Course_Name

FROM 
@TEMP_TABLE A INNER JOIN Tbl_KPMG_SM_List B ON A.ItemCode=B.Fld_KPMG_ItemCode 
inner join T_Course_Master C ON B.Fld_KPMG_CourseId=C.I_Course_ID

select * from @TEMP_TABLE 
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
