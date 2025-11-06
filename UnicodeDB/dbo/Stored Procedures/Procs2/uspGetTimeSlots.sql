-- =============================================
-- Author:		Aritra Saha
-- Create date: 03/05/2007
-- Description:	This SP retrieves all Time Slots for MasterData
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimeSlots] 

	-- Add the parameters for the stored procedure here
	

AS
BEGIN 

	SET NOCOUNT ON;

	SELECT 
	I_TimeSlot_ID,I_Centre_Id,S_TimeSlot_Code,S_TimeSlot_Desc
	FROM dbo.T_Center_TimeSlot WHERE I_Status <> 0

END
