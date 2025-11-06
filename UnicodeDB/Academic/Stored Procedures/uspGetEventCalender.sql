-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <30th August 2023>
-- Description:	<to add event>
-- =============================================
CREATE PROCEDURE [Academic].[uspGetEventCalender]
	-- Add the parameters for the stored procedure here
	@iEventID int = null
	
AS
begin transaction
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select 
	TE.I_Event_ID EventID,
	TE.I_Brand_ID BrandID,
	TE.I_Event_Category_ID EventCategoryID,
	TE.S_Event_Name EventName,
	TE.Dt_StartDate sStartDate,
	TE.Dt_EndDate sEndDate,
	TE.I_EventFor,
	 CONVERT(varchar, TE.Dt_StartTime, 108) AS sStartTime,
    CONVERT(varchar, TE.Dt_EndTime, 108) AS sEndTime,
	TE.I_Status Status,
	(SELECT top 1 I_School_Group_ID from T_Event_Class where I_Event_ID = @iEventID) SchoolGroupID
	from T_Event TE where TE.I_Event_ID = @iEventID
	--inner join 
	--T_Event_Category TEV ON TEV.I_Event_Category_ID = TE.I_Event_Category_ID
	select
	I_School_Group_ID  SchoolGroupID,
	I_Class_ID ClassID
	from T_Event_Class where I_Event_ID = @iEventID and Is_Active=1
	

END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
END CATCH
commit transaction
