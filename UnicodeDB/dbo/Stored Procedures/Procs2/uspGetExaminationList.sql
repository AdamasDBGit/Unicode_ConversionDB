
CREATE PROCEDURE [dbo].[uspGetExaminationList]
AS
BEGIN TRY 
DECLARE @CURR_DATE DATETIME=GETDATE()
SELECT Fld_KPMG_ExaminationId AS ExaminationId,Fld_KPMG_ExaminationName AS ExaminationName,Fld_KPMG_ValidTo AS ValidTo ,Fld_KPMG_ValidFrom  AS ValidFrom FROM Tbl_KPMG_SpecialExamination 
--WHERE Fld_KPMG_ValidTo >= @CURR_DATE AND @CURR_DATE >= Fld_KPMG_ValidFrom
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
