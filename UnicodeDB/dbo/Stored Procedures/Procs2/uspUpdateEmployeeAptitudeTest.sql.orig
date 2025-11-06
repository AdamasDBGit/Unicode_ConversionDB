-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Updates Employee Aptitude Test Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeAptitudeTest] 
(	
	@iEatEmpApttestId				INT,
	@iEatRoleSkillTestId			INT,
	@iEatProsEmloyeeId				INT,
	@iEatMarksObtd					INT,
	@cEatStatus						CHAR(1),
	@vEatCrtdBy						VARCHAR(20),
	@vEatUpdBy						VARCHAR(20),
	@dEatCrtdOn						DATETIME,
	@dEatUpdOn						DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_APTITUDE_TEST SET
		
			I_EAT_ROLE_SKILL_TEST_ID = @iEatRoleSkillTestId ,
			I_EAT_PROS_EMPLOYEE_ID = @iEatProsEmloyeeId ,
			I_EAT_MARKS_OBTD = @iEatMarksObtd ,
			C_EAT_STATUS = @cEatStatus ,
			S_EAT_CRTD_BY = @vEatCrtdBy ,
			S_EAT_UPD_BY = @vEatUpdBy ,
			DT_EAT_CRTD_ON = @dEatCrtdOn ,
			DT_EAT_UPD_ON = @dEatUpdOn
		
			WHERE I_EAT_EMP_APTTEST_ID = @iEatEmpApttestId
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
