/*******************************************************
Description : Get E-Project FAQ List
Author	:     Arindam Roy
Date	:	  05/28/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectFAQList] 
(
	@iEProjectSpecID int
)

AS

BEGIN TRY 
	
	 SELECT I_FAQ_ID,
			S_Question_Description,
			S_Answer_Description,
			I_Status,
			Dt_Crtd_On,
			Dt_Upd_On
	   FROM ACADEMICS.T_FAQ_Details
	  WHERE I_E_Project_Spec_ID=@iEProjectSpecID
		AND I_Status=1

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
