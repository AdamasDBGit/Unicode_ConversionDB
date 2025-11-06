CREATE PROCEDURE [dbo].[uspUpdateTimeTable]
    (
      @iTimeTableID INT ,
      @dtActualDate DATETIME ,
      @iIsComplete INT
    )
AS 
    BEGIN TRY   
        UPDATE  dbo.T_TimeTable_Master
        SET     Dt_Actual_Date = @dtActualDate ,
                I_Is_Complete = @iIsComplete,
                Dt_Updt_On=GETDATE()
        WHERE   I_TimeTable_ID = @iTimeTableID  
        
        IF(SELECT COUNT(*) FROM dbo.T_TimeTable_Faculty_Map WHERE I_TimeTable_ID = @iTimeTableID AND B_Is_Actual = 1) = 0
        BEGIN
			INSERT INTO dbo.T_TimeTable_Faculty_Map
			SELECT @iTimeTableID,I_Employee_ID,1 FROM dbo.T_TimeTable_Faculty_Map AS TTTFM WHERE I_TimeTable_ID = @iTimeTableID AND B_Is_Actual = 0
        END
        
    END TRY        
    BEGIN CATCH        
        DECLARE @ErrMsg NVARCHAR(max) ,
            @ErrSeverity INT        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()        
        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)        
    END CATCH

