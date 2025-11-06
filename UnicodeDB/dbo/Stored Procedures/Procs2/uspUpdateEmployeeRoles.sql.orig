-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Updates All Employee Role Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeRoles] 
(	
	@iErdEmpRoleDtlId		INT,
	@iErdRoleId				INT,
	@iErdProsEmployeeId		INT,
	@cErdStatus				CHAR(1),
	@dErdStartDate			DATETIME,
	@dErdEndDate			DATETIME,
	@vErdCrtdBy				VARCHAR(20),
	@vErdUpdBy				VARCHAR(20),
	@dErdCrtdOn				DATETIME,
	@dErdUpdOn				DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_ROLE_DTLS SET 
			
			I_ERD_ROLE_ID = @iErdRoleId ,
			I_ERD_PROS_EMPLOYEE_ID = @iErdProsEmployeeId ,
			C_ERD_STATUS = @cErdStatus ,
			DT_ERD_START_DATE = @dErdStartDate ,
			DT_ERD_END_DATE = @dErdEndDate ,
			S_ERD_CRTD_BY = @vErdCrtdBy ,
			S_ERD_UPD_BY = @vErdUpdBy ,
			DT_ERD_CRTD_ON = @dErdCrtdOn ,
			DT_ERD_UPD_ON = @dErdUpdOn
 					
			WHERE I_ERD_EMP_ROLE_DTL_ID =@iErdEmpRoleDtlId

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
