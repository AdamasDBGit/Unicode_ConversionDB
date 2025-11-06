CREATE PROCEDURE [dbo].[uspInsertBatchTimeSlotDetails]
(
@BatchID INT,
@ClassMode NVARCHAR(MAX),
@DayofWeek NVARCHAR(MAX),
@Period1 NVARCHAR(MAX)=NULL,
@Period2 NVARCHAR(MAX)=NULL,
@Period3 NVARCHAR(MAX)=NULL,
@Period4 NVARCHAR(MAX)=NULL,
@Period5 NVARCHAR(MAX)=NULL,
@Period6 NVARCHAR(MAX)=NULL,
@CreatedBy NVARCHAR(MAX)=''
)
AS
BEGIN


	update T_Center_Batch_Details set S_ClassMode=@ClassMode where I_Batch_ID=@BatchID

	delete from T_Student_Batch_TimeSlot_Details where BatchID=@BatchID and ClassDay=@DayofWeek

	if(@Period1 is not null and @Period1!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,1,@Period1,@CreatedBy,GETDATE()

	end


	if(@Period2 is not null and @Period2!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,2,@Period2,@CreatedBy,GETDATE()

	end


	if(@Period3 is not null and @Period3!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,3,@Period3,@CreatedBy,GETDATE()

	end


	if(@Period4 is not null and @Period4!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,4,@Period4,@CreatedBy,GETDATE()

	end

	if(@Period5 is not null and @Period5!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,5,@Period5,@CreatedBy,GETDATE()

	end

	if(@Period6 is not null and @Period6!='')
	begin

		insert into T_Student_Batch_TimeSlot_Details
		select @BatchID,@DayofWeek,6,@Period6,@CreatedBy,GETDATE()

	end



END

