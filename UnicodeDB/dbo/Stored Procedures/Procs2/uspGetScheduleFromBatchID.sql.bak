CREATE PROCEDURE [dbo].[uspGetScheduleFromBatchID]   --NULL,7523  --332,NULL,738
 -- Add the parameters for the stored procedure here  
 @iBatchID INT = NULL,  
 @iBatchScheduleID INT = NULL,  
 @iCenterID INT = NULL     
AS   
BEGIN TRY  
  
 IF @iBatchScheduleID IS NOT NULL  
 BEGIN  
  SELECT @iBatchID = I_Batch_ID FROM dbo.T_Student_Batch_Schedule WHERE I_Batch_Schedule_ID = @iBatchScheduleID  
  SELECT @iCenterID = I_Centre_ID FROM dbo.T_Student_Batch_Schedule WHERE I_Batch_Schedule_ID = @iBatchScheduleID  
 END  
  
 DECLARE @iCourseID INT  
 SELECT @iCourseID = I_Course_ID FROM dbo.T_Student_Batch_Master WHERE I_Batch_ID = @iBatchID  
 
 CREATE TABLE #temp  
(  
 I_Batch_Schedule_ID INT,  
 I_Term_ID INT,  
 S_Term_Name VARCHAR(500),  
 I_Module_ID INT,  
 S_Module_Name VARCHAR(500),  
 I_Session_ID INT,  
 S_Session_Name VARCHAR(500),  
 S_Session_Topic VARCHAR(1000),  
 Dt_Schedule_Date DATETIME,  
 Dt_Actual_Date DATETIME,  
 S_Faculty_Name VARCHAR(500),  
 I_Employee_ID INT,  
 I_Is_Complete INT,  
 I_Batch_ID INT,  
 I_Centre_ID INT  
)  
--For Center Batch Schedule
 IF @iCenterID IS NOT NULL
 
	 BEGIN
	 	
	 	INSERT INTO #temp   
		SELECT G.I_Batch_Schedule_ID,  
		B.I_Term_ID,B.S_Term_Name,  
		D.I_Module_ID,D.S_Module_Name,  
		F.I_Session_ID, F.S_Session_Name,F.S_Session_Topic,  
		G.Dt_Schedule_Date,G.Dt_Actual_Date,  
		H.S_First_Name+' '+H.S_Middle_Name+' '+H.S_Last_Name AS S_Faculty_Name,  
		G.I_Employee_ID,G.I_Is_Complete,@iBatchID,@iCenterID  
		FROM dbo.T_Term_Course_Map A INNER JOIN   
		dbo.T_Term_Master B  
		ON   
		A.I_Term_ID = B.I_Term_ID  
		INNER JOIN dbo.T_Module_Term_Map C  
		ON B.I_Term_ID = C.I_Term_ID  
		INNER JOIN dbo.T_Module_Master D  
		ON C.I_Module_ID = D.I_Module_ID  
		INNER JOIN dbo.T_Session_Module_Map E  
		ON  
		D.I_Module_ID = E.I_Module_ID  
		INNER JOIN dbo.T_Session_Master F  
		ON E.I_Session_ID = F.I_Session_ID  
		LEFT OUTER JOIN dbo.T_Student_Batch_Schedule G  
		ON B.I_Term_ID = G.I_Term_ID  
		AND D.I_Module_ID = G.I_Module_ID  
		AND F.I_Session_ID = G.I_Session_ID  
		AND G.I_Batch_ID = @iBatchID  
		AND G.I_Centre_ID = ISNULL(@iCenterID,G.I_Centre_ID)  
		LEFT OUTER JOIN dbo.T_Employee_Dtls H  
		ON G.I_Employee_ID = H.I_Employee_ID  
		WHERE A.I_Status = 1  
		AND C.I_Status = 1  
		AND E.I_Status = 1  
		AND A.I_Course_ID = @iCourseID  
		ORDER BY A.I_Course_ID,A.I_Sequence,C.I_Sequence,E.I_Sequence  
		  
		INSERT INTO #temp   
		SELECT A.I_Batch_Schedule_ID,  
			A.I_Term_ID,  
			C.S_Term_Name,  
			A.I_Module_ID,  
			D.S_Module_Name,  
			A.I_Session_ID,  
			A.S_Session_Name,  
			A.S_Session_Topic,  
			A.Dt_Schedule_Date,  
			A.Dt_Actual_Date,  
			E.S_First_Name+' '+E.S_Middle_Name+' '+E.S_Last_Name AS S_Faculty_Name,  
			A.I_Employee_ID,  
			A.I_Is_Complete,  
			@iBatchID,  
			@iCenterID  
		FROM dbo.T_Student_Batch_Schedule A  
		LEFT OUTER JOIN #temp B  
		ON A.I_Batch_Schedule_ID = B.I_Batch_Schedule_ID  
		INNER JOIN dbo.T_Term_Master C  
		ON A.I_Term_ID = C.I_Term_ID  
		INNER JOIN dbo.T_Module_Master D  
		ON A.I_Module_ID = D.I_Module_ID  
		LEFT OUTER JOIN dbo.T_Employee_Dtls E  
		ON A.I_Employee_ID = E.I_Employee_ID  
		WHERE B.I_Session_ID IS NULL  
		AND A.I_Batch_ID = @iBatchID  
		AND A.I_Centre_ID = ISNULL(@iCenterID,A.I_Centre_ID)  

	 END
 ELSE
 
   BEGIN
  	-- For HO Batch Schedule
  	INSERT INTO #temp   
		SELECT G.I_Batch_Schedule_ID,  
		B.I_Term_ID,B.S_Term_Name,  
		D.I_Module_ID,D.S_Module_Name,  
		F.I_Session_ID, F.S_Session_Name,F.S_Session_Topic,  
		G.Dt_Schedule_Date,G.Dt_Actual_Date,  
		H.S_First_Name+' '+H.S_Middle_Name+' '+H.S_Last_Name AS S_Faculty_Name,  
		G.I_Employee_ID,G.I_Is_Complete,@iBatchID,@iCenterID
		FROM dbo.T_Term_Course_Map A INNER JOIN   
		dbo.T_Term_Master B  
		ON   
		A.I_Term_ID = B.I_Term_ID  
		INNER JOIN dbo.T_Module_Term_Map C  
		ON B.I_Term_ID = C.I_Term_ID  
		INNER JOIN dbo.T_Module_Master D  
		ON C.I_Module_ID = D.I_Module_ID  
		INNER JOIN dbo.T_Session_Module_Map E  
		ON  
		D.I_Module_ID = E.I_Module_ID  
		INNER JOIN dbo.T_Session_Master F  
		ON E.I_Session_ID = F.I_Session_ID  
		LEFT OUTER JOIN dbo.T_Student_Batch_Schedule G  
		ON B.I_Term_ID = G.I_Term_ID  
		AND D.I_Module_ID = G.I_Module_ID  
		AND F.I_Session_ID = G.I_Session_ID  
		AND G.I_Batch_ID = @iBatchID  
	    LEFT OUTER JOIN dbo.T_Employee_Dtls H  
		ON G.I_Employee_ID = H.I_Employee_ID  
		WHERE A.I_Status = 1  
		AND C.I_Status = 1  
		AND E.I_Status = 1  
		AND A.I_Course_ID = @iCourseID  
		ORDER BY A.I_Course_ID,A.I_Sequence,C.I_Sequence,E.I_Sequence  
		  
		INSERT INTO #temp   
		SELECT A.I_Batch_Schedule_ID,  
			A.I_Term_ID,  
			C.S_Term_Name,  
			A.I_Module_ID,  
			D.S_Module_Name,  
			A.I_Session_ID,  
			A.S_Session_Name,  
			A.S_Session_Topic,  
			A.Dt_Schedule_Date,  
			A.Dt_Actual_Date,  
			E.S_First_Name+' '+E.S_Middle_Name+' '+E.S_Last_Name AS S_Faculty_Name,  
			A.I_Employee_ID,  
			A.I_Is_Complete,  
			@iBatchID,  
			@iCenterID  
		FROM dbo.T_Student_Batch_Schedule A  
		LEFT OUTER JOIN #temp B  
		ON A.I_Batch_Schedule_ID = B.I_Batch_Schedule_ID  
		INNER JOIN dbo.T_Term_Master C  
		ON A.I_Term_ID = C.I_Term_ID  
		INNER JOIN dbo.T_Module_Master D  
		ON A.I_Module_ID = D.I_Module_ID  
		LEFT OUTER JOIN dbo.T_Employee_Dtls E  
		ON A.I_Employee_ID = E.I_Employee_ID  
		WHERE B.I_Session_ID IS NULL  
		AND A.I_Batch_ID = @iBatchID  
		
  END	 

  
IF @iBatchScheduleID IS NOT NULL  
 BEGIN  
  SELECT * FROM #temp WHERE I_Batch_Schedule_ID = @iBatchScheduleID  
 END  
ELSE  
 BEGIN  
  SELECT * FROM #temp  
 END  
  
DROP TABLE #temp  
END TRY  
BEGIN CATCH  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
