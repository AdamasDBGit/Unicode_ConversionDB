-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getBatchScheduleByBatchIDScheduleDate]
 (
	 @iBatchID int ,
	 @iBatchScheduleID int
 )	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 select top 1 * from T_Student_Batch_Schedule 
		where Dt_Schedule_Date < (select Dt_Schedule_Date from T_Student_Batch_Schedule where  I_Batch_Schedule_ID = @iBatchScheduleID) 
		and I_Batch_ID = @iBatchID --and Dt_Schedule_Date > GETDATE() 
		order by Dt_Schedule_Date desc
		END
