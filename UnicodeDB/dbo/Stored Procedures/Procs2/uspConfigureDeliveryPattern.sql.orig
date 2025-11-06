CREATE PROCEDURE [dbo].[uspConfigureDeliveryPattern] 
(
	 @iCourseID int,
	 @sUpdatedBy varchar(50),
	 @dUpdatedOn datetime,
	 @sDeliveryPatternIdList varchar(1000)
)

AS
BEGIN TRY

	SET NOCOUNT ON

	DECLARE @iNCourseDuration_CDM numeric(18,0)
	DECLARE @iNoOfSession_CM int
	DECLARE @iNoOfSession_DPM int
	DECLARE @iSessionDayGap_DPM int

	BEGIN TRANSACTION
	UPDATE dbo.T_Course_Master
	SET S_Upd_By=@sUpdatedBy,
		Dt_Upd_On=@dUpdatedOn
	WHERE I_Course_ID=@iCourseID

	Create TABLE #DROPDELIVERYMAP
	(
		I_Delivery_Pattern_ID INT
	)

	SET @iNoOfSession_CM=ISNULL((SELECT I_No_Of_Session FROM dbo.T_Course_Master WHERE I_Course_ID=@iCourseID),0)
	--SELECT @iNoOfSession_CM
		DECLARE @iDeliveryPatternID varchar(10), @iPos int

		SET @sDeliveryPatternIdList = LTRIM(RTRIM(@sDeliveryPatternIdList))+ ','
		SET @iPos = CHARINDEX(',', @sDeliveryPatternIdList, 1)

		IF REPLACE(@sDeliveryPatternIdList, ',', '') <> ''
			--BEGIN TRANSACTION
			WHILE @iPos > 0
				BEGIN
					SET @iDeliveryPatternID = LTRIM(RTRIM(LEFT(@sDeliveryPatternIdList, @iPos - 1)))
					IF @iDeliveryPatternID <> ''
						BEGIN
							DECLARE @iCourseDeliveryID int,
									@iDelPatternId int,
									@fValue float

							INSERT INTO #DROPDELIVERYMAP VALUES(CAST(@iDeliveryPatternID AS int))

							IF NOT EXISTS(SELECT 'TRUE' FROM dbo.T_Course_Delivery_Map WHERE I_Delivery_Pattern_ID=CAST(@iDeliveryPatternID AS int) AND I_Course_ID=@iCourseID AND I_Status <> 0) 
							BEGIN
								INSERT INTO dbo.T_Course_Delivery_Map (I_Delivery_Pattern_ID,I_Course_ID,S_Crtd_By,Dt_Crtd_On,I_Status) 
								VALUES (CAST(@iDeliveryPatternID AS int),@iCourseID,@sUpdatedBy,@dUpdatedOn,1) --Use Appropriate conversion
								
								SET @iCourseDeliveryID=@@IDENTITY
								SET @iDelPatternId=CONVERT(int,@iDeliveryPatternID)
								--Calculate N_Course_Duration
								SET @iNoOfSession_DPM=ISNULL((SELECT I_No_Of_Session FROM dbo.T_Delivery_Pattern_Master WHERE I_Delivery_Pattern_ID=@iDelPatternId),0 )
								SET @iSessionDayGap_DPM=ISNULL((SELECT N_Session_Day_Gap FROM dbo.T_Delivery_Pattern_Master WHERE I_Delivery_Pattern_ID=@iDelPatternId),0 )
								IF (@iNoOfSession_DPM <> 0 and @iNoOfSession_CM<>0)
								BEGIN
									
									SET @fValue = (CONVERT(float,@iNoOfSession_CM))/(CONVERT(float,@iNoOfSession_DPM))
									SET @iNCourseDuration_CDM=CONVERT(numeric,((CEILING(@fValue)*@iSessionDayGap_DPM)-1))
									UPDATE dbo.T_Course_Delivery_Map 
									SET N_Course_Duration=@iNCourseDuration_CDM
									WHERE I_Delivery_Pattern_ID=@iDelPatternId
									AND I_Course_ID=@iCourseID AND I_Status=1
								END

								
							END
						END

						SET @sDeliveryPatternIdList = RIGHT(@sDeliveryPatternIdList, LEN(@sDeliveryPatternIdList) - @iPos)
						SET @iPos = CHARINDEX(',', @sDeliveryPatternIdList, 1)

				END

				UPDATE dbo.T_Course_Delivery_Map
				SET	S_Upd_By = @sUpdatedBy,
				Dt_Upd_On = @dUpdatedOn,
				I_Status = 0
				WHERE I_Course_ID = @iCourseID
				AND I_Status = 1 AND I_Delivery_Pattern_ID NOT IN ( SELECT I_Delivery_Pattern_ID FROm #DROPDELIVERYMAP)

				DROP TABLE #DROPDELIVERYMAP	

				COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
