-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Inserts Employee Aptitude Test Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeAptitudeTest] 
(
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
	INSERT INTO dbo.T_EMPLOYEE_APTITUDE_TEST
		(	
			--I_EAT_EMP_APTTEST_ID,
			I_EAT_ROLE_SKILL_TEST_ID,
			I_EAT_PROS_EMPLOYEE_ID,
			I_EAT_MARKS_OBTD,
			C_EAT_STATUS,
			S_EAT_CRTD_BY,
			S_EAT_UPD_BY,
			DT_EAT_CRTD_ON,
			DT_EAT_UPD_ON
		
		)
		VALUES 
		(
			@iEatRoleSkillTestId	,
			@iEatProsEmloyeeId	,
			@iEatMarksObtd	,
			@cEatStatus	,
			@vEatCrtdBy	,
			@vEatUpdBy	,
			@dEatCrtdOn	,
			@dEatUpdOn	
		)
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
