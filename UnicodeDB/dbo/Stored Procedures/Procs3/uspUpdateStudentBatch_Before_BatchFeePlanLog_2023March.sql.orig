CREATE PROCEDURE [dbo].[uspUpdateStudentBatch_Before_BatchFeePlanLog_2023March]       
(     
  @iBatchId INT,    
  @iDeliveryPatternID INT,
  --@iTimeSlotId INT,
  @dtBatchStartDate DATETIME,
  @dtCourseExpectedEndDate DATETIME,
  @iStatus INT,
  @sUpdatedBy VARCHAR(500),
  @sUpdatedOn DATETIME,
  @iFacultyId int,
  @sBatchName varchar(100)	
)        
AS        
BEGIN TRY 

UPDATE dbo.T_Student_Batch_Master SET
I_Delivery_Pattern_ID = @iDeliveryPatternID,
--I_TimeSlot_ID = @iTimeSlotId,
Dt_BatchStartDate = @dtBatchStartDate,
Dt_Course_Expected_End_Date = @dtCourseExpectedEndDate,
I_Status = @iStatus,
S_Updt_By = @sUpdatedBy,
Dt_Upd_On = @sUpdatedOn,
I_User_Id = @iFacultyId,
S_Batch_Name = @sBatchName
WHERE
I_Batch_ID = @iBatchId
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
