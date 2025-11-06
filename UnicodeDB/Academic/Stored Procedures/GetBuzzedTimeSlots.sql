-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <1st sept 2023>
-- Description:	<to fetch the time slots>
-- =============================================
CREATE PROCEDURE [Academic].[GetBuzzedTimeSlots]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Select BTS.I_Slot_ID SlotID,
  BTS.S_Slot_Title SlotTitle,
  BTS.Dt_Start_Time StartTime,
  BTS.Dt_End_Time EndTime from [T_buzzedDB_Time_Slots] as BTS
  END
