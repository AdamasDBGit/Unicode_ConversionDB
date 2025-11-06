/*****************************************************************************************************************
Created by:		Swagata De
Date:			11/9/07
Description:	This Stored procedure is used to calculate the end date for an e project on the basis of the start date
Parameters:		@iDeliveryPatternID int,
				@iModuleID int	
Returns:	
******************************************************************************************************************/

CREATE PROCEDURE [ACADEMICS].[uspCalculateEprojectEndDate] 
(
	@iDeliveryPatternID int,
	@iModuleID int	,
	@dtStartdate datetime
)

AS
BEGIN TRY 
	DECLARE @iNoOfSessionsInModule INT
	DECLARE	@iSessionDayGap NUMERIC(8,2)
	DECLARE	@iNoOfSessions NUMERIC(8,2)

	DECLARE @iDays INT
	DECLARE @nDays NUMERIC(8,2)
	
		
	  SELECT @iNoOfSessionsInModule = 
	  COUNT(DISTINCT I_Session_ID) FROM dbo.T_Session_Module_Map
	  WHERE I_Module_ID = @iModuleID 
	  AND I_Status <> 0
	  AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
      AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	
	SELECT @iSessionDayGap = N_Session_Day_Gap , @iNoOfSessions = I_No_Of_Session
	FROM dbo.T_Delivery_Pattern_Master
	WHERE I_Delivery_Pattern_ID = @iDeliveryPatternID
	

	SELECT @iDays = CONVERT(INT,(@iNoOfSessionsInModule*@iSessionDayGap*1.25)/@iNoOfSessions)
	SELECT @nDays = (@iNoOfSessionsInModule*@iSessionDayGap*1.25)/@iNoOfSessions
	IF @nDays>@iDays
		SET @iDays = @iDays + 1		
		SELECT DATEADD(day,@iDays,@dtStartdate)
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
