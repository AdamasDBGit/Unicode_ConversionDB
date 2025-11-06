-- =============================================
-- Author:		Soumya Sikder
-- Create date: '08/06/2007'
-- Description:	This Procedure return the E-Project Specification ID if available
-- otherwise returns 0
-- for a particular Course, Term , Module . 
-- Return: EProjectSpecID Integer
-- =============================================

CREATE PROCEDURE [ACADEMICS].[uspValidateEProjectSpecAvailability] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int = null,
	@dFromDate datetime,
	@dCurrentDate datetime,
	@iEProjSpecAvailNoDays int
)
AS
BEGIN TRY

	DECLARE @iEProjectSpecID INT

	SET @iEProjectSpecID = [ACADEMICS].[fnGetEProjectSpecID](@iCourseID, @iTermID, @iModuleID, @iCenterID, @dFromDate, @dCurrentDate, @iEProjSpecAvailNoDays)

	SELECT @iEProjectSpecID EProjectSpecID
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
