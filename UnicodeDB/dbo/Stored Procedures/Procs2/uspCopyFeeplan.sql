/****************************************************************
Description : Copies feeplans from origin to destination center
Author	:     Swagatam Sarkar
Date	:	  12-Mar-2008
****************************************************************/

CREATE PROCEDURE [dbo].[uspCopyFeeplan] --1,273
(
	@iOriginCenterID int,
	@iDestinationCenterID int
)

AS

BEGIN TRY 
BEGIN TRANSACTION
DECLARE @tmpFeeplan TABLE 
(
	I_Course_ID int,
	I_Course_Delivery_ID int,
	I_Course_Fee_Plan_ID int,
	Dt_Valid_From datetime,
	Dt_Valid_To datetime,
	I_Status int
)

INSERT INTO @tmpFeeplan
(I_Course_ID, I_Course_Delivery_ID, I_Course_Fee_Plan_ID, Dt_Valid_From, Dt_Valid_To, I_Status)
(
	SELECT CDM.I_Course_ID,CCDF.I_Course_Delivery_ID, CCDF.I_Course_Fee_Plan_ID, 
		   CCDF.Dt_Valid_From, CCDF.Dt_Valid_To, CCDF.I_Status
	FROM dbo.T_Course_Center_Delivery_FeePlan CCDF
	INNER JOIN dbo.T_Course_Delivery_Map CDM
	ON CDM.I_Course_Delivery_ID = CCDF.I_Course_Delivery_ID
	WHERE I_Course_Center_ID IN
	(
		SELECT I_Course_Center_ID FROM dbo.T_Course_Center_Detail
		WHERE I_Course_ID IN
		(
			SELECT I_Course_ID FROM dbo.T_Course_Center_Detail
			WHERE I_Centre_Id = @iDestinationCenterID and I_Status <> 0 
			AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		)
		and I_Centre_Id = @iOriginCenterID
		AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		and I_Status <> 0
	)
)

DECLARE @tmpCCDF TABLE 
(
	I_Course_Delivery_ID int,
	I_Course_Center_ID int,
	I_Course_Fee_Plan_ID int,
	Dt_Valid_From datetime,
	Dt_Valid_To datetime,
	I_Status int
)

INSERT INTO @tmpCCDF
(I_Course_Delivery_ID,I_Course_Center_ID,I_Course_Fee_Plan_ID,
 Dt_Valid_From,Dt_Valid_To,I_Status)
(
	SELECT tmp.I_Course_Delivery_ID, ccd.I_Course_Center_ID,
	tmp.I_Course_Fee_Plan_ID, tmp.Dt_Valid_From,
	tmp.Dt_Valid_To, tmp.I_Status FROM @tmpFeeplan tmp
	INNER JOIN dbo.T_Course_Center_Detail ccd
	ON tmp.I_Course_ID = ccd.I_Course_ID
	AND ccd.I_Centre_Id = @iDestinationCenterID
	AND ccd.I_Status <> 0
)

SELECT * FROM @tmpCCDF

DECLARE @iCourseDeliveryID INT
DECLARE @iCourseCenterID INT
DECLARE @iCourseFeePlanID INT
DECLARE @iDtValidFrom DATETIME
DECLARE @iDtValidTo DATETIME
DECLARE @iStatus INT

DECLARE CourseCenterFeeplan CURSOR FOR
SELECT I_Course_Delivery_ID,I_Course_Center_ID,I_Course_Fee_Plan_ID,Dt_Valid_From,Dt_Valid_To,I_Status FROM @tmpCCDF

OPEN CourseCenterFeeplan
FETCH NEXT FROM CourseCenterFeeplan INTO @iCourseDeliveryID,@iCourseCenterID,@iCourseFeePlanID,@iDtValidFrom,@iDtValidTo,@iStatus

WHILE @@FETCH_STATUS = 0
BEGIN

	IF NOT EXISTS (SELECT * FROM T_Course_Center_Delivery_FeePlan 
					WHERE I_Course_Center_ID = @iCourseCenterID
					AND I_Course_Fee_Plan_ID = @iCourseFeePlanID)
	BEGIN
		INSERT INTO T_Course_Center_Delivery_FeePlan
		(I_Course_Delivery_ID,I_Course_Center_ID,I_Course_Fee_Plan_ID,Dt_Valid_From,Dt_Valid_To,I_Status)
		VALUES
		(@iCourseDeliveryID,@iCourseCenterID,@iCourseFeePlanID,@iDtValidFrom,@iDtValidTo,@iStatus)
	END

	FETCH NEXT FROM CourseCenterFeeplan INTO @iCourseDeliveryID,@iCourseCenterID,@iCourseFeePlanID,@iDtValidFrom,@iDtValidTo,@iStatus

	END
	
CLOSE CourseCenterFeeplan
DEALLOCATE CourseCenterFeeplan
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
