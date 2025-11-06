-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <30th August 2023>
-- Description:	<to add event>
-- =============================================
CREATE PROCEDURE [Academic].[uspAddEventCalender_BKP_10012024]
	-- Add the parameters for the stored procedure here
	@sEventName nvarchar(100),
	@iEventCatagory int = null,
	--@ApplicableFor int = null,
	@dtFormDate datetime,
	@dtToDate datetime,
	@tToTime time(0) =null,
	@tFromTime time(0) = null,
	@UTEvents UT_Events readonly,
	@sCreatedBy nvarchar(50),
	@iEventID int = null,
	@brandid int 
	
AS
begin transaction
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @iLsatID int
	if(@iEventID>0)
	BEGIN
	update [T_Event] 
	set 
	[S_Event_Name]					= @sEventName,
	[I_Event_Category_ID]			= @iEventCatagory,
	[Dt_StartDate]					= @dtFormDate,
	[Dt_EndDate]					= @dtToDate,
	[S_CreatedBy]					= @sCreatedBy,
	[Dt_StartTime]					= @tFromTime,
	[Dt_EndTime]					= @tToTime,
	[I_Status]						= 1,
	[I_Brand_ID]					= @brandid
	where I_Event_ID = @iEventID
	delete from T_Event_Class where I_Event_ID = @iEventID
	INSERT into T_Event_Class
(
 I_Event_ID
,I_School_Group_ID
,I_Class_ID
)
select 
@iEventID
,SchoolGroupID
,ClassID
 from @UTEvents
 SELECT 1 StatusFlag,'Event updated' Message,@iEventID EventID
	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[T_Event]
(
[S_Event_Name],
[I_Event_Category_ID],
[Dt_StartDate],
[Dt_EndDate],
[S_CreatedBy],
[Dt_StartTime],
[Dt_EndTime],
[I_Status],
[I_Brand_ID]
)
VALUES
(
	@sEventName,
	@iEventCatagory,
	@dtFormDate,
	@dtToDate,
	@sCreatedBy,
	@tFromTime,
	@tToTime,
	1,
	@brandid
)
set @iLsatID = SCOPE_IDENTITY()
INSERT into T_Event_Class
(
 I_Event_ID
,I_School_Group_ID
,I_Class_ID
)
select 
@iLsatID
,SchoolGroupID
,ClassID
 from @UTEvents
SELECT 1 StatusFlag,'Event added' Message,@iLsatID EventID
	END
	

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

