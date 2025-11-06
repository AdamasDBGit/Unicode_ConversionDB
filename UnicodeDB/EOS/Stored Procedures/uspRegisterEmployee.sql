/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will complete the registration of an employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspRegisterEmployee]
	(
		@iEmployeeID INT,
		@iStatus INT,
		@iIsInterViewCleared INT = NULL,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME
	)
AS
BEGIN TRY
	SET NOCOUNT ON;
	UPDATE dbo.T_Employee_Dtls
	SET I_Status = @iStatus,Is_Interview_Cleared=ISNULL(@iIsInterViewCleared,Is_Interview_Cleared),S_Upd_By=@sUpdatedBy,Dt_Upd_On=@DtUpdatedOn,Dt_Registration_Date = @DtUpdatedOn
	WHERE I_Employee_ID=@iEmployeeID	
	
END TRY
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
