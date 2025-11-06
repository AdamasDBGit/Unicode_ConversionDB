-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Insert new business record in T_Business_Master table	
-- =================================================================
CREATE PROCEDURE [PLACEMENT].[uspAddNatureOfBusiness] 
(
       @SDescriptionBusiness varchar(50),
       @SCrtdBy  varchar(20),
       @DtCrtdOn datetime
	
)
AS
BEGIN TRY
	SET NOCOUNT OFF;

    INSERT INTO [PLACEMENT].T_Business_Master
	(
		S_Description_Business,
       	S_Crtd_By,
        Dt_Crtd_On
	)
	VALUES
	(
		@SDescriptionBusiness,
       	@SCrtdBy,
        @DtCrtdOn 
	)
						
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
