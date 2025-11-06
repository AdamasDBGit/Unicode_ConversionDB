CREATE PROCEDURE [ACADEMICS].[uspSaveStudentAttendance]
(    
 @iTimeTableID INT,  
 @sStudentsList VARCHAR(MAX),  
 @sCrtdBy VARCHAR(20),  
 @dtCrtdOn DATETIME   
)    
AS    
    
BEGIN TRY     
   
  SELECT CAST(Val AS INT) AS Val INTO #TempTable FROM dbo.fnString2Rows(@sStudentsList,',')  
  
  DELETE FROM #TempTable WHERE   Val IN  
  (  
   --SELECT SAD.I_Attendance_Detail_ID
   SELECT SAD.I_Student_Detail_ID--akash
   FROM dbo.T_Student_Attendance SAD  
   INNER JOIN dbo.T_TimeTable_Master SBS  ON SBS.I_TimeTable_ID=SAD.I_TimeTable_ID
											   --AND  SBS.I_Term_ID = SAD.I_Term_ID  
											   --AND SBS.I_Module_ID = SAD.I_Module_ID  
											   --AND SBS.I_Session_ID = SAD.I_Session_ID  
   WHERE SBS.I_TimeTable_ID = @iTimeTableID  
  )  
  
 --IF (
 --(select CONVERT(DATE,DATEADD(DAY,2,ISNULL(Dt_Actual_Date,Dt_Schedule_Date))) from T_TimeTable_Master where I_TimeTable_ID=@iTimeTableID) <= CONVERT(DATE,GETDATE())
 --and 
 --((SELECT Top 1 TCHND.I_Brand_ID FROM dbo.T_TimeTable_Master TTTM
 -- INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
 -- WHERE TTTM.I_TimeTable_ID=@iTimeTableID) = 109
 --)
 --) --added by susmita Paul : 2023-Dec-08:Attendence Restrict If day has crossed D+2 on Attendence Day
 --BEGIN

			  INSERT INTO dbo.T_Student_Attendance (  
			   I_Student_Detail_ID,  
			   I_TimeTable_ID,  
			   S_Crtd_By,  
			   Dt_Crtd_On  
			  )   
			  SELECT Val,@iTimeTableID,@sCrtdBy,@dtCrtdOn    
			  FROM #TempTable    
  
  --END --added by susmita Paul : 2023-Dec-08:Attendence Restrict If day has crossed D+2 on Attendence Day

   
  DROP TABLE #TempTable 
  --akash
  
  DECLARE @BatchID INT;
  DECLARE @SchDate DATE;
  DECLARE @BrandID INT;
  
  SET @BrandID=(SELECT TCHND.I_Brand_ID FROM dbo.T_TimeTable_Master TTTM
  INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
  WHERE TTTM.I_TimeTable_ID=@iTimeTableID)
  SET @BatchID=(SELECT I_Batch_ID FROM dbo.T_TimeTable_Master WHERE I_TimeTable_ID=@iTimeTableID)
  SET @SchDate=(SELECT Dt_Schedule_Date FROM dbo.T_TimeTable_Master WHERE I_TimeTable_ID=@iTimeTableID)
  
  IF(@BrandID=107)
  BEGIN
  EXEC dbo.uspInsertAttendanceDataForEntireDay @iBatchID = @BatchID, -- int
      @dtScheduleDate = @SchDate, -- date
      @sCrtdBy = @sCrtdBy, -- varchar(20)
      @dtCrtd = @dtCrtdOn -- datetime
      
      END
  
   --akash
    
END TRY    
    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
