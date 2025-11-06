CREATE PROCEDURE [dbo].[uspAddExtraHOSession]     
(    
 @iBatchScheduleID INT,    
 @iBatchId INT,    
 @TermID INT,    
 @iModuleID INT,    
 @SessionID INT = NULL,    
 @sSessionName VARCHAR(500),    
 @sSessionTopic VARCHAR(500),    
 @dtScheduledDate DATETIME,    
 @dtActualDate DATETIME,    
 @iEmployeeID INT,    
 @iIsComplete INT   
)    
AS    
BEGIN TRY    
DECLARE @iCenterID INT = NULL 
  
IF @iBatchScheduleID = 0    
 BEGIN  
     
  --DECLARE dbCursor CURSOR  FOR   
  -- SELECT I_Centre_Id FROM dbo.T_Center_Batch_Details   
  -- WHERE I_Batch_ID = @iBatchId  
     
  --  OPEN dbCursor  
      
  --  FETCH NEXT FROM dbCursor  
  --  INTO @iCenterID  
      
  --  WHILE @@FETCH_STATUS = 0  
      
  --    BEGIN  
    INSERT INTO dbo.T_Student_Batch_Schedule (    
     I_Batch_ID,    
     I_Centre_ID,    
     I_Term_ID,    
     I_Module_ID,    
     I_Session_ID,    
     S_Session_Name,    
     S_Session_Topic,  
     Dt_Schedule_Date,  
     Dt_Actual_Date,  
     I_Employee_ID,  
     I_Is_Complete    
    ) VALUES (     
     @iBatchId,    
     @iCenterID,    
     @TermID,    
     @iModuleID,    
     @SessionID,    
     @sSessionName,    
     @sSessionTopic,  
     @dtScheduledDate,  
     @dtActualDate,  
     @iEmployeeID,  
     @iIsComplete)     
     
  --  FETCH NEXT FROM dbCursor INTO @iCenterID  
  -- END  
  --CLOSE  dbCursor  
  --DEALLOCATE dbCursor  
    
  SET @iBatchScheduleID = @@IDENTITY    
    
 END    
   
 SELECT @iBatchScheduleID    
END TRY    
BEGIN CATCH    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
