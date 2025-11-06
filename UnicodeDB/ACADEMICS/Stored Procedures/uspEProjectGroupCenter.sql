/*******************************************************
Description : Get E-Project Group Details
Author	:     Abhisek Bhattacharya
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectGroupCenter]
(
	@iGroupID int
) 

AS
BEGIN TRY

SELECT I_Center_ID
FROM ACADEMICS.T_E_Project_Group
WHERE I_E_Project_Group_ID = @iGroupID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
