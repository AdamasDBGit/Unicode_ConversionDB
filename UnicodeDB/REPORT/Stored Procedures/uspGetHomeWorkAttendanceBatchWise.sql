
-- =============================================  
-- Author:  Shubhrangshu Nag  
-- Create date: 09/10/2013  
-- Description: To get HomeWork Attendance Report BatchWise 
-- =============================================  
  
CREATE PROCEDURE [REPORT].[uspGetHomeWorkAttendanceBatchWise] --'88',109,NULL,'2013-08-15','2013-09-11'
(  
-- Add the parameters for the stored procedure here  
	@sHierarchyList varchar(MAX),
    @iBrandID int,
    @iBatchID INT  = NULL,
	@FromDate DATETIME,  
	@ToDate  DATETIME    
)  
AS  
  
BEGIN TRY  
 BEGIN   
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  

	Declare @temp table(S_Skill_Desc VARCHAR(100),I_Skill_ID INT,S_Batch_Name VARCHAR(100),I_Batch_ID INT,Prcnt90 INT, Prcnt9070 INT,Prcnt7050 INT,Prcnt50 INT,Prcnt0 INT,TotalStudentCount INT)
	Declare @temp1 table(S_Skill_Desc VARCHAR(100),I_Skill_ID INT,S_Batch_Name VARCHAR(100),I_Batch_ID INT,Prcnt90 INT, Prcnt9070 INT,Prcnt7050 INT,Prcnt50 INT)

	Declare @Final table(S_Skill_Desc VARCHAR(100),I_Skill_ID INT,S_Batch_Name VARCHAR(100),I_Batch_ID INT,Prcnt90 INT, HWPrcnt90 INT, Prcnt9070 INT,HWPrcnt9070 INT,Prcnt7050 INT,HWPrcnt7050 INT,Prcnt50 INT,HWPrcnt50 INT, Prcnt0 INT,TotalStudentCount INT)


	
		
	INSERT INTO @temp (S_Skill_Desc ,I_Skill_ID,S_Batch_Name,I_Batch_ID ,Prcnt90 , Prcnt9070 ,Prcnt7050 ,Prcnt50,Prcnt0 ,TotalStudentCount)
	SELECT 	
	  S_Skill_Desc,
	  I_Skill_ID,
	S_Batch_Name,
	I_Batch_ID,
	SUM(PERCENTAGE90) Prcnt90,
	SUM(PERCENTAGE9070) Prcnt9070,
	SUM(PERCENTAGE7050) Prcnt7050,
	SUM(PERCENTAGE50) Prcnt50,
	(TotalStudentCount - SUM(PERCENTAGE90) - SUM(PERCENTAGE9070) - SUM(PERCENTAGE7050) - SUM(PERCENTAGE50)) Prcnt0 ,
	TotalStudentCount

	 FROM

(SELECT DISTINCT No_Atteded_Session, S_Student_ID ,	
	  S_Skill_Desc,
	  I_Skill_ID,
	S_Batch_Name,
	I_Batch_ID,
	--(CAST(No_Atteded_Session as float)/ CAST(SessionCount as float)) fraction,
	CASE 
	WHEN SessionCount = 0 THEN NULL
      WHEN (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) >=0.9 THEN 1 
      ELSE 0 
	END PERCENTAGE90,
	CASE 
	WHEN SessionCount = 0 THEN NULL
	 WHEN (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) >=0.7 AND (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) < 0.9 THEN 1 
      ELSE 0 
	END PERCENTAGE9070	
	,
	CASE 
	WHEN SessionCount = 0 THEN NULL
	 WHEN (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) >=0.5 AND (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) < 0.7 THEN 1 
      ELSE 0 
	END PERCENTAGE7050,

	CASE 
	  WHEN SessionCount = 0 THEN NULL
      WHEN (CAST(No_Atteded_Session AS FLOAT)/ CAST(SessionCount AS FLOAT)) < 0.5 THEN 1 
      ELSE 0 
	END  PERCENTAGE50	
	 	 
	 ,SessionCount
	 ,TotalStudentCount
from
	(SELECT 
	 COUNT(SA.I_Attendance_Detail_ID) AS No_Atteded_Session,
	  SD.S_Student_ID ,
	  --TM.S_Session_Name ,
	  ESM.S_Skill_Desc,
	  ESM.I_Skill_ID,
	TSBM.S_Batch_Name,
	TSBM.I_Batch_ID,
	dbo.[fnGetTotalStudentCount](TSBM.I_Batch_ID) TotalStudentCount ,
	--dbo.[fnGetTotalSessionCount](TSBM.I_Batch_ID,SC.I_Centre_Id,'2013-06-01','2013-06-30') TotalSessionCount ,
	dbo.[fnGetTotalSessionCountSubjectWise](TSBM.I_Batch_ID,SC.I_Centre_Id,ESM.I_Skill_ID,@FromDate,@ToDate) SessionCount 
	FROM dbo.T_Student_Detail SD  
	INNER JOIN dbo.T_Student_Batch_Details AS TSBD  
    ON SD.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND TSBD.I_Status = 1  
    AND SD.I_Status = 1 
	INNER JOIN dbo.T_Student_Center_Detail SC  
    ON SC.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND SC.I_Status = 1  
   INNER JOIN dbo.T_Center_Batch_Details AS TCBD
   ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
   AND SC.I_Centre_Id = TCBD.I_Centre_Id
   AND ISNULL(TCBD.I_Status,2) <> 5
   INNER JOIN dbo.T_Student_Batch_Master AS TSBM
   ON TCBD.I_Batch_ID = TSBM.I_Batch_ID 
   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
   ON SC.I_Centre_Id=FN1.CenterID  
   INNER JOIN [dbo].[T_TimeTable_Master] TM
   ON TM.I_Center_ID=FN1.CenterID  
   AND TM.I_Batch_ID=TSBM.I_Batch_ID 
   --INNER JOIN [dbo].[T_TimeTable_Faculty_Map] TFM
   --ON TM.I_TimeTable_ID=TFM.I_TimeTable_ID 
   INNER JOIN dbo.T_Session_Master SM  
   ON SM.I_Session_ID=TM.I_Session_ID
   INNER JOIN dbo.T_EOS_SKILL_MASTER ESM  
   ON ESM.I_Skill_ID=SM.I_Skill_ID
   INNER JOIN  [dbo].[T_Student_Attendance] SA
   ON SA.I_TimeTable_ID=TM.I_TimeTable_ID
   AND SA.I_Student_Detail_ID=TSBD.[I_Student_ID] 
   WHERE  TM.Dt_Schedule_Date >= @FromDate
	AND TM.Dt_Schedule_Date <= @ToDate
	AND TSBM.I_Batch_ID=ISNULL(@iBatchID,TSBM.I_Batch_ID)
   --AND TFM.I_Employee_ID=@EmployeeID
   GROUP BY  SD.S_Student_ID ,ESM.S_Skill_Desc ,ESM.I_Skill_ID,TSBM.S_Batch_Name,TSBM.I_Batch_ID,SC.I_Centre_Id) a ) b
   GROUP BY S_Skill_Desc,I_Skill_ID,S_Batch_Name,I_Batch_ID,TotalStudentCount
	ORDER BY S_Batch_Name


INSERT INTO @temp1 (S_Skill_Desc ,I_Skill_ID,S_Batch_Name,I_Batch_ID ,Prcnt90 , Prcnt9070 ,Prcnt7050 ,Prcnt50)
	SELECT 	
	  S_Skill_Desc,
	  I_Skill_ID,
	S_Batch_Name,
	I_Batch_ID,
	SUM(PERCENTAGE90) Prcnt90,
	SUM(PERCENTAGE9070) Prcnt9070,
	SUM(PERCENTAGE7050) Prcnt7050,
	SUM(PERCENTAGE50) Prcnt50
	 FROM
	(SELECT DISTINCT No_HW_Submission, S_Student_ID ,	
	  S_Skill_Desc,
	  I_Skill_ID,
	S_Batch_Name,
	I_Batch_ID,
	--(CAST(No_Atteded_Session as float)/ CAST(SessionCount as float)) fraction,
	CASE 
	WHEN HomeWorkCount = 0 THEN NULL
      WHEN (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) >=0.9 THEN 1 
      ELSE 0 
	END PERCENTAGE90,
	CASE 
	WHEN HomeWorkCount = 0 THEN NULL
	 WHEN (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) >=0.7 AND (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) < 0.9 THEN 1 
      ELSE 0 
	END PERCENTAGE9070	
	,
	CASE 
	WHEN HomeWorkCount = 0 THEN NULL
	 WHEN (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) >=0.5 AND (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) < 0.7 THEN 1 
      ELSE 0 
	END PERCENTAGE7050,

	CASE 
	  WHEN HomeWorkCount = 0 THEN NULL
      WHEN (CAST(No_HW_Submission as float)/ CAST(HomeWorkCount as float)) < 0.5 THEN 1 
      ELSE 0 
	END  PERCENTAGE50	
	 	 
	 ,HomeWorkCount
	
from
	(SELECT    
	--COUNT( DISTINCT SD.S_Student_ID) as No_Atteded_Student, 
	Count(HS.I_Homework_Submission_ID) AS No_HW_Submission,
	 SD.S_Student_ID,
   TSBM.S_Batch_Name,TSBM.I_Batch_ID,
   --SM.S_Session_Name,
   ESM.S_Skill_Desc,
	  ESM.I_Skill_ID,
	  dbo.[fnGetTotalStudentCount](TSBM.I_Batch_ID) TotalStudentCount,
	  [dbo].[fnGetTotalHomeWorkCountSubjectWise](TSBM.I_Batch_ID,SC.I_Centre_Id,ESM.I_Skill_ID,@FromDate,@ToDate) HomeWorkCount  
  FROM   
   dbo.T_Student_Detail SD  
   INNER JOIN dbo.T_Student_Batch_Details AS TSBD  
    ON SD.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND TSBD.I_Status = 1  
    AND SD.I_Status = 1 
   INNER JOIN dbo.T_Student_Center_Detail SC  
    ON SC.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND SC.I_Status = 1  
   INNER JOIN dbo.T_Center_Batch_Details AS TCBD
   ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
   AND SC.I_Centre_Id = TCBD.I_Centre_Id
   AND ISNULL(TCBD.I_Status,2) <> 5
   INNER JOIN dbo.T_Student_Batch_Master AS TSBM
   ON TCBD.I_Batch_ID = TSBM.I_Batch_ID 
   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
   ON SC.I_Centre_Id=FN1.CenterID  
   INNER JOIN [EXAMINATION].[T_Homework_Submission] HS
   ON HS.I_Student_Detail_ID=SD.I_Student_Detail_ID 
   INNER JOIN [EXAMINATION].[T_Homework_Master]  HM
   ON HS.I_Homework_ID=HM.I_Homework_ID
   INNER JOIN dbo.T_Session_Master SM  
   ON SM.I_Session_ID=HM.I_Session_ID
   INNER JOIN dbo.T_EOS_SKILL_MASTER ESM  
   ON ESM.I_Skill_ID=SM.I_Skill_ID
   WHERE HM.Dt_Submission_Date>= @FromDate
	AND HM.Dt_Submission_Date <= @ToDate
	AND TSBM.I_Batch_ID=ISNULL(@iBatchID,TSBM.I_Batch_ID)
   --AND HS.I_Employee_ID=@EmployeeID
   GROUP BY  SD.S_Student_ID ,ESM.S_Skill_Desc ,ESM.I_Skill_ID,TSBM.S_Batch_Name,TSBM.I_Batch_ID,SC.I_Centre_Id) a) b
   GROUP BY S_Skill_Desc,I_Skill_ID,S_Batch_Name,I_Batch_ID
	ORDER BY S_Batch_Name




	INSERT INTO @Final (S_Skill_Desc ,I_Skill_ID,S_Batch_Name,I_Batch_ID ,Prcnt90 , Prcnt9070 ,Prcnt7050 ,Prcnt50,Prcnt0,TotalStudentCount)
	SELECT * FROM @temp

	UPDATE F
	SET F.HWPrcnt90=T.Prcnt90,
		F.HWPrcnt9070=T.Prcnt9070,
		F.HWPrcnt7050=T.Prcnt7050,
		F.HWPrcnt50=T.Prcnt50
	FROM @Final F
	INNER JOIN @temp1 T
	ON F.I_Batch_ID=T.I_Batch_ID
	AND F.I_Skill_ID=T.I_Skill_ID

	SELECT * FROM @Final

	--SELECT s_batch_name ,dt, sum(m1) No_St, sum(m2) No_ht
	--FROM(
	--SELECT s_batch_name ,dt, No_St m1, 0 m2  FROM @temp
	--UNION 
	--SELECT s_batch_name ,dt, 0 m1, No_St m2  FROM @temp1
	--) a
	--GROUP BY  s_batch_name ,dt	
	


 END  
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
