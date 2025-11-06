-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Deletes Address of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeAddress] 
(
	
	@iEadEmployeeAddressId			INT			,
    @vEadUpdBy						VARCHAR(20)	,
	@dEadUpdOn						DATETIME
	
)

AS
BEGIN TRY 
	UPDATE dbo.T_EMPLOYEE_ADDRESS SET 
		
			C_EAD_STATUS = 'D'		    ,
			S_EAD_UPD_BY =  @vEadUpdBy	,
			DT_EAD_UPD_ON = @dEadUpdOn		
			
			WHERE I_EAD_Employee_Address_ID =@iEadEmployeeAddressId
 			
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
