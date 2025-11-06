CREATE PROCEDURE [ECOMMERCE].[uspSaveProductExamCategoryMappings]
(
	@ProductID INT,
	@ExamCategoryList VARCHAR(MAX),
	@CreatedBy VARCHAR(MAX)='rice-group-admin'
)
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION

			delete from ECOMMERCE.T_Product_ExamCategory_Map where ProductID=@ProductID

			insert into ECOMMERCE.T_Product_ExamCategory_Map
			select @ProductID,CAST(FSR.Val as INT),1 from fnString2Rows(@ExamCategoryList,',') as FSR

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
	--Error occurred:  
		ROLLBACK TRANSACTION
		DECLARE @ErrMsg NVARCHAR(4000) ,
			@ErrSeverity INT
		SELECT  @ErrMsg = ERROR_MESSAGE() ,
				@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
