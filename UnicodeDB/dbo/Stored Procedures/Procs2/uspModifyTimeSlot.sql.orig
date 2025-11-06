-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Center Time Slot table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyTimeSlot] 
(
	@iCenterID int,
	@iTimeSlotID int,
	@sTimeSlotCode varchar(20),    
	@sTimeSlotDesc varchar(50),   
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Center_TimeSlot   
		( I_Centre_Id,S_TimeSlot_Code,S_TimeSlot_Desc,
		  I_Status,S_Crtd_By,Dt_Crtd_On)
		VALUES
		(@iCenterID,@sTimeSlotCode,@sTimeSlotDesc,
		 1,@sCreatedBy,@dtCreatedOn)
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Center_TimeSlot
		SET I_Centre_Id = @iCenterID,
			S_TimeSlot_Code = @sTimeSlotCode,
			S_TimeSlot_Desc = @sTimeSlotDesc,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dtCreatedOn
		WHERE I_TimeSlot_ID = @iTimeSlotID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Center_TimeSlot
		SET I_Status = 0,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dtCreatedOn
		WHERE I_TimeSlot_ID = @iTimeSlotID
	END

END TRY


BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
