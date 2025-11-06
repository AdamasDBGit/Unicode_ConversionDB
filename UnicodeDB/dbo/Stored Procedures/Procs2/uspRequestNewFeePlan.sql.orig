-- =============================================
-- Author:		Aritra Saha
-- Create date: 15/03/2007
-- Description:	Adds a new Fee Plan request for a course
-- =============================================
CREATE PROCEDURE [dbo].[uspRequestNewFeePlan] 
(
	-- Add the parameters for the stored procedure here
	@iCurrencyID int = null,
	@nTotalLumpSum numeric = null,
	@nTotalInstallment numeric = null,
	@sDescription varchar(500) = null,
	@sWorkflowInstanceID varchar(50) = null,
	@sCreatedBy varchar(20)= null ,
	@dCreatedOn datetime = null,
	@iCenterID int = null,
	@iDeliveryPatternID int = null,
	@iCourseID int = null

)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	
	DECLARE @iCourseDeliveryID int
	DECLARE @iCourseCenterID int
	
	-- Select CourseDeliveryID from CourseDelivery Map
	SELECT 
	@iCourseDeliveryID =  I_Course_Delivery_ID 
	FROM T_Course_Delivery_Map
	WHERE I_Delivery_Pattern_ID = @iDeliveryPatternID 
	AND I_Course_ID = @iCourseID
	AND I_Status <> 0
	
	-- Select CourseCenterID from CourseCenter Map
	SELECT 
	@iCourseCenterID =  I_Course_Center_ID 
	FROM T_Course_Center_Detail
	WHERE I_Centre_ID = @iCenterID 
	AND I_Course_ID = @iCourseID
	AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	AND I_Status <> 0
	
	-- Add New Fee Plan Request in CourseFeePlanRequest
	INSERT INTO T_Course_FeePlan_Request
           (I_Currency_ID,I_Course_Delivery_ID,I_Course_Center_ID,N_TotalLumpSum,N_TotalInstallment,
           S_Description,S_Workflow_GUID_ID,I_Status,S_Crtd_By,Dt_Crtd_On)
     VALUES
           (@iCurrencyID,@iCourseDeliveryID,@iCourseCenterID,@nTotalLumpSum,@nTotalInstallment,
           @sDescription,@sWorkflowInstanceID,1,@sCreatedBy,@dCreatedOn)
	

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
