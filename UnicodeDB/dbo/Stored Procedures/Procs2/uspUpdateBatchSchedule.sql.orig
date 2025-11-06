CREATE PROCEDURE [dbo].[uspUpdateBatchSchedule] 
(
	@iBatchScheduleID INT,
	@sBatchScheduleIDList VARCHAR(MAX) = NULL,
	@iBatchId INT,
	@TermID INT,
	@iModuleID INT,
	@SessionID INT = NULL,
	@sSessionName VARCHAR(500),
	@sSessionTopic VARCHAR(500),
	@dtScheduledDate DATETIME,
	@dtActualDate DATETIME,
	@iEmployeeID INT,
	@iIsComplete INT,
	@iCenterID INT
)
AS
BEGIN TRY      
IF @sBatchScheduleIDList IS NULL    
BEGIN    
 IF @iBatchScheduleID = 0      
  BEGIN    
    INSERT INTO dbo.T_Student_Batch_Schedule (      
     I_Batch_ID,      
     I_Centre_ID,      
     I_Term_ID,      
     I_Module_ID,      
     I_Session_ID,      
     S_Session_Name,      
     S_Session_Topic      
    ) VALUES (       
     /* I_Batch_ID - int */ @iBatchId,      
     @iCenterID,      
     /* I_Term_ID - int */ @TermID,      
     /* I_Module_ID - int */ @iModuleID,      
     /* I_Session_ID - int */ @SessionID,      
     /* S_Session_Name - varchar(500) */ @sSessionName,      
     /* S_Session_Topic - varchar(500) */ @sSessionTopic)       
    SET @iBatchScheduleID = @@IDENTITY      
  END      
  UPDATE dbo.T_Student_Batch_Schedule       
  SET Dt_Schedule_Date = @dtScheduledDate,Dt_Actual_Date = @dtActualDate,I_Employee_ID = @iEmployeeID,I_Is_Complete = @iIsComplete      
  WHERE I_Batch_Schedule_ID = @iBatchScheduleID      
END     
ELSE    
 BEGIN    
  DECLARE @sqlquery VARCHAR(MAX)    
  SET @sqlquery = 'UPDATE dbo.T_Student_Batch_Schedule       
  SET Dt_Schedule_Date ='''+ CAST(@dtScheduledDate AS VARCHAR(100))+''',Dt_Actual_Date ='''+ CAST(@dtActualDate AS VARCHAR(100))+''',I_Employee_ID ='+     
  CAST(@iEmployeeID AS VARCHAR(100))+',I_Is_Complete ='+ CAST(@iIsComplete AS VARCHAR(5)) + 'WHERE I_Batch_Schedule_ID IN  ('+@sBatchScheduleIDList+')'    
  --PRINT(@sqlquery)    
  EXEC(@sqlquery)     
 END    
 SELECT @iBatchScheduleID        
     
END TRY      
BEGIN CATCH      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
