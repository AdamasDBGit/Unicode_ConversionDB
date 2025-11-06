
CREATE PROCEDURE [dbo].[usp_KPMG_ValidateHomeWork]

@MaterialBarCode nvarchar(255),
@StudentId INT


AS
BEGIN TRY 
 DECLARE @Status NVARCHAR(255)=''
 DECLARE @IssuedHomeWork  NVARCHAR(255)
 DECLARE @ParentCode  NVARCHAR(255)
 DECLARE @IssueParentCode  NVARCHAR(255)

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
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
