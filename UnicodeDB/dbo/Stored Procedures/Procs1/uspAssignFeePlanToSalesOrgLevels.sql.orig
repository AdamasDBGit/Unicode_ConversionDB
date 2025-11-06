CREATE PROCEDURE [dbo].[uspAssignFeePlanToSalesOrgLevels]
(
	@iSelectedHierarchyId int,
	@iSelectedBrandId int,
	@iCourseID int,
	@iDeliveryID int,
	@iFeePlanID int,
	@sCreatedBy varchar(20),
	@dCreatedOn datetime
)

AS
BEGIN TRY
BEGIN TRAN T1

	SET NOCOUNT ON

	DECLARE @sSearchCriteria varchar(max)
	DECLARE @iMax int
	DECLARE @iCount int
	DECLARE @iCourseCenterID int
	DECLARE @iCourseDeliveryID int
	DECLARE @iIsEditable int
	DECLARE @iTotalSessions int
	DECLARE @iTotalDays numeric(18,0)
	DECLARE @nDeliveryDayGap numeric(8,2)
	DECLARE @iDeliveredSessionsPerDay int
	DECLARE @iExistingFeePlanID int

	SELECT @sSearchCriteria= S_Hierarchy_Chain
	FROM T_Hierarchy_Mapping_Details WITH(NOLOCK)
	WHERE I_Hierarchy_detail_id = @iSelectedHierarchyId

	CREATE TABLE #tempCenter
	(
		seq int identity(1,1),
		centerID int
	)

	SET @iMax = 0
	SET @iCount = 1

	IF @iSelectedBrandId = 0
		BEGIN
			INSERT INTO #tempCenter(centerID)
			SELECT TCHD.I_Center_Id
			FROM T_CENTER_HIERARCHY_DETAILS TCHD WITH(NOLOCK)
			WHERE TCHD.I_Hierarchy_Detail_ID IN
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%')
		END
	ELSE
		BEGIN
			INSERT INTO #tempCenter(centerID)
			SELECT TCHD.I_Center_Id
			FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WITH(NOLOCK)
			WHERE TCHD.I_Hierarchy_Detail_ID IN
			(SELECT I_HIERARCHY_DETAIL_ID
			FROM T_Hierarchy_Mapping_Details
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id
		END

	SELECT @iMax = MAX(seq) FROM #tempCenter

	SET @iCourseDeliveryID = 0
	SET @iTotalDays = 0

	SELECT @iIsEditable = I_Is_Editable FROM dbo.T_Course_Master WITH(NOLOCK) WHERE I_Course_ID = @iCourseID

	SELECT @iCourseDeliveryID = A.I_Course_Delivery_ID,
	@nDeliveryDayGap = B.N_Session_Day_Gap,
	@iDeliveredSessionsPerDay = B.I_No_Of_Session
	FROM dbo.T_Course_Delivery_Map A WITH(NOLOCK)
	INNER JOIN dbo.T_Delivery_Pattern_Master B
	ON A.I_Delivery_Pattern_ID = B.I_Delivery_Pattern_ID
	WHERE A.I_Course_ID = @iCourseID
	AND A.I_Delivery_Pattern_ID = @iDeliveryID
	AND A.I_Status <> 0

	--IF @iIsEditable <> 0
	--BEGIN
	SELECT @iTotalSessions = COUNT(B.I_Session_ID)
	FROM dbo.T_Session_Module_Map A WITH(NOLOCK)
	INNER JOIN dbo.T_Session_Master B
	ON A.I_Session_ID = B.I_Session_ID
	INNER JOIN dbo.T_Module_Term_Map C
	ON A.I_Module_ID = C.I_Module_ID
	INNER JOIN dbo.T_Term_Course_Map D
	ON C.I_Term_ID = D.I_Term_ID
	AND D.I_Course_ID = @iCourseID
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	AND C.I_Status <> 0
	AND D.I_Status <> 0

	IF @iDeliveredSessionsPerDay <> 0
	BEGIN
		SET @iTotalDays = ((@iTotalSessions * @nDeliveryDayGap)/ @iDeliveredSessionsPerDay )
	END

	UPDATE dbo.T_Course_Delivery_Map SET 
	N_Course_Duration = @iTotalDays,
	S_Upd_By = @sCreatedBy,
	Dt_Upd_On = @dCreatedOn
	WHERE I_Course_Delivery_ID = @iCourseDeliveryID
	--END

	WHILE ( @iCount <= @iMax )
	BEGIN
		SET @iCourseCenterID = 0

		SELECT @iCourseCenterID = A.I_Course_Center_ID
		FROM dbo.T_Course_Center_Detail A, #tempCenter B WITH(NOLOCK)
		WHERE A.I_Centre_Id = B.centerID
		AND A.I_Course_ID = @iCourseID
		AND B.seq = @iCount
		AND A.I_Status = 1
		AND GETDATE() >= ISNULL(A.Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())

		IF @iCourseCenterID <> 0
			BEGIN
				UPDATE dbo.T_Course_Center_Detail SET 
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dCreatedOn
				WHERE I_Course_Center_ID = @iCourseCenterID
			END
		ELSE
			BEGIN
				INSERT INTO T_Course_Center_Detail
				( 
					I_Centre_Id,
					I_Course_ID,
					S_Crtd_By,
					Dt_Valid_From,
					Dt_Crtd_On,
					I_Status 
				)
				SELECT 
				A.centerID,
				@iCourseID,
				@sCreatedBy,
				@dCreatedOn,
				@dCreatedOn,
				1
				FROM #tempCenter A
				WHERE A.seq = @iCount

				SELECT @iCourseCenterID = @@IDENTITY
			END

		SET @iExistingFeePlanID = 0

		SELECT @iExistingFeePlanID = I_Course_Center_Delivery_ID
		FROM dbo.T_Course_Center_Delivery_FeePlan
		WHERE I_Course_Delivery_ID = @iCourseDeliveryID
		AND I_Course_Center_ID = @iCourseCenterID
		AND I_Course_Fee_Plan_ID = @iFeePlanID
		AND I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())

		IF @iExistingFeePlanID > 0
			BEGIN
				UPDATE dbo.T_Course_Center_Delivery_FeePlan SET 
				I_Status = 0,
				Dt_Valid_To = @dCreatedOn
				WHERE I_Course_Center_Delivery_ID = @iExistingFeePlanID
			END

		INSERT INTO T_Course_Center_Delivery_FeePlan
		( 
			I_Course_Delivery_ID,
			I_Course_Center_ID,
			I_Course_Fee_Plan_ID,
			Dt_Valid_From,
			I_Status 
		)
		VALUES
		( 
			@iCourseDeliveryID,
			@iCourseCenterID,
			@iFeePlanID,
			@dCreatedOn,
			1
		)

		SET @iCount = @iCount + 1
	END

	DROP TABLE #tempCenter

COMMIT TRAN T1
END TRY

BEGIN CATCH
--Error occurred:
	ROLLBACK  TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
