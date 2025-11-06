CREATE PROCEDURE [dbo].[uspCreateTimeSlotForBatch]         
(           
  @sTimeSlotCode Nnvarchar(max) = NULL,  
  @DtStartTime datetime,   
  @DtEndTime datetime,         
  @sCreatedBy Nnvarchar(max),  
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
VALUES  ( @sTimeSlotCode , -- S_TimeSlot_Code - nvarchar(max)  
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
  
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

