-- ======================================================================================
-- Author:		Anirban Pahari
-- Create date: 01/02/2007
-- Description:	It modifies the Term Master Table
-- exec uspModifyTerm 2,1,'T001','Term Name','ram','sdfd','10/10/2004','10/10/2007',3
-- ======================================================================================
CREATE PROCEDURE [dbo].[uspModifyTerm]  
	@iTermID int,
	@iBrandID int = null,
	@vTermCode varchar(50) = null,
	@vTermName varchar(250) = null,
	@sTermBy varchar(20),
	@dTermOn datetime,
	@iFlag int,
	@iTotalSessionCount int

AS
BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

    -- Insert statements for procedure here
	IF(@iFlag=1)
		BEGIN
			BEGIN TRAN T1
				INSERT INTO T_Term_Master 
				(	I_Brand_ID,
					S_Term_Code,
					S_Term_Name,
					I_Total_Session_Count,
					S_Crtd_By,
					Dt_Crtd_On,
					I_Status	)
				VALUES
				(	@iBrandID,
					@vTermCode,
					@vTermName,
					@iTotalSessionCount,
					@sTermBy,
					@dTermOn,
					1	)
					
				SET @iTermID = @@IDENTITY
			COMMIT TRAN T1	

		END
   ELSE IF (@iFlag=2)
		BEGIN
			UPDATE dbo.T_Term_Master
			SET 
				S_Term_Name=@vTermName,
				I_Total_Session_Count = @iTotalSessionCount,
				S_Upd_By = @sTermBy,
				Dt_Upd_On = @dTermOn
				where I_Term_ID = @iTermID
		END
  ELSE IF (@iFlag=3)
		BEGIN 
			UPDATE dbo.T_Term_Master
			SET I_Status = 0,
			S_Upd_By = @sTermBy,
			Dt_Upd_On = @dTermOn
			where I_Term_ID = @iTermID
		END 
		
		SELECT @iTermID AS TermID
	
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
