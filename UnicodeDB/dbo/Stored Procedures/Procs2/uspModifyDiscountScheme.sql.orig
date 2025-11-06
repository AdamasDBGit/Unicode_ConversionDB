CREATE PROCEDURE [dbo].[uspModifyDiscountScheme] 
(
	@iDiscountSchemeID int,
	@sDiscountSchemeDetails text,
	@sDiscountSchemeName varchar(50),
	@dValidFrom datetime,
	@dValidTo datetime,
    @sModifiedBy varchar(20),
	@dModifiedOn datetime,
    @iFlag int
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @iDocHandle INT
	CREATE TABLE #tempDiscountSchemeAdd
	(
		I_Discount_Scheme_ID int,
		I_CourseList_ID	int,				
		N_Range_From Numeric(18,0),
		N_Range_To Numeric(18,0),
		N_Discount_Rate Numeric(18,0)
	)
  
	BEGIN TRANSACTION
    IF @iFlag = 1
	BEGIN
		DECLARE @iSchemeID int
		INSERT INTO dbo.T_Discount_Scheme_Master
		(S_Discount_Scheme_Name,
		 Dt_Valid_From,
		 Dt_Valid_To,
		 I_Status, 
		 S_Crtd_By, 
		 Dt_Crtd_On)
		VALUES
		( @sDiscountSchemeName,
		  @dValidFrom,
		  @dValidTo, 
          1, 
		  @sModifiedBy, 
		  @dModifiedOn)

		SELECT @iSchemeID=@@IDENTITY
		EXEC sp_xml_preparedocument @iDocHandle output,@sDiscountSchemeDetails

		INSERT INTO #tempDiscountSchemeAdd 
		(I_CourseList_ID,
		 N_Range_From,
		 N_Range_To,
		 N_Discount_Rate)
			SELECT * FROM
			OPENXML(@iDocHandle, '/DiscountSchemeDetails/DiscountSchemeDetailsList', 2)
			WITH (I_CourseList_ID int, 
				  N_Range_From Numeric(20),
				  N_Range_To Numeric(20),
				  N_Discount_Rate Numeric(20))
				
		UPDATE #tempDiscountSchemeAdd SET I_Discount_Scheme_ID=@iSchemeID

		INSERT INTO  dbo.T_Discount_Details
		(I_Discount_Scheme_ID, 
		 I_CourseList_ID,
		 N_Range_From,
		 N_Range_To,
		 N_Discount_Rate) 			
		 SELECT *
		 FROM #tempDiscountSchemeAdd		
	
	END
	ELSE IF @iFlag = 2
	BEGIN
		--DECLARE @dSchemeID int  
			
		UPDATE dbo.T_Discount_Scheme_Master
		SET S_Discount_Scheme_Name = @sDiscountSchemeName,
			Dt_Valid_From = @dValidFrom,
			Dt_Valid_To = @dValidTo,
			S_Upd_By = @sModifiedBy,
			Dt_Upd_On = @dModifiedOn
			where I_Discount_Scheme_ID = @iDiscountSchemeID

			EXEC sp_xml_preparedocument @iDocHandle output,@sDiscountSchemeDetails

			INSERT INTO #tempDiscountSchemeAdd
			(I_CourseList_ID,
			 N_Range_From,
			 N_Range_To,
			 N_Discount_Rate)
				SELECT * FROM
				OPENXML(@iDocHandle, '/DiscountSchemeDetails/DiscountSchemeDetailsList',2)
				WITH (I_CourseList_ID int, 
					  N_Range_From Numeric(20),
					  N_Range_To Numeric(20),
					  N_Discount_Rate Numeric(20))

			UPDATE #tempDiscountSchemeAdd 
			SET I_Discount_Scheme_ID=@iDiscountSchemeID

			DELETE FROM dbo.T_Discount_Details 
			WHERE I_Discount_Scheme_ID=@iDiscountSchemeID
							
			INSERT INTO dbo.T_Discount_Details 
			(I_Discount_Scheme_ID, 
			 I_CourseList_ID,
			 N_Range_From,
			 N_Range_To,
			 N_Discount_Rate)  			
				SELECT *
				FROM #tempDiscountSchemeAdd
	END
	ELSE IF @iFlag = 3
	
BEGIN
		UPDATE dbo.T_Discount_Scheme_Master
			SET I_Status = 0,
				S_Upd_By = @sModifiedBy,
				Dt_Upd_On = @dModifiedOn
			where I_Discount_Scheme_ID = @iDiscountSchemeID							
		DELETE FROM dbo.T_Discount_Details  
		WHERE I_Discount_Scheme_ID=@iDiscountSchemeID
	END
DROP TABLE #tempDiscountSchemeAdd
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION 
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
