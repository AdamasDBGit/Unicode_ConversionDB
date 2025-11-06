
CREATE PROCEDURE [dbo].[uspAddEditDeleteExaminationList]
@CONTEXT NVARCHAR(max),
@EXAM_ID INT,
@EXAM_NAME NVARCHAR(max),
@FROM_DATE DATETIME,
@TO_DATE DATETIME
AS
--select * from Tbl_KPMG_SpecialExamination
BEGIN TRY 
IF @CONTEXT='ADD'
BEGIN
	IF EXISTS(SELECT 1 FROM Tbl_KPMG_SpecialExamination WHERE Fld_KPMG_ExaminationName = @EXAM_NAME)
	BEGIN
		DELETE FROM Tbl_KPMG_SpecialExamination WHERE Fld_KPMG_ExaminationName = @EXAM_NAME
	END
	
	INSERT INTO Tbl_KPMG_SpecialExamination(Fld_KPMG_ExaminationName,Fld_KPMG_ValidFrom,Fld_KPMG_ValidTo)
	VALUES(@EXAM_NAME,@FROM_DATE,@TO_DATE)
END

ELSE IF @CONTEXT='EDIT'
BEGIN
	UPDATE Tbl_KPMG_SpecialExamination SET Fld_KPMG_ExaminationName=@EXAM_NAME,Fld_KPMG_ValidFrom=@FROM_DATE,Fld_KPMG_ValidTo=@TO_DATE WHERE Fld_KPMG_ExaminationId=@EXAM_ID
END
ELSE
BEGIN
		DELETE FROM Tbl_KPMG_SpecialExamination WHERE Fld_KPMG_ExaminationId=@EXAM_ID
END


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


