/*******************************************************
Description : Modify E-Project Specification List
Author	:     Soumya Sikder
Date	:	  02/08/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspModifyEProjectSpecification] 
(
	@iSpecID int,
	@sSpecDesc varchar(500) = null,
	@iFileID int = null,
	@sUser varchar(20),
	@dDate datetime,
	@iFlag int,
	@dValidTo datetime = null
)
AS

BEGIN TRY 
	
	-- Update the E-Project Specification
	IF(@iFlag = 1)
	BEGIN		

		UPDATE ACADEMICS.T_E_Project_Spec
		SET 
			S_Description = ISNULL(@sSpecDesc,S_Description),
			I_File_ID = ISNULL(@iFileID,I_File_ID),
			Dt_Valid_To = ISNULL(@dValidTo,Dt_Valid_To),
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_E_Project_Spec_ID = @iSpecID
		AND I_Status = 1

--		SET @iSpecID = SCOPE_IDENTITY()

		SELECT @iSpecID SpecID
		
	END 

	-- Delete E-project Specification
	IF(@iFlag = 2)
	BEGIN
		

		UPDATE ACADEMICS.T_E_Project_Spec
		SET 
			I_Status = 0,
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_E_Project_Spec_ID = @iSpecID
		AND I_Status = 1

--		SET @iSpecID = SCOPE_IDENTITY()		

		SELECT @iSpecID SpecID
		
	END 
	
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
