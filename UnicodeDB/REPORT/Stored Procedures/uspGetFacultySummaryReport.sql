/*******************************************************  
Author :     Arindam Roy  
Date :   01/02/2008  
Description : This SP retrieves the Faculty Summary Report details  
*********************************************************/  
  
CREATE PROCEDURE [REPORT].[uspGetFacultySummaryReport]-- 6,22,'10/1/2007','3/4/2008'  
(  
 -- Add the parameters for the stored procedure here  
 @sHierarchyList varchar(MAX),  
 @iBrandID int,  
 @dtStartDate datetime,  
 @dtEndDate datetime,  
 @iEmployeeId int =NULL,  
 @sEmployeeName varchar(200) =NULL  
)  
AS  
BEGIN TRY  
  
 DECLARE @FacultySummary TABLE  
 (  
  Employee_ID INT,  
  TotalStudents INT,  
  TotalHours INT,  
  TotalSkills INT,  
  TotalSkillsOnTime INT,  
  TotalModules INT,
  TotalSlots INT
 )  
  
 DECLARE @EmployeeID INT  
 DECLARE @TotalStudents INT  
 DECLARE @TotalHours INT  
 DECLARE @TotalSkills INT  
 DECLARE @TotalSkillsOnTime INT  
 DECLARE @TotalModules INT  
 DECLARE @SkillID INT  
 DECLARE @CenterID INT  
 DECLARE @ExamComponentID INT 
 DECLARE @TotalSlots INT 
  
  SELECT TSA.I_Attendance_Detail_ID ,  
          TSA.I_Student_Detail_ID ,  
          TSA.S_Crtd_By ,  
          TSA.Dt_Crtd_On ,  
          TSA.I_TimeTable_ID,   
             TTM.I_Center_ID ,  
             TTM.Dt_Schedule_Date ,  
             TTM.I_TimeSlot_ID ,  
             TTM.I_Batch_ID ,  
             TTM.I_Room_ID ,  
             TTM.I_Skill_ID ,  
             TTM.I_Status ,  
             TTM.S_Remarks ,  
             TTM.I_Session_ID ,  
             TTM.I_Term_ID ,  
             TTM.I_Module_ID ,  
             TTM.S_Session_Name ,  
             TTM.S_Session_Topic ,  
             TTM.Dt_Actual_Date ,  
             TTM.I_Is_Complete,   
			 TTFM.I_Employee_ID ,  
             TTFM.B_Is_Actual  
    INTO #TmpFacSum  
    FROM dbo.T_TimeTable_Faculty_Map TTFM  
   inner join T_TimeTable_Master TTM on TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID  
   inner join T_Student_Attendance TSA on TSA.I_TimeTable_ID = TTM.I_TimeTable_ID  
   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
   ON TTM.I_Center_ID=FN1.CenterID     
   WHERE TTM.Dt_Schedule_Date BETWEEN @dtStartDate AND @dtEndDate  
  AND TTFM.I_Employee_ID = ISNULL(@iEmployeeId,TTFM.I_Employee_ID)  
  
 DECLARE FacSummary_cursor CURSOR FOR   
 SELECT DISTINCT I_Employee_ID,I_Center_Id FROM #TmpFacSum ORDER BY I_Employee_ID  
  
 OPEN FacSummary_cursor  
 FETCH NEXT FROM FacSummary_cursor   
 INTO @EmployeeID,@CenterID  
  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  ---------Total Student Count--------------------------------------  
   SELECT @TotalStudents=COUNT(DISTINCT I_Student_Detail_ID)   
     FROM #TmpFacSum  
    WHERE I_Employee_ID=@EmployeeID  
  
  ---------Total Hours Spent in Teaching-----------------------------  
  SELECT DISTINCT I_TimeTable_ID, TMP1.I_TimeSlot_ID, DATEDIFF(mi,Dt_Start_Time, Dt_End_Time) AS Duration 
  INTO #TmpFacSum1
  FROM #TmpFacSum TMP1  
  INNER JOIN dbo.T_Center_TimeSlot_Master AS ttsm
  ON ttsm.I_TimeSlot_ID = TMP1.I_TimeSlot_ID
  WHERE I_Employee_ID=@EmployeeID  
    
  SELECT @TotalHours=SUM(Duration)/60 FROM #TmpFacSum1  
  SELECT @TotalSlots = COUNT(*) FROM #TmpFacSum1  
  
  DROP TABLE #TmpFacSum1  
  
  ---------Total Modules Handled-----------------------------  
--   SELECT @TotalModules=COUNT(DISTINCT I_Module_ID) FROM #TmpFacSum WHERE I_Employee_ID=@EmployeeID  
     
   SELECT @TotalModules=COUNT(DISTINCT MM.S_Module_Name)  
     FROM #TmpFacSum TMP  
    INNER JOIN dbo.T_Module_Master MM  
    ON TMP.I_Module_ID=MM.I_Module_ID  
    WHERE I_Employee_ID=@EmployeeID  
  
  ---------Total Skills Cleared-----------------------------  
  
   SELECT @TotalSkills=COUNT(DISTINCT I_Skill_ID)  
     FROM EOS.T_Employee_Skill_Map   
    WHERE I_Employee_ID=@EmployeeID  
   AND I_Status = 1  
  
  ---------Total Skills Cleared On Timeframe-----------------  
  
  SET @TotalSkillsOnTime=0  
  
  DECLARE FacSkill_cursor CURSOR FOR   
  SELECT DISTINCT I_Skill_ID FROM EOS.T_Employee_Skill_Map WHERE I_Employee_ID=@EmployeeID  
  
  OPEN FacSkill_cursor  
  FETCH NEXT FROM FacSkill_cursor   
  INTO @SkillID  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  
   IF EXISTS ( SELECT I_Exam_Component_ID  
        FROM EOS.T_Skill_Exam_Map  
       WHERE I_Centre_ID=@CenterID  
         AND I_Skill_ID=@SkillID  
       )  
   BEGIN  
    SELECT @ExamComponentID=I_Exam_Component_ID  
      FROM EOS.T_Skill_Exam_Map  
     WHERE I_Centre_ID=@CenterID  
       AND I_Skill_ID=@SkillID  
   END  
   ELSE  
   BEGIN  
    SELECT @ExamComponentID=I_Exam_Component_ID  
      FROM EOS.T_Skill_Exam_Map  
     WHERE I_Centre_ID IS NULL  
       AND I_Skill_ID=@SkillID  
   END  
  
   IF EXISTS( SELECT * FROM EOS.T_Employee_Exam_Result   
      WHERE I_Employee_ID=@EmployeeID  
        AND I_Exam_Component_ID=@ExamComponentID  
        AND Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate  
--        AND B_Passed =1  
      )  
   BEGIN  
    SET @TotalSkillsOnTime=@TotalSkillsOnTime+1  
   END  
  
   FETCH NEXT FROM FacSkill_cursor   
   INTO @SkillID  
  END  
  
  CLOSE FacSkill_cursor  
  DEALLOCATE FacSkill_cursor  
  
  
  INSERT INTO @FacultySummary VALUES (@EmployeeID,@TotalStudents,@TotalHours,@TotalSkills,@TotalSkillsOnTime,@TotalModules,@TotalSlots)  
   
  FETCH NEXT FROM FacSummary_cursor   
  INTO @EmployeeID,@CenterID  
 END  
  
 CLOSE FacSummary_cursor  
 DEALLOCATE FacSummary_cursor  
  
  SELECT DISTINCT  
   FS.*,  
   --TMP.I_TimeSlot_ID,  
   ED.S_Emp_ID,  
   LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) as FacultyName,  
   ED.S_Title,  
   ED.S_First_Name,  
   ED.S_Middle_Name,  
   ED.S_Last_Name,  
   CT.S_TimeSlot_Code,  
   cT.S_TimeSlot_Desc AS S_TimeSlot_Desc,  
   FN1.CenterID,  
   FN1.CenterCode,  
   FN1.CenterName,  
   FN2.InstanceChain  
    FROM @FacultySummary FS  
   INNER JOIN #TmpFacSum TMP  
   ON FS.Employee_ID=TMP.I_Employee_ID  
   INNER JOIN dbo.T_Employee_Dtls ED  
   ON FS.Employee_ID=ED.I_Employee_ID  
   LEFT OUTER JOIN dbo.T_Center_TimeSlot CT  
   ON TMP.I_TimeSlot_ID=CT.I_TimeSlot_ID  
   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
   ON ED.I_Centre_Id=FN1.CenterID  
   INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2  
   ON FN1.HierarchyDetailID=FN2.HierarchyDetailID  
  
 DROP TABLE #TmpFacSum  
  
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
