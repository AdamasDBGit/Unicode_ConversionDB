
CREATE PROCEDURE [dbo].[usp_KPMG_ValidateHomeWork]

@MaterialBarCode nnvarchar(max),
@StudentId INT


AS
BEGIN TRY 
 DECLARE @Status Nnvarchar(max)=''
 DECLARE @IssuedHomeWork  Nnvarchar(max)
 DECLARE @ParentCode  Nnvarchar(max)
 DECLARE @IssueParentCode  Nnvarchar(max)

IF EXISTS(SELECT 1 FROM Tbl_KPMG_SM_Issue A INNER JOIN Tbl_KPMG_SM_List B ON A.Fld_KPMG_ItemCode=B.Fld_KPMG_ItemCode AND B.Fld_KPMG_ItemType=2 AND A.Fld_KPMG_StudentId=@StudentId)

BEGIN
	SELECT @IssuedHomeWork= A.Fld_KPMG_Barcode FROM Tbl_KPMG_SM_Issue A INNER JOIN Tbl_KPMG_SM_List B ON A.Fld_KPMG_ItemCode=B.Fld_KPMG_ItemCode AND B.Fld_KPMG_ItemType=2 AND A.Fld_KPMG_StudentId=@StudentId AND A.Fld_KPMG_Context='ISSUE'
	SELECT @ParentCode=SUBSTRING(@MaterialBarCode,CHARINDEX('/',@MaterialBarCode)+1,LEN(@MaterialBarCode))
	SELECT @IssueParentCode=SUBSTRING(@IssuedHomeWork,CHARINDEX('/',@IssuedHomeWork)+1,LEN(@IssuedHomeWork))
	IF(@ParentCode=@IssueParentCode)
	BEGIN
		SET @Status='SUCCESS'

	END
	ELSE
	BEGIN
		SET @Status='The Home Work Material is not issued to this Student.'
	END
END
ELSE
BEGIN
	SET @Status='No Homework issued for this student'
END
SELECT @Status AS Status
  
END TRY

 

BEGIN CATCH
	
	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
