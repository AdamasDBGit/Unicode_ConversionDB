CREATE PROCEDURE [dbo].[uspCreateCenterTimeSlot]       
(         
  @sTimeSlotCode Nnvarchar(max),
  @sTimeSlotDesc Nnvarchar(max),        
  @sCreatedBy Nnvarchar(max),
  @dtCreatedOn DATETIME
)        
AS        
BEGIN TRY
INSERT INTO dbo.T_Center_TimeSlot (
	I_Centre_Id,
	S_TimeSlot_Code,
	S_TimeSlot_Desc,
	I_Status,
	S_Crtd_By,
	Dt_Crtd_On
) VALUES ( 
	NULL,
	@sTimeSlotCode,
	@sTimeSlotDesc,
	1,
	@sCreatedBy,
	@dtCreatedOn) 
SELECT @@IDENTITY FROM dbo.T_Center_TimeSlot
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

