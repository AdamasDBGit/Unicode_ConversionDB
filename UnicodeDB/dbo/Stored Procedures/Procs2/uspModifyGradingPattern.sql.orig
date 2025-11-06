-- =============================================
-- Author:		Rabin Mukherjee
-- Create date: 16/01/2007
-- Description:	Modifies the Grading Pattern Master and Details Table
--For Insert exec uspModifyGradingPattern 0,'<GradingPatternDetails>\r\n  <GradingPatternDetailList>\r\n    <S_Grade_Type>a</S_Grade_Type>\r\n    <I_MinMarks>15</I_MinMarks>\r\n    <I_MaxMarks>20</I_MaxMarks>\r\n  </GradingPatternDetailList>\r\n</GradingPatternDetails>','Test Pattern','course','10/10/2004',1
--For Update exec uspModifyGradingPattern 3,'<GradingPatternDetails>\r\n  <GradingPatternDetailList>\r\n    <S_Grade_Type>A</S_Grade_Type>\r\n    <I_MinMarks>15</I_MinMarks>\r\n    <I_MaxMarks>25</I_MaxMarks>\r\n  </GradingPatternDetailList>\r\n</GradingPatternDetails>','Test Pattern1','course','10/10/2004',2
--For Delete exec uspModifyGradingPattern 3,'','','course','10/10/2004',3

-- =============================================

CREATE PROCEDURE [dbo].[uspModifyGradingPattern] 
(
	@iGradingPatternMasterID int = null,
	@iBrandID int,
	@sGradingPatternDetails varchar(8000) = null,
	@sGradingPattern varchar(20) = null,
	@sModifiedBy varchar(20),
	@dModifiedOn datetime,
	@iFlag int
)

AS
BEGIN TRY
	SET NOCOUNT OFF;
	DECLARE @iDocHandle INT
	CREATE TABLE #tempGradingPatternAdd
							(
								I_Pattern_ID int,					
								S_Grade_Type varchar(20),
								I_MinMarks Numeric(20),
								I_MaxMarks Numeric(20)
							)
	BEGIN TRAN T1
    IF @iFlag = 1
		BEGIN
			DECLARE @iPatternID int
				INSERT INTO T_Grading_Pattern_Master(I_Brand_ID,S_Pattern_Name,I_Status,S_Crtd_By,Dt_Crtd_On)
					VALUES(@iBrandID,@sGradingPattern,1,@sModifiedBy,@dModifiedOn)
				
				SELECT @iPatternID=@@IDENTITY
				EXEC sp_xml_preparedocument @iDocHandle output,@sGradingPatternDetails

				INSERT INTO #tempGradingPatternAdd (S_Grade_Type, I_MinMarks, I_MaxMarks)
					SELECT * FROM
					OPENXML(@iDocHandle, '/GradingPatternDetails/GradingPatternDetailList',2)
					WITH (S_Grade_Type varchar(20), I_MinMarks int, I_MaxMarks int)
				
				UPDATE #tempGradingPatternAdd SET I_Pattern_ID=@iPatternID

				INSERT INTO T_Grading_Pattern_Detail (I_Grading_Pattern_ID, S_Grade_Type, I_MinMarks, I_MaxMarks) 			
					SELECT *
					FROM #tempGradingPatternAdd
			
		END
	ELSE IF @iFlag = 2
		BEGIN
			--DECLARE @gPatternID int  
			
					UPDATE dbo.T_Grading_Pattern_Master
							SET S_Pattern_Name = @sGradingPattern,
							S_Upd_By = @sModifiedBy,
							Dt_Upd_On = @dModifiedOn
							where I_Grading_Pattern_ID = @iGradingPatternMasterID

							EXEC sp_xml_preparedocument @iDocHandle output,@sGradingPatternDetails

							INSERT INTO #tempGradingPatternAdd (S_Grade_Type, I_MinMarks, I_MaxMarks)
								SELECT * FROM
								OPENXML(@iDocHandle, '/GradingPatternDetails/GradingPatternDetailList',2)
								WITH (S_Grade_Type varchar(20), I_MinMarks int, I_MaxMarks int)

							UPDATE #tempGradingPatternAdd SET I_Pattern_ID=@iGradingPatternMasterID

							DELETE FROM T_Grading_Pattern_Detail WHERE I_Grading_Pattern_ID=@iGradingPatternMasterID
							
							INSERT INTO T_Grading_Pattern_Detail (I_Grading_Pattern_ID, S_Grade_Type, I_MinMarks, I_MaxMarks) 			
								SELECT *
								FROM #tempGradingPatternAdd
			
		END

	ELSE IF @iFlag = 3
	BEGIN	
		
					UPDATE dbo.T_Grading_Pattern_Master
							SET I_Status = 0,
							S_Upd_By = @sModifiedBy,
							Dt_Upd_On = @dModifiedOn
							where I_Grading_Pattern_ID = @iGradingPatternMasterID							
							DELETE FROM T_Grading_Pattern_Detail WHERE I_Grading_Pattern_ID=@iGradingPatternMasterID
		
	END	
	
	TRUNCATE TABLE #tempGradingPatternAdd
	DROP TABLE #tempGradingPatternAdd

	SELECT @iPatternID GradingPatternID
	COMMIT TRAN T1
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
