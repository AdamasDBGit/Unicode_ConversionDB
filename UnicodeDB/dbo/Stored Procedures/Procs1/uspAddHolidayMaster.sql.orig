CREATE PROCEDURE [dbo].[uspAddHolidayMaster]
(
	@iBrandId INT,	
	@iCenterId INT,
	@dtHolidayDt DATETIME,
	@sHolidayDesc VARCHAR(200)
)
AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	INSERT INTO T_Holiday_Master
        ( I_Brand_ID ,
          I_Center_ID ,
          Dt_Holiday_Date ,
          S_Holiday_Description
        )
VALUES  ( @iBrandId , -- I_Brand_ID - int
          @iCenterId , -- I_Center_ID - int
          @dtHolidayDt , -- Dt_Holiday_Date - datetime
          @sHolidayDesc  -- S_Holiday_Description - varchar(200)
        )
	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
