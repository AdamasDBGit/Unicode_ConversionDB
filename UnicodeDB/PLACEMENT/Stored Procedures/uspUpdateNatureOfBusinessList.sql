/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Update of Nature of business records of T_Business_Master table	
-- Parameters  :@INatureofBusiness
--				@SDescriptionBusiness
				@SUpdBy
				@DtUpdOn
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspUpdateNatureOfBusinessList]
(
			@INatureofBusiness INT,
			@SDescriptionBusiness VARCHAR(50),
			@SUpdBy VARCHAR(20),
			@DtUpdOn DATETIME
)
AS
BEGIN TRY 

	UPDATE [PLACEMENT].T_Business_Master
	SET 		
        S_Description_Business=@SDescriptionBusiness,
		S_Upd_By=@SUpdBy,
        Dt_Upd_On=@DtUpdOn
	WHERE
		I_Nature_of_Business=@INatureofBusiness
	
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
