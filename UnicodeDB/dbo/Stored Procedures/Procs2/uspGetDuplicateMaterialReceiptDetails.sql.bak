
CREATE PROCEDURE [dbo].[uspGetDuplicateMaterialReceiptDetails]

@IssuedStudyMaterialBarCode NVARCHAR(500),

@StudentDetailId NVARCHAR(500),

@Context NVARCHAR(500)
AS
BEGIN TRY 
DECLARE @ReceiptDate  DATETIME
DECLARE @RceiptId NVARCHAR(255)
DECLARE @ReceiptNoInd INT
DECLARE @ItemCode NVARCHAR(255)
DECLARE @ErrorMessage NVARCHAR(max)
DECLARE @ItemDescription NVARCHAR(MAX)

DECLARE @TEMP_RECEIPT_DETAIL TABLE (ReceiptId NVARCHAR(255),ItemCode NVARCHAR(255),ReIssuedStudyMaterialBarCode NVARCHAR(500),Price DECIMAL(10,2),Tax DECIMAL(10,2),Total DECIMAL(10,2),ItemDescription NVARCHAR(255) )
IF @Context='ADD'
BEGIN

		SELECT @RceiptId= 'RICE - '+CONVERT(varchar,DATEPART(yy,getdate()))+
				CONVERT(varchar,datepart(mm,getdate())) +
				CONVERT(varchar,datepart(dd,getdate()))+
				CONVERT(varchar,datepart(HH,getdate()))+
				CONVERT(varchar,datepart(MI,getdate()))+
				CONVERT(varchar,datepart(SS,getdate()))+
				CONVERT(varchar,datepart(MS,getdate()))
		IF EXISTS(SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_StudentId=(SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID=@StudentDetailId) AND Fld_KPMG_Barcode=@IssuedStudyMaterialBarCode)
		BEGIN
			SELECT @ItemCode= Fld_KPMG_ItemCode FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_StudentId=(SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID=@StudentDetailId) AND Fld_KPMG_Barcode=@IssuedStudyMaterialBarCode
			SELECT @ItemDescription= Fld_KPMG_ItemCode_Description FROM Tbl_KPMG_SM_List WHERE Fld_KPMG_ItemCode=@ItemCode
			INSERT INTO @TEMP_RECEIPT_DETAIL(ReceiptId,ItemCode,Price,Tax,Total,ItemDescription) 
			SELECT TOP 1 @RceiptId,@ItemCode,Fld_KPMG_Item_Price,Fld_KPMG_Tax,Fld_KPMG_Item_Price+Fld_KPMG_Tax,@ItemDescription FROM Tbl_KPMG_SM_List WHERE Fld_KPMG_ItemCode=@ItemCode			
			
		END

		ELSE
		BEGIN
			SET @ErrorMessage='Error Occured.No Record found for already issued material.'
		END
		
END

ELSE
BEGIN
		SELECT @ItemCode= Fld_KPMG_ItemCode FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_StudentId=(SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID=@StudentDetailId) AND Fld_KPMG_Barcode=@IssuedStudyMaterialBarCode
		SELECT @ItemDescription= Fld_KPMG_ItemCode_Description FROM Tbl_KPMG_SM_List WHERE Fld_KPMG_ItemCode=@ItemCode
		INSERT INTO @TEMP_RECEIPT_DETAIL(ReceiptId,ItemCode,ReIssuedStudyMaterialBarCode,Price,Tax,Total,ItemDescription) 
		SELECT Fld_KPMG_ReceiptNo,@ItemCode,Fld_Kpmg_ReIssuedBarCode,Fld_KPMG_Price,Fld_KPMG_Tax,Fld_KPMG_Total,@ItemDescription FROM Tbl_KPMG_DuplicateMaterialIssue 	
		WHERE Fld_Kpmg_ReIssuedBarCode=@IssuedStudyMaterialBarCode  AND Fld_KPMG_StudentBarCode=@StudentDetailId
END

SELECT * FROM @TEMP_RECEIPT_DETAIL

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
