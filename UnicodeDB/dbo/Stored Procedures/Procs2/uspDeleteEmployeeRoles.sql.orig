-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Deletes All Employee Role Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeRoles] 
(	
	@iErdEmpRoleDtlId		INT,
	@vErdUpdBy				VARCHAR(20),
	@dErdUpdOn				DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_ROLE_DTLS SET 
			
			C_ERD_STATUS = 'D' ,
			S_ERD_UPD_BY = @vErdUpdBy ,
			DT_ERD_UPD_ON = @dErdUpdOn
 					
			WHERE I_ERD_EMP_ROLE_DTL_ID =@iErdEmpRoleDtlId

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
