CREATE PROCEDURE [ACADEMICS].[uspModifyStudentAcademicDropoutStatus]  
AS  
  
BEGIN TRY  
BEGIN TRAN T1  
  
 SET NOCOUNT ON;  
  
 Declare @I_Process_ID_Max Int  
 Declare @Comments Varchar(2000)  
 Declare @Center_Name Varchar(500)  
 Declare @Student_Name Varchar(500)  
 DECLARE @iCenterID INT  
 DECLARE @iPreviousCourseID INT  
 DECLARE @iStudentID INT  
 DECLARE @iAllowableNonAttendedDays INT  
 DECLARE @iStatus INT  
 DECLARE @cAcademicDropout CHAR(1)  
 DECLARE @iCourseID INT  
 DECLARE @iBatchID INT  
 DECLARE @dDate DATETIME  
  
 SET @iPreviousCourseID=0  
 SET @dDate=CAST(SUBSTRING(CAST(GETDATE() AS VARCHAR),1,11) as datetime)  
  
 Declare @S_Batch_Process_Name VARCHAR(500)  
   
 DECLARE @tblDropoutStudent TABLE(I_Student_Detail_ID INT, I_Center_ID INT, I_Course_ID INT, I_Batch_ID INT)  
 DECLARE @tblReactivatedStudent TABLE(I_Student_Detail_ID INT, I_Center_ID INT, I_Course_ID INT, I_Batch_ID INT)  
   
 SET @S_Batch_Process_Name='STUDENT_ACADEMICS_DROPOUT'  
    
 Declare @I_Batch_Process_ID Int  
 Select @I_Batch_Process_ID=I_Batch_Process_ID From dbo.T_Batch_Master WITH (NOLOCK) Where S_Batch_Process_Name='STUDENT_ACADEMIC_DROPOUT' And I_Status=1  
   
 SET @cAcademicDropout = ''  
 SET @iAllowableNonAttendedDays = 0  
   
 DECLARE @tblList TABLE (ID INT IDENTITY(1,1),I_Student_Detail_ID INT,I_Centre_Id INT, I_Course_ID INT, I_Batch_ID INT)  
   
 INSERT INTO @tblList  
 SELECT DISTINCT SCD.I_Student_Detail_ID,  
   SCD.I_Centre_Id,  
   tsbm.I_Course_ID,  
   tsbm.I_Batch_ID  
 FROM    dbo.T_Student_Center_Detail SCD WITH ( NOLOCK )  
   INNER JOIN dbo.T_Student_Batch_Details AS tsbd   
   ON tsbd.I_Student_ID = SCD.I_Student_Detail_ID  
   INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID  
   INNER JOIN [T_Brand_Center_Details] BCD WITH ( NOLOCK ) ON BCD.I_Centre_Id = SCD.I_Centre_Id  
   INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON tcbd.I_Centre_Id = SCD.I_Centre_Id AND tcbd.I_Batch_ID = tsbd.I_Batch_ID  
 WHERE   SCD.I_Status = 1  
   AND BCD.I_Status=1  
   AND DATEDIFF(dd,ISNULL(SCD.Dt_Valid_From,GETDATE()),GETDATE()) >= 0  
   AND DATEDIFF(dd,ISNULL(SCD.Dt_Valid_To,GETDATE()),GETDATE()) <= 0  
   AND DATEDIFF(dd,ISNULL(tsbd.Dt_Valid_From,GETDATE()),GETDATE()) >= 0     
   AND SCD.I_Student_Detail_ID NOT IN  
   (SELECT I_Student_Detail_ID FROM dbo.T_Student_Leave_Request AS tslr   
   WHERE DATEDIFF(DAY, ISNULL(tslr.Dt_From_Date,GETDATE()), GETDATE()) >= 0  
            AND DATEDIFF(DAY, GETDATE(), ISNULL(tslr.Dt_To_Date,GETDATE())) >= 0  
            AND I_Status = 1)  
            AND ISNULL(tcbd.I_Status, tsbm.I_Status) <> 5  
            AND tsbd.I_Status = 1  
            AND tsbd.I_Batch_ID IN   
            (SELECT I_Batch_ID FROM dbo.T_Student_Batch_Master AS tsbm  
            WHERE DATEDIFF(dd, tsbm.Dt_BatchStartDate, GETDATE()) >= 0  
            AND DATEDIFF(dd,tsbm.Dt_Course_Expected_End_Date,GETDATE()) <= 0)  
 ORDER BY tsbm.I_Course_ID  
  
 --WHILE @@FETCH_STATUS = 0      
 --BEGIN  
 DECLARE @iIndex INT, @iRowCount INT  
 SELECT @iIndex = 1, @iRowCount = COUNT('1') FROM @tblList  
   
 WHILE (@iIndex <= @iRowCount)  
 BEGIN  
   
  SELECT @iStudentID = I_Student_Detail_ID, @iCenterID = I_Centre_Id,   
    @iCourseID = I_Course_ID, @iBatchID = I_Batch_ID  
  FROM @tblList WHERE ID = @iIndex  
   
  IF(@iPreviousCourseID <> @iCourseID)  
  BEGIN  
   SELECT @cAcademicDropout= ISNULL(I_Is_Dropout_Allowed,'N') FROM [dbo].[T_Course_Master] CM WITH(NOLOCK) WHERE CM.I_Course_ID = @iCourseID  
   SELECT @iAllowableNonAttendedDays = ISNULL(I_No_Of_Days,0) FROM [dbo].[T_Course_Master] WHERE I_Course_ID = @iCourseID  
  END    
    
  IF @cAcademicDropout = 'Y'  
  BEGIN  
   SET @iStatus = 0  
   IF [ACADEMICS].ufnGetStudentAcademicDropoutStatusBatch(@iStudentID,@iBatchID,@iCenterID, @iAllowableNonAttendedDays, @dDate) = 'Y'  
   BEGIN  
    SET @iStatus = 1  
   END    
  
   IF (@iStatus = 1)  
   BEGIN  
    IF NOT EXISTS (SELECT 'TRUE' FROM ACADEMICS.T_Dropout_Details WITH (NOLOCK)  
     WHERE I_Student_Detail_ID = @iStudentID  
     AND I_Center_Id = @iCenterID  
     AND I_Dropout_Status = 1  
     AND I_Batch_ID = @iBatchID
     AND I_Dropout_Type_ID = 1)  
    BEGIN  
      
     INSERT INTO @tblDropoutStudent VALUES (@iStudentID, @iCenterID, @iCourseID, @iBatchID)  
	 UPDATE dbo.T_Student_Batch_Details SET I_Status = 0 WHERE I_Batch_ID = @iBatchID AND I_Student_ID = @iStudentID
    
    END  
   END  
   ELSE IF @iStatus = 0  -- ACTIVATE THE STUDENT WHO IS NOT ACADEMIC DROPOUT  
   BEGIN  
    INSERT INTO @tblReactivatedStudent VALUES (@iStudentID, @iCenterID, @iCourseID, @iBatchID)  
    UPDATE dbo.T_Student_Batch_Details SET I_Status = 1 WHERE I_Batch_ID = @iBatchID AND I_Student_ID = @iStudentID  
   END   
  END    
  
  SET @iPreviousCourseID = @iCourseID  
  
 -- FETCH NEXT FROM DROPOUT_CURSOR INTO @iStudentID, @iSelectedCenterID, @iCourseID  
 --END   
  
 --CLOSE DROPOUT_CURSOR  
 --DEALLOCATE DROPOUT_CURSOR  
   
  SET @iIndex = @iIndex + 1  
   
 END  
   
 SELECT tcm.S_Center_Name, tcm2.S_Course_Name, tsbm.S_Batch_Code, tsd.S_Student_ID,   
   tsd.S_First_Name, tsd.S_Middle_Name, tsd.S_Last_Name, t.*  
 FROM @tblDropoutStudent t  
 INNER JOIN dbo.T_Student_Detail AS tsd ON t.I_Student_Detail_ID = tsd.I_Student_Detail_ID  
 INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON t.I_Batch_ID = tsbm.I_Batch_ID  
 INNER JOIN dbo.T_Centre_Master AS tcm ON tcm.I_Centre_Id = t.I_Center_ID  
 INNER JOIN dbo.T_Course_Master AS tcm2 ON t.I_Course_ID = tcm2.I_Course_ID  
 ORDER BY tcm2.I_Course_ID, I_Centre_Id, I_Batch_ID  
   
 SELECT * FROM @tblReactivatedStudent  
   
 EXEC uspUpdateBatchProcessesDataBrandWise @S_Batch_Process_Name,'Success'  
COMMIT TRAN T1  
END TRY  
  
BEGIN CATCH  
--Error occurred:  
 ROLLBACK  TRAN T1  
 Declare @S_Batch_Process_Name_ERROR VARCHAR(500)  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT,@Description VARCHAR(4000)  
 SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
   
 SET @S_Batch_Process_Name_ERROR='STUDENT_ACADEMICS_DROPOUT'  
  
 SET @Description='Error : '+CAST(@ErrMsg AS VARCHAR)  
 --EXEC uspWriteBatchProcessLog_New NULL,@S_Batch_Process_Name,@Description,'Faliure',1  
 EXEC uspUpdateBatchProcessesDataBrandWise @S_Batch_Process_Name_ERROR,'Faliure'  
 --RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
