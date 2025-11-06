CREATE PROCEDURE [dbo].[uspCreateTimeSlotForBatch]         
(           
  @sTimeSlotCode VARCHAR(50) = NULL,  
  @DtStartTime datetime,   
  @DtEndTime datetime,         
  @sCreatedBy VARCHAR(500),  
  @dtCreatedOn DATETIME,
  @DtPeriodInterval datetime,
  @DtBreakStartTime datetime,
  @DtBreakEndTime datetime  
)          
AS          
BEGIN TRY   
INSERT INTO dbo.T_TimeSlot_Master  
        ( S_TimeSlot_Code ,  
          Dt_StartTime ,  
          Dt_EndTime ,
          Dt_BreakStartTime ,
          Dt_BreakEndTime,  
          Dt_PeriodInterval,   
          S_Crtd_By ,  
          Dt_Crtd_On                  
        )  
VALUES  ( @sTimeSlotCode , -- S_TimeSlot_Code - varchar(50)  
          @DtStartTime , -- Dt_StartTime - datetime  
          @DtEndTime , -- Dt_EndTime - datetime
          @DtBreakStartTime ,
          @DtBreakEndTime,
          @DtPeriodInterval,  
          @sCreatedBy , -- Dt_Crtd_On - datetime  
          @dtCreatedOn  -- Dt_Upd_On - datetime 
        )  
  
SELECT @@IDENTITY FROM dbo.T_TimeSlot_Master  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
