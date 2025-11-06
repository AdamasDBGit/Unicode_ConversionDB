-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Deletes Qualification of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeQualification] 
(
	
	@iEquEmployeeQualId				INT			,
	@vEadUpdBy						VARCHAR(20)	,
	@dEadUpdOn						DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_QUALIFICATION SET 
		
			C_EQU_STATUS = 'D'				,
			S_EQU_UPD_BY = @vEadUpdBy		,
			DT_EQU_UPD_ON = @dEadUpdOn	
			
			WHERE I_EQU_EMPLOYEE_QUAL_ID=@iEquEmployeeQualId		
 			
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
