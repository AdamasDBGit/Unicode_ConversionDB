-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Deletes Employee Aptitude Test Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeAptitudeTest] 
(	
	@iEatEmpApttestId			INT,
	@vEatUpdBy					VARCHAR(20),
	@dEatUpdOn					DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_APTITUDE_TEST SET
		
			C_EAT_STATUS = 'D' ,
			S_EAT_UPD_BY = @vEatUpdBy ,
			DT_EAT_UPD_ON = @dEatUpdOn
		
			WHERE I_EAT_EMP_APTTEST_ID = @iEatEmpApttestId
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
