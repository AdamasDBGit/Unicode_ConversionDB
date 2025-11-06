
CREATE PROCEDURE [dbo].[uspGetStudentWiseExaminationList]
@StudentDetailId NVARCHAR(500)
AS
BEGIN TRY 
DECLARE @CURR_DATE DATETIME=GETDATE()
DECLARE @StudentWiseExamList table (ExamName nvarchar(255),IsApplied char(1), Barcode NVARCHAR(500)) 

PRINT @CURR_DATE


SELECT Fld_KPMG_ExaminationName AS ExamName,
		A.Fld_KPMG_ExaminationId as ExamId,
		A.Fld_KPMG_ValidFrom AS ValidFrom,
		A.Fld_KPMG_ValidTo AS ValidTo,
		B.Fld_KPMG_StudentDetailId AS StudentDetailId,
		CASE WHEN B.Fld_KPMG_StudentDetailId IS NULL THEN 'N'ELSE 'Y' END AS IsApplied,
		B.Fld_KPMG_MaterialBarCode AS MaterialBarCode,
		B.Fld_KPMG_IsMoveOrderCreated AS IsMoveOrderCreated
		 FROM Tbl_KPMG_SpecialExamination A 
		LEFT OUTER JOIN Tbl_KPMG_StudentExaminationDetails B
		ON A.Fld_KPMG_ExaminationId=B.Fld_KPMG_ExaminationId
		AND B.IsRowValid='Y'
		AND B.Fld_KPMG_StudentDetailId=@StudentDetailId
		WHERE GETDATE()  BETWEEN A.Fld_KPMG_ValidFrom AND  A.Fld_KPMG_ValidTo



END TRY
BEGIN CATCH 
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
