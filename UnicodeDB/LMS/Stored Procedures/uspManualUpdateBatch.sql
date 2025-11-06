CREATE PROCEDURE [LMS].[uspManualUpdateBatch](@BatchCode VARCHAR(MAX), @StartDate Datetime=NULL, @EndDate Datetime=NULL)
as
begin

	Declare @BatchID INT=0

	select @BatchID=I_Batch_ID from T_Student_Batch_Master where S_Batch_Code=@BatchCode

	if(@BatchID>0)
	begin

		if(@StartDate IS NOT NULL)
		begin

			--select * from T_Student_Batch_Master
			update T_Student_Batch_Master set Dt_BatchStartDate=@StartDate where I_Batch_ID=@BatchID

		end

		if(@EndDate IS NOT NULL)
		begin

			--select * from T_Student_Batch_Master
			update T_Student_Batch_Master set Dt_Course_Expected_End_Date=@EndDate where I_Batch_ID=@BatchID

		end

	end


	EXEC LMS.uspInsertBatchDetailsForInterface @BatchID,'UPDATE'


end
