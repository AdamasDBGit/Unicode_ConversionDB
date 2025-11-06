/*******************************************************
Description : Get E-Project Group Details for assigned specific Specification
Author	:     Soumya Sikder
Date	:	  02/08/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectGroupListAssignedSpec] 
(
	@iEProjectSpecID int
)

AS

BEGIN TRY 

-- All GroupList details having Specification assigned
BEGIN

	SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status,
			EPG.I_E_Project_Spec_ID
			FROM ACADEMICS.T_E_Project_Group EPG 
			WHERE EPG.I_E_Project_Spec_ID=@iEProjectSpecID
			AND EPG.I_Status NOT IN (2,3)
END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
