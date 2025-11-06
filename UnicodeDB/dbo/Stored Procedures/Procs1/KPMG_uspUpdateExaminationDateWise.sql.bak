
CREATE PROCEDURE [dbo].[KPMG_uspUpdateExaminationDateWise]



AS
BEGIN TRY 

UPDATE A SET A.IsRowValid='N' FROM  Tbl_KPMG_StudentExaminationDetails A 
INNER JOIN Tbl_KPMG_SpecialExamination B  ON A.Fld_KPMG_ExaminationId=B.Fld_KPMG_ExaminationId
AND B.Fld_KPMG_ValidTo >GETDATE()
	



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
