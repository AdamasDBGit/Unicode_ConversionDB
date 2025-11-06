CREATE PROCEDURE [dbo].[uspModifyCurrencyRate] 
(
	@iCurrencyRateID INT,
	@iCurrencyID INT,
	@iConversionRate NUMERIC(14,2),
	@dStartDate DATETIME,
	@dEndDate DATETIME,
    @sCurrencyBy VARCHAR(20),
	@dCurrencyOn DATETIME,
    @iFlag INT
)
AS 
BEGIN TRY
	
	SET NOCOUNT ON
DECLARE @DtCurrentDate DATETIME
SET @DtCurrentDate = CAST(CAST(GETDATE() AS VARCHAR(11)) AS DATETIME)

    IF @iFlag = 1
	BEGIN


	IF EXISTS(SELECT ISNULL(MAX(Dt_Effective_End_Date),GETDATE()) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status<>0)
	BEGIN
		IF  EXISTS(SELECT  * FROM t_currency_rate
					WHERE I_Currency_ID=@iCurrencyID
					AND @dStartDate >ISNULL((SELECT MAX(Dt_Effective_End_Date) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status<>0),'1/1/2002')
					AND @dEndDate >ISNULL((SELECT MAX(Dt_Effective_End_Date) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status<>0),'1/1/2002'))
			BEGIN
   
    IF (@dStartDate >= @DtCurrentDate)
		BEGIN
			INSERT INTO dbo.T_Currency_Rate(I_Currency_ID, N_Conversion_Rate, Dt_Effective_Start_Date, Dt_Effective_End_Date, I_Status, S_Crtd_By, Dt_Crtd_On)
			VALUES(@iCurrencyID, @iConversionRate, @dStartDate, @dEndDate, 1, @sCurrencyBy, @dCurrencyOn)    

	END 
			END
	END
	IF NOT EXISTS(SELECT MAX(Dt_Effective_End_Date) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status<>0)
	BEGIN			
		IF (@dStartDate >= @DtCurrentDate)
		BEGIN
		INSERT INTO dbo.T_Currency_Rate(I_Currency_ID, N_Conversion_Rate, Dt_Effective_Start_Date, Dt_Effective_End_Date, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@iCurrencyID, @iConversionRate, @dStartDate, @dEndDate, 1, @sCurrencyBy, @dCurrencyOn)    
			
	    END			
	END
IF NOT EXISTS(SELECT 'True' FROM t_currency_rate WHERE I_Currency_ID=ISNULL(@iCurrencyID,0) AND i_status<>0)
	BEGIN			
		IF (@dStartDate >= @DtCurrentDate)
		BEGIN
		INSERT INTO dbo.T_Currency_Rate(I_Currency_ID, N_Conversion_Rate, Dt_Effective_Start_Date, Dt_Effective_End_Date, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@iCurrencyID, @iConversionRate, @dStartDate, @dEndDate, 1, @sCurrencyBy, @dCurrencyOn)    
			
	    END 
	END
	END
	ELSE IF @iFlag = 2
	BEGIN

DECLARE @dStartDateTemp DATETIME
DECLARE @dEndDateTemp DATETIME
DECLARE @I_Currency_Rate_ID INT
DECLARE @DayDiff INT

SELECT @dStartDateTemp=MAX(Dt_Effective_Start_Date) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status <>0
SELECT @dEndDateTemp=MAX(Dt_Effective_End_Date) FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status <>0

IF @dEndDateTemp IS NOT NULL
BEGIN
	IF @dEndDate > @dStartDate 
	BEGIN
		IF @dStartDateTemp < @dStartDate
		BEGIN
			IF @dStartDate < @dEndDateTemp
			BEGIN
				SELECT @I_Currency_Rate_ID=I_Currency_Rate_ID FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status <>0 AND Dt_Effective_Start_Date=@dStartDateTemp
				UPDATE dbo.T_Currency_Rate
				SET Dt_Effective_End_Date = (CAST(@dStartDate AS DATETIME) - 1) WHERE I_Currency_Rate_ID=@I_Currency_Rate_ID
				
				INSERT INTO dbo.T_Currency_Rate(I_Currency_ID, N_Conversion_Rate, Dt_Effective_Start_Date, Dt_Effective_End_Date, I_Status, S_Crtd_By, Dt_Crtd_On)
				VALUES(@iCurrencyID, @iConversionRate, @dStartDate, @dEndDate, 1, @sCurrencyBy, @dCurrencyOn)  

			END
			ELSE
			BEGIN

				INSERT INTO dbo.T_Currency_Rate(I_Currency_ID, N_Conversion_Rate, Dt_Effective_Start_Date, Dt_Effective_End_Date, I_Status, S_Crtd_By, Dt_Crtd_On)
				VALUES(@iCurrencyID, @iConversionRate, @dStartDate, @dEndDate, 1, @sCurrencyBy, @dCurrencyOn)

			END
		END
		ELSE IF @dStartDateTemp = @dStartDate
		BEGIN
			SELECT @I_Currency_Rate_ID=I_Currency_Rate_ID FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status <>0 AND Dt_Effective_Start_Date=@dStartDateTemp
			UPDATE dbo.T_Currency_Rate
			SET Dt_Effective_End_Date = @dEndDate,N_Conversion_Rate = @iConversionRate  WHERE I_Currency_Rate_ID=@I_Currency_Rate_ID
		END
	END
END
IF @dEndDateTemp IS NULL
BEGIN 
			SELECT @I_Currency_Rate_ID=I_Currency_Rate_ID FROM t_currency_rate WHERE I_Currency_ID=@iCurrencyID AND i_status <>0 AND Dt_Effective_Start_Date=@dStartDateTemp
			UPDATE dbo.T_Currency_Rate
			SET Dt_Effective_End_Date = @dEndDate,N_Conversion_Rate = @iConversionRate  WHERE I_Currency_Rate_ID=@I_Currency_Rate_ID
		
END
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Currency_Rate
		SET I_Status = 0,
		S_Upd_By = @sCurrencyBy,
		Dt_Upd_On = @dCurrencyOn
		WHERE I_Currency_Rate_ID = @iCurrencyRateID
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
