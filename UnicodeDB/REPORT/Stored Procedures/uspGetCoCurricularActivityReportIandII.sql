
--exec [REPORT].[uspGetCoCurricularActivityReport] '88',109,null,NULL
CREATE PROCEDURE [REPORT].[uspGetCoCurricularActivityReportIandII]
    (
      @sHierarchyList varchar(MAX),
	  @iBrandID int,
      @iBatchID INT, 
      @iStudentID int =Null
   
    )
AS 
    BEGIN
    
    Declare @CenterId int, @centreName varchar(max),@startDate Datetime,@enddate datetime
SELECT top 1 @CenterId=centerID,@centreName=centerName
  FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) AS fgcfr
    
  
  
  
  SELECT distinct tsad.I_Student_Detail_ID,
  tsd.S_First_Name+' '+ISNULL(tsd.s_middle_name,'')+' '+ISNULL(tsd.s_last_name,'') as studentname,
  tsd.S_Student_ID,
  tsad.I_Batch_ID,
  tsbm.S_Batch_Name,
  tsbm.I_Course_ID,
  tcm.S_Course_Name,
  tsad.I_Activity_ID,
  tam.S_Activity_Name,
  taecm.I_Evaluation_ID,
  taem.S_Evaluation_Name,
  tsap.S_Student_Grade,
  tsap.I_Term_ID,
  TTM.S_Term_Name,
  cast(year(tsbm.Dt_BatchStartDate) as varchar)+' - '+right(cast(year(tsbm.Dt_BatchStartDate)+1 as varchar),2) as sessionName,
  TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name AS FacultyName
   FROM dbo.T_Student_Activity_Details AS tsad 
   INNER JOIN dbo.T_Activity_Master AS tam ON tsad.I_Activity_ID=tam.I_Activity_ID AND tam.I_Status = 1
   INNER JOIN dbo.T_ActivityEvalCriteria_Map AS taecm ON taecm.I_Activity_ID = tsad.I_Activity_ID
   INNER JOIN dbo.T_Activity_Evaluation_Master AS taem ON taecm.I_Evaluation_ID=taem.I_Evaluation_ID and taem.I_Status=1
   INNER JOIN  dbo.T_Student_Detail AS tsd ON tsad.I_Student_Detail_ID=tsd.I_Student_Detail_ID
   INNER JOIN  dbo.T_Student_Batch_Master AS tsbm on tsbm.I_Batch_ID = tsad.I_Batch_ID
   INNER JOIN dbo.T_Course_Master AS tcm on tcm.I_Course_ID=tsbm.I_Course_ID
   INNER  JOIN dbo.T_Student_Activity_Performance AS tsap ON tsap.I_Student_Activity_ID = tsad.I_Student_Activity_ID and tsap.I_Evaluation_ID=taem.I_Evaluation_ID
   INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = tsap.I_Term_ID
   LEFT JOIN dbo.T_Employee_Dtls TED ON tsad.I_Employee_ID=TED.I_Employee_ID
   WHERE tsad.I_Student_Detail_ID =ISNULL(@iStudentID,tsad.I_Student_Detail_ID)
  AND tsad.I_Batch_ID= isnull(@iBatchID ,tsad.I_Batch_ID) AND tsad.I_Status=1 and tsap.I_Status=1
  AND (tsap.S_Student_Grade IS NOT NULL AND tsap.S_Student_Grade!='')
  
  --Akash
  and tsap.I_Term_ID=
  (
  SELECT TOP 1 XX.TermID FROM
(
SELECT DISTINCT tsap.I_Term_ID AS TermID FROM
dbo.T_Student_Activity_Details AS tsad 
   INNER JOIN dbo.T_Activity_Master AS tam ON tsad.I_Activity_ID=tam.I_Activity_ID AND tam.I_Status = 1
   INNER JOIN dbo.T_ActivityEvalCriteria_Map AS taecm ON taecm.I_Activity_ID = tsad.I_Activity_ID
   INNER JOIN dbo.T_Activity_Evaluation_Master AS taem ON taecm.I_Evaluation_ID=taem.I_Evaluation_ID and taem.I_Status=1
   INNER JOIN  dbo.T_Student_Detail AS tsd ON tsad.I_Student_Detail_ID=tsd.I_Student_Detail_ID
   INNER JOIN  dbo.T_Student_Batch_Master AS tsbm on tsbm.I_Batch_ID = tsad.I_Batch_ID
   INNER JOIN dbo.T_Course_Master AS tcm on tcm.I_Course_ID=tsbm.I_Course_ID
   INNER  JOIN dbo.T_Student_Activity_Performance AS tsap ON tsap.I_Student_Activity_ID = tsad.I_Student_Activity_ID and tsap.I_Evaluation_ID=taem.I_Evaluation_ID
   WHERE tsad.I_Student_Detail_ID =ISNULL(@iStudentID,tsad.I_Student_Detail_ID)
  AND tsad.I_Batch_ID= isnull(@iBatchID ,tsad.I_Batch_ID) AND tsad.I_Status=1 and tsap.I_Status=1
  ) XX
  ORDER BY XX.TermID DESC
  )
  --Akash End
                        
    END
