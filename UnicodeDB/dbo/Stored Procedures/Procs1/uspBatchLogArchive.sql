CREATE PROCEDURE [dbo].[uspBatchLogArchive]    
    
AS    
BEGIN    
   
DECLARE @ArchiveDays VARCHAR(50)    
    
SELECT @ArchiveDays = S_Config_Value    
FROM dbo.T_Center_Configuration      
WHERE I_Status = 1 AND S_Config_Code='BATCH_LOG_ARCHIVE_DAYS'

IF (@ArchiveDays IS NULL OR @ArchiveDays = 0)
	SET @ArchiveDays = 7

DELETE FROM dbo.T_Batch_Log WHERE DATEDIFF(DAY,Dt_Run_Date_Time,GETDATE())>=@ArchiveDays
    
END
