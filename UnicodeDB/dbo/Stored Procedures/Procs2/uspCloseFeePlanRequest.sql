CREATE PROCEDURE [dbo].[uspCloseFeePlanRequest] -- [uspCloseFeePlanRequest] null,2,4,72,1,14
(
	-- Add the parameters for the stored procedure here
	@iCurrencyID int = null,	
	@iApprovedStatus int,	
	@iAssignedStatus int,
	@iCenterLevelID int = null,
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
	DECLARE @iCenterID int
	DECLARE @bCheck bit
	
	--Select CenterID from CenterLevel ID
	SELECT @iCenterID = I_Center_Id 
	FROM T_Center_Hierarchy_Details 
	WHERE I_Hierarchy_Detail_ID = @iCenterLevelID

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

	DECLARE  @iCourseFeePlanRequestID INT 
	SET @iCourseFeePlanRequestID = NULL
	SET  @iCourseFeePlanRequestID = (SELECT TOP 1 I_Course_FeePlan_Request_ID FROM 
									dbo.T_Course_FeePlan_Request 
									WHERE I_Course_Delivery_ID = @iCourseDeliveryID 
									AND I_Course_Center_ID = @iCourseCenterID									
									AND I_Status = @iApprovedStatus  --Approved)
									ORDER BY Dt_Upd_On DESC)

	--SELECT 	@iCourseFeePlanRequestID
	
	IF (@iCourseFeePlanRequestID IS NOT NULL)
	BEGIN
		UPDATE dbo.T_Course_FeePlan_Request
		SET I_Status = @iAssignedStatus --Assigned
		WHERE I_Course_FeePlan_Request_ID = @iCourseFeePlanRequestID
		SET @bCheck = 1
	END
	ELSE
	BEGIN
		SET @bCheck = 0
	END

	SELECT @bCheck AS RETVALUE

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
