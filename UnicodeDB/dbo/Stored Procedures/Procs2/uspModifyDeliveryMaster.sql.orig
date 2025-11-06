-- =============================================
-- Author:		<AMITAVA CHOUDHURY>
-- Create date: <12-01-2007>
-- Description:	<TO MODIFY DELIVERY MASTER>
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyDeliveryMaster]
	-- Add the parameters for the stored procedure here
	@iDeliveryID int,
	@sPatternName varchar(50) = null,
	@iNoOfSession int = null,	
	@nSessionDayGap numeric(8,2) = null,
	@sDaysOfWeek VARCHAR(50),
	@sPatternBy varchar(20),
	@dDeliveryOn datetime,
    @iFlag int

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

    -- Insert statements for procedure here
	IF @iFlag = 1
	BEGIN
		BEGIN TRAN T1
		
			INSERT INTO dbo.T_Delivery_Pattern_Master
			(S_Pattern_Name, 
			 I_No_Of_Session, 
			 N_Session_Day_Gap, 
			 S_DaysOfWeek,
			 S_Crtd_By,
			 Dt_Crtd_On,
			 I_Status)
			VALUES
			(@sPatternName, 
			 @iNoOfSession,
			 @nSessionDayGap,
			 @sDaysOfWeek,
			 @sPatternBy,
			 @dDeliveryOn,
			 1)   
			 
			SET @iDeliveryID = @@IDENTITY	
			 
		COMMIT TRAN T1	 
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Delivery_Pattern_Master
		SET S_Pattern_Name = @sPatternName,
		I_No_Of_Session = @iNoOfSession,
		N_Session_Day_Gap = @nSessionDayGap,
		S_DaysOfWeek = @sDaysOfWeek,
		S_Upd_By=@sPatternBy,
		Dt_Upd_On = @dDeliveryOn
		where I_Delivery_Pattern_ID = @iDeliveryID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Delivery_Pattern_Master
		SET I_Status = 0,
		S_Upd_By=@sPatternBy,
		Dt_Upd_On = @dDeliveryOn
		where I_Delivery_Pattern_ID = @iDeliveryID
	END
	
	SELECT @iDeliveryID DeliveryPatternID
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
