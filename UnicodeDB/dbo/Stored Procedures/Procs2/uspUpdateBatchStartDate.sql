CREATE PROCEDURE [dbo].[uspUpdateBatchStartDate]  
(    
  @iBatchID INT,  
  @dtBatchStartDate  DATETIME  ,
  @iBatchScheduleID INT
)    
AS    
BEGIN  
	declare @getIbatchscheduleID int
	select  top 1 @getIbatchscheduleID= I_Batch_Schedule_ID from T_Student_Batch_Schedule where i_batch_id = 3526--@iBatchID   
	--select @getIbatchscheduleID
	if @getIbatchscheduleID = @iBatchScheduleID
	begin
		UPDATE dbo.T_Student_Batch_Master SET Dt_BatchStartDate = @dtBatchStartDate  
		WHERE I_Batch_ID=@iBatchID  
	end
  
END
