-- =============================================  
-- Author:  SAntanu Maity  
-- Create date: 06/26/2007  
-- Description: To get Student progress report  
-- =============================================  
  
  
CREATE PROCEDURE [REPORT].[uspGetStudentProgressReport]    
-- EXEC [REPORT].[uspGetStudentProgressReport] '1', 109,'1/1/2013', '12/12/2013', 1191,'GCGEN1314004'  ,17589
(  
-- Add the parameters for the stored procedure here  
 @sHierarchyList varchar(MAX),  
 @iBrandID int,  
 @dtStartDate datetime,  
 @dtEndDate datetime,  
 @iBatchId INT ,  
 @sBatchCode varchar(200),  
 @iStudentId int = NULL,  
 @sStudentName varchar(200) =NULL  
)  
AS  
  
BEGIN TRY  
 BEGIN   
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  

  CREATE TABLE #tblCenter (CenterId INT, centerName VARCHAR(250),CenterCode VARCHAR(20))                            
              
	CREATE TABLE #tblStudent          
	(                  
	 I_Student_Id INT,            
	 I_Term_ID INT       
	)            
	    

  CREATE TABLE #tblStudentProgress   
  (  
   I_Student_Detail_ID INT,  
   I_Term_ID INT,
   S_Student_ID VARCHAR(500),  
   s_StudentName VARCHAR(500),  
   S_Course_Name VARCHAR(250),  
   d_CourseStartDate DATETIME,  
   d_CourseEndDate DATETIME,  
   S_Term_Name VARCHAR(250),  
   d_TermStartDate DATETIME,  
   d_TermActualEndDate DATETIME,  
   d_TermCalculatedEndDate DATETIME,  
   I_ScheduleVariance NUMERIC(8,2),  
   S_FacultyName VARCHAR(1000),  
   I_Centre_Id INT,  
   s_CenterCode VARCHAR(20),  
   s_CenterName VARCHAR(100),
   i_IsStatus int,  
   s_Status VARCHAR(100),  
   I_SequenceVariance NUMERIC(8,2),  
   S_batch_Name VARCHAR(250),  
   d_BatchStartDate DATETIME,  
   d_BatchEndDate DATETIME, 
   s_InstanceChain VARCHAR(500)
  )  
  -- Insert statements for procedure here  
     
  INSERT INTO #tblCenter                          
  SELECT FSR.centerID, FSR.centerName, FSR.centerCode FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) AS FSR                          
              
     
  DECLARE @iStudentDeatilID INT, @iCourseID INT, @sCourseName VARCHAR(200)  
  DECLARE @iTermID INT  
    
  SELECT @iCourseID = tsbm.I_Course_ID, @sCourseName = tcm.S_Course_Name,  
      @sBatchCode = tsbm.S_Batch_Code  
  FROM [dbo].[T_Student_Batch_Master] tsbm 
  INNER JOIN [dbo].[T_Course_Master] tcm 
  ON tcm.I_Course_ID = tsbm.I_Course_ID  
  WHERE tsbm.[I_Batch_ID] = @iBatchId  
  
      
   INSERT INTO #tblStudent
   SELECT SD.I_Student_Detail_ID, STD.I_Term_ID  
    FROM dbo.T_Student_Detail SD WITH (NOLOCK)  
      INNER JOIN dbo.T_Student_Center_Detail SC  
       ON SC.I_Student_Detail_ID = SD.I_Student_Detail_ID  
       AND SC.Dt_Valid_From >= @dtStartDate   
       AND SC.Dt_Valid_From <= @dtEndDate  
       AND SC.I_Status = 1  
      INNER JOIN dbo.T_Student_Batch_Details AS tsbd  
       ON SD.I_Student_Detail_ID = tsbd.I_Student_ID  
      AND tsbd.I_Batch_ID=@iBatchId
       AND SD.I_Student_Detail_ID = ISNULL(@iStudentId,SD.I_Student_Detail_ID)  
       AND tsbd.I_Status = 1  
      INNER JOIN dbo.T_Center_Batch_Details AS tcbd  
      ON SC.I_Centre_Id = tcbd.I_Centre_Id  
      AND tcbd.I_Batch_ID = tsbd.I_Batch_ID  
      AND tcbd.I_Status <> 5  
      INNER JOIN dbo.T_Student_Batch_Master AS tsbm2  
      ON tsbm2.I_Batch_ID = tsbd.I_Batch_ID        
      INNER JOIN dbo.T_Student_Term_Detail STD  
       ON SD.I_Student_Detail_ID = STD.I_Student_Detail_ID  
       AND STD.I_Course_ID = tsbm2.I_Course_ID  
       AND STD.I_Is_Completed = 0    
      INNER JOIN #tblCenter AS FN1  
       ON SC.I_Centre_Id=FN1.CenterID  
       
       
   --OPEN Student_Cursor   
   -- FETCH NEXT FROM Student_Cursor  
   -- INTO @iStudentDeatilID,@iTermID  
    
  --WHILE @@FETCH_STATUS = 0  
  --BEGIN    
    -- INSERT DATA FOR TERM EVALUATION STRATEGY   
   INSERT INTO #tblStudentProgress  
   (  
   I_Student_Detail_ID , 
   I_Term_ID, 
   S_Student_ID ,  
   s_StudentName ,  
   S_Course_Name ,  
   S_Term_Name,
   I_Centre_Id ,  
   s_CenterCode ,  
   s_CenterName ,   
   i_IsStatus ,  
   s_Status,
   S_batch_Name,
   d_BatchStartDate,
   d_BatchEndDate,
   s_InstanceChain      
  )
   SELECT DISTINCT   
    SD.I_Student_Detail_ID, 
    ts.I_Term_ID, 
    SD.S_Student_ID,  
    ISNULL(SD.S_Title,'') + ' ' + SD.S_First_Name + ' ' + LTRIM(isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name) as StudentName,  
    CM.S_Course_Name,  
    TM.S_Term_Name,
    SC.I_Centre_Id,  
    FN1.CenterCode,  
    FN1.CenterName,  
    SD.I_Status,  
    [REPORT].[fnGetStudentStatusForReports](SD.I_Student_Detail_ID,SC.I_Centre_Id,GETDATE()) AS Student_Status ,
    tsbm2.S_Batch_Name,
    tsbm2.Dt_BatchStartDate,
    tsbm2.Dt_Course_Expected_End_Date,
    FN2.instanceChain
   FROM   
    dbo.T_Student_Detail SD  
    INNER JOIN #tblStudent AS ts
    ON SD.I_Student_Detail_ID=ts.I_Student_Id
    INNER JOIN dbo.T_Student_Batch_Details AS tsbd  
    ON SD.I_Student_Detail_ID = tsbd.I_Student_ID  
    AND tsbd.I_Status = 1  
    AND tsbd.I_Batch_ID = @iBatchId
    INNER JOIN dbo.T_Student_Center_Detail SC  
    ON SC.I_Student_Detail_ID = SD.I_Student_Detail_ID  
    AND SC.I_Status = 1  
    AND SC.Dt_Valid_From >= @dtStartDate   
    AND SC.Dt_Valid_From <= @dtEndDate  
    INNER JOIN dbo.T_Center_Batch_Details AS tcbd  
    ON SC.I_Centre_Id = tcbd.I_Centre_Id  
    AND tcbd.I_Batch_ID = tsbd.I_Batch_ID  
    AND tcbd.I_Status <> 5  
    INNER JOIN dbo.T_Student_Batch_Master AS tsbm2  
    ON tsbm2.I_Batch_ID = tsbd.I_Batch_ID  
    INNER JOIN dbo.T_Student_Term_Detail STD  
    ON SD.I_Student_Detail_ID = STD.I_Student_Detail_ID  
    AND ts.I_Term_ID = STD.I_Term_ID
    INNER JOIN dbo.T_Term_Master TM  
    ON STD.I_Term_ID = TM.I_Term_ID  
    AND TM.I_Status = 1  
    INNER JOIN dbo.T_Course_Master CM  
    ON tsbm2.I_Course_ID = CM.I_Course_ID  
     INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN3 ON SC.I_Centre_Id = FN3.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN3.HierarchyDetailID = FN2.HierarchyDetailID
    --INNER JOIN [REPORT].[fnGetStudentCourseDuretion](@iStudentDeatilID, @iCourseId) FN3  
    --ON SD.I_Student_Detail_ID = FN3.iStudentDetailID  
    --AND CM.I_Course_ID = FN3.iCourseID  
    --INNER JOIN [REPORT].[fnGetStudentTermDuretion](@iStudentDeatilID, @iCourseId, @iTermID) FN4  
    --ON FN3.iStudentDetailID = FN4.iStudentDetailID  
    --AND FN3.iCourseID = FN4.iCourseID  
    --AND TM.I_Term_ID = FN4.iTermID  
    --INNER JOIN [REPORT].[fnGetSequenceVariance](@iStudentDeatilID,@iCourseId,@iTermID,@dtStartDate,@dtEndDate) FN5  
    --ON FN4.iStudentDetailID = FN5.iStudentDetailID  
    --AND FN4.iCourseID = FN5.iCourseID  
    --AND FN4.iTermID = FN5.iTermID  
    INNER JOIN #tblCenter AS FN1
    ON SC.I_Centre_Id=FN1.CenterID  
    
   --SELECT * FROM #tblStudentProgress
    
    DECLARE Student_Cursor CURSOR FOR   
   SELECT I_Student_Detail_ID, I_Term_ID  
    FROM #tblStudentProgress
  
   OPEN Student_Cursor   
    FETCH NEXT FROM Student_Cursor  
    INTO @iStudentDeatilID,@iTermID  
    
  WHILE @@FETCH_STATUS = 0  
  BEGIN    
   
    
UPDATE #tblStudentProgress  
 SET 
   d_TermStartDate = Term.dtTermStartDate ,  
   d_TermActualEndDate = Term.dtTermActualEndDate ,  
   d_TermCalculatedEndDate = term.dtTermCalculateEndDate,  
   I_ScheduleVariance = term.fScheduleVariance,  
   S_FacultyName = term.sEmployeeName,
   I_SequenceVariance = Term.nSequenceVariance  
   FROM #tblStudentProgress A INNER JOIN 
   (SELECT dtTermStartDate,dtTermActualEndDate,dtTermCalculateEndDate, 
    fScheduleVariance, sEmployeeName, nSequenceVariance,FN4.iStudentDetailID
    FROM [REPORT].[fnGetStudentTermDuretion](@iStudentDeatilID, @iCourseId, @iTermID) FN4  
    left JOIN [REPORT].[fnGetSequenceVariance](@iStudentDeatilID,@iCourseId,@iTermID,@dtStartDate,@dtEndDate) FN5  
    ON FN4.iStudentDetailID = FN5.iStudentDetailID  
    AND FN4.iCourseID = FN5.iCourseID  
    AND FN4.iTermID = FN5.iTermID 
   )Term
   ON A.I_Student_Detail_ID=term.iStudentDetailID 
   WHERE  A.I_TErm_ID =@iTermID AND A.I_Student_Detail_ID=@iStudentDeatilID
 --  AND A.I_Student_Detail_ID = @iStudentDeatilID
   
    FETCH NEXT FROM Student_Cursor  
     INTO @iStudentDeatilID,@iTermID  
   END 
 SELECT @sBatchCode AS S_Batch_Code,* FROM #tblStudentProgress  
  
 CLOSE Student_Cursor  
  
  DEALLOCATE Student_Cursor 
  
 DROP TABLE #tblCenter          
 DROP TABLE #tblStudent 
 DROP TABLE #tblStudentProgress
 END
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
