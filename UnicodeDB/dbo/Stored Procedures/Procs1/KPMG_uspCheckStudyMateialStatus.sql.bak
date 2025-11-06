
CREATE PROCEDURE [dbo].[KPMG_uspCheckStudyMateialStatus]


@MaterialBarCode nvarchar(255),
@STUDENTID INT,
@StudyMaterialName nvarchar(255),
@MATERIAL_STATUS nvarchar(255) output

AS
BEGIN TRY 

IF EXISTS (SELECT 1 FROM Tbl_KPMG_StockDetails	WHERE Tbl_KPMG_StockDetails.Fld_KPMG_Barcode=@MaterialBarCode )	
BEGIN
	SET @MATERIAL_STATUS='SUCCESS'
END
ELSE
BEGIN
	SET @MATERIAL_STATUS='The Material is not found in the repository'
END
IF EXISTS (SELECT 1 FROM Tbl_KPMG_StockDetails	WHERE Tbl_KPMG_StockDetails.Fld_KPMG_Barcode=@MaterialBarCode AND Fld_KPMG_Status =3)	
BEGIN
	SET @MATERIAL_STATUS='SUCCESS'
END
ELSE
BEGIN
	SET @MATERIAL_STATUS='The Material is not Ok State in Repository'
END

IF(@MATERIAL_STATUS='SUCCESS')
BEGIN
PRINT 222
PRINT @StudyMaterialName
	IF EXISTS (SELECT 1 FROM Tbl_KPMG_StockMaster A INNER JOIN Tbl_KPMG_StockDetails B ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id 
	INNER JOIN Tbl_KPMG_SM_List C ON A.Fld_KPMG_ItemCode=C.Fld_KPMG_ItemCode AND RTRIM(LTRIM(C.Fld_KPMG_ItemCode_Description)) =RTRIM(LTRIM(@StudyMaterialName)) 
	AND B.Fld_KPMG_Barcode=@MaterialBarCode)
	BEGIN

		SET @MATERIAL_STATUS='SUCCESS'
	END
	ELSE
	BEGIN
	--SET @MATERIAL_STATUS='SUCCESS'
		  SET @MATERIAL_STATUS='Study Material is not for '+@StudyMaterialName
	END
END	

PRINT @MATERIAL_STATUS+'111'
DECLARE @CENTER_ID INT
SELECT @CENTER_ID= I_Centre_Id FROM T_Invoice_Parent WHERE I_Student_Detail_ID=@STUDENTID
IF(@MATERIAL_STATUS='SUCCESS')
BEGIN
	IF EXISTS (SELECT 1 FROM Tbl_KPMG_StockMaster A INNER JOIN Tbl_KPMG_StockDetails B ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id AND B.Fld_KPMG_Barcode=@MaterialBarCode AND A.Fld_KPMG_Branch_Id=@CENTER_ID)
	BEGIN

		SET @MATERIAL_STATUS='SUCCESS'
	END
	ELSE
	BEGIN
		  SET @MATERIAL_STATUS='Study Material and student belong to different branch.'
	END
END		

PRINT @MATERIAL_STATUS+'222'


IF(@MATERIAL_STATUS='SUCCESS')
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Tbl_KPMG_SM_Issue A INNER JOIN Tbl_KPMG_StockDetails B ON A.Fld_KPMG_Barcode=B.Fld_KPMG_Barcode AND a.Fld_KPMG_StudentId=@STUDENTID AND B.Fld_KPMG_Barcode=@MaterialBarCode )
	BEGIN

		SET @MATERIAL_STATUS='SUCCESS'
	END
	ELSE
	BEGIN
		  SET @MATERIAL_STATUS='Study Material has already been issued.'
	END
END	
PRINT @MATERIAL_STATUS+'333'

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
