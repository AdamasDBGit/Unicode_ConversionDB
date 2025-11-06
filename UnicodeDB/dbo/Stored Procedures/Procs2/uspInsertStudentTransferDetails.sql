-- =============================================
-- Author:		Swagata De
-- Create date: 27/03/07
-- Description:	Inserts a new row into the T_Student_Transfer_Request_Details table
-- =============================================

CREATE PROCEDURE [dbo].[uspInsertStudentTransferDetails] 
(
	@iTransferRequestId int,	
	@sCourseTimeSlotXml xml
	
)
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY

	
	DECLARE
	@AdjPosition SMALLINT, 
	@AdjCount SMALLINT,
	@KeyValueXml XML ,
	@iCourse int, 
    @iTimeSlot int
	
	SET @AdjPosition = 1
	SET @AdjCount = @sCourseTimeSlotXml.value('count((CourseTimeSlotList/CourseTimeSlot))','int')
	BEGIN TRAN T1
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN		
		--Get the Adjustment node for the Current Position
			SET @KeyValueXml = @sCourseTimeSlotXml.query('/CourseTimeSlotList/CourseTimeSlot[position()=sql:variable("@AdjPosition")]')
			SELECT	@iCourse = T.a.value('@I_Course_ID','int'),
					@iTimeSlot = T.a.value('@I_TimeSlot_ID','int')		
			FROM @KeyValueXml.nodes('/CourseTimeSlot') T(a)
			
			INSERT INTO dbo.T_Student_Transfer_Request_Details
			(
		I_Transfer_Request_ID,		
		I_Course_ID,
		I_TimeSlot_ID	
		
		)
		Values (@iTransferRequestId, @iCourse, @iTimeSlot )
		SET @AdjPosition = @AdjPosition + 1
		
	
	END
	COMMIT  TRAN T1
	END TRY
	
	BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
   END CATCH
