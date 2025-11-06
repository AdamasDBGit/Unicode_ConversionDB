-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Deletes  All Employee Skill Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeSkills] 
(	
	@iEsdEmpSkillDtlId		INT,
	@vEsdUpBy				VARCHAR(20),
	@dEsdUpdOn			    DATETIME
 )

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_SKILL_DTLS SET
	
			C_ESD_STATUS = 'D',
			S_ESD_UPD_BY = @vEsdUpBy,	
			DT_ESD_UPD_ON = @dEsdUpdOn	
 				
			WHERE I_ESD_EMP_SKILL_DTL_ID = @iEsdEmpSkillDtlId

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
