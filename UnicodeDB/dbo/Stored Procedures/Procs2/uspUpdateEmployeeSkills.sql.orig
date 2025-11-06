-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Updates  All Employee Skill Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeSkills] 
(	
	@iEsdEmpSkillDtlId		INT,
	@iEsdSkillId			INT,
	@iEsdProsEmployeeId	    INT,
	@cEsdStatus				CHAR(1),
	@vEsdCrtdBy				VARCHAR(20),
	@vEsdUpdBy				VARCHAR(20),
	@dEsdCrtdOn				DATETIME,
	@dEsdUpdOn				DATETIME
 )

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_SKILL_DTLS SET
	
			I_ESD_SKILL_ID = @iEsdSkillId,
			I_ESD_PROS_EMPLOYEE_ID = @iEsdProsEmployeeId,
			C_ESD_STATUS = @cEsdStatus,
			S_ESD_CRTD_BY =@vEsdCrtdBy,
			S_ESD_UPD_BY = @vEsdUpdBy,
			DT_ESD_CRTD_ON =@dEsdCrtdOn	,
			DT_ESD_UPD_ON = @dEsdUpdOn
 				
			WHERE I_ESD_EMP_SKILL_DTL_ID = @iEsdEmpSkillDtlId	

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
