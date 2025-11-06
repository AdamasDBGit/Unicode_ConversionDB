-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Inserts  All Employee Skill Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeSkills] 
(
	@iEsdSkillId			INT,
	@iEsdProsEmployeeId		INT,
	@cEsdStatus				CHAR(1),
	@vEsdCrtdBy				VARCHAR(20),
	@vEsdUpdBy				VARCHAR(20),
	@dEsdCrtdOn				DATETIME,
	@dEsdUpdOn				DATETIME
 )

AS
BEGIN TRY 
	INSERT INTO dbo.T_EMPLOYEE_SKILL_DTLS 
		(	
			
			I_ESD_SKILL_ID,
			I_ESD_PROS_EMPLOYEE_ID,
			C_ESD_STATUS,
			S_ESD_CRTD_BY,
			S_ESD_UPD_BY,
			DT_ESD_CRTD_ON,
			DT_ESD_UPD_ON
 			
		)
		VALUES 
		(
					
			@iEsdSkillId		,		
			@iEsdProsEmployeeId	,	
			@cEsdStatus		    ,			
			@vEsdCrtdBy		    ,	
			@vEsdUpdBy		    ,	
			@dEsdCrtdOn	        ,		
			@dEsdUpdOn		
		)
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
