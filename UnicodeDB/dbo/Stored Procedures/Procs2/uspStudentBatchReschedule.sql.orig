CREATE PROCEDURE [dbo].[uspStudentBatchReschedule] -- 258,'2011-09-09 00:00:00.000',NULL,'',''
(          
 @iBatchID INT ,          
 @dtStartDate DATETIME,
 @dtEndDate DATETIME,
 @sComment VARCHAR(100),
 @sCreatedBy VARCHAR(50)
)          
          
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 SET NOCOUNT ON         
    DECLARE @dtCurrentDate DATETIME       
          
    SET @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())        
          
 --SELECT * FROM dbo.T_Student_Batch_Schedule
 --WHERE I_Batch_ID=@iBatchID AND Dt_Schedule_Date >= @dtStartDate    
 
 DELETE FROM dbo.T_Student_Batch_Schedule WHERE I_Batch_ID=@iBatchID AND Dt_Schedule_Date >= @dtStartDate    
 
 INSERT INTO dbo.T_Batch_Deferment_Details
         ( 
           I_Batch_ID ,
           Dt_Batch_Hold_Start_Date ,
           Dt_Batch_Hold_End_Date ,
           Dt_Crtd_On ,
           S_Crtd_By
         )
 VALUES  ( 
           @iBatchID , -- I_Batch_ID - int
           @dtStartDate , -- Dt_Batch_Hold_Start_Date - datetime
           @dtEndDate , -- Dt_Batch_Hold_End_Date - datetime
           @dtCurrentDate , -- Dt_Crtd_On - datetime
           @sCreatedBy  -- S_Crtd_By - varchar(20)
         )
    
    
END
