CREATE PROCEDURE [EOS].[uspGetEmployeeExamDetails]
(    
 @iEmployeeID INT    
)    
AS    
BEGIN    
 DECLARE @iCenterID INT, @iRowCount INT, @iBrandID INT    
 SELECT @iCenterID = I_Centre_ID FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmployeeID    
 SELECT @iBrandID = I_Brand_ID FROM dbo.T_Brand_Center_Details WHERE I_Centre_Id = @iCenterID    
     
 CREATE TABLE #tempSkill    
 (    
  I_Emp_ID INT,    
  I_Skill_ID INT,    
  S_Skill_No VARCHAR(20),    
  S_Skill_Desc VARCHAR(100),    
  S_Skill_Type VARCHAR(50),    
  I_Status INT    
 )    
    
 INSERT INTO #tempSkill    
 SELECT  @iEmployeeID,    
   TESM.I_Skill_ID,          
   TSM.S_Skill_No,    
   TSM.S_Skill_Desc,    
   TSM.S_Skill_Type,    
   TESM.I_Status    
 FROM EOS.T_Employee_Skill_Map TESM WITH(NOLOCK)    
 INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)    
 ON TESM.I_Skill_ID=TSM.I_Skill_ID    
 WHERE TESM.I_Status <> 0    
  AND TESM.I_Employee_ID = @iEmployeeID    
     
 SELECT @iRowCount = COUNT(TRSM.I_Skill_ID) FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)    
 INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)    
 ON TERM.I_Role_ID = TRSM.I_Role_ID    
 WHERE TERM.I_Status_ID <> 0    
  AND TRSM.I_Status <> 0    
  AND TERM.I_Employee_ID = @iEmployeeID      
  AND TRSM.I_Centre_ID = @iCenterID    
  AND TRSM.I_Brand_ID = @iBrandID    
      
 IF (@iRowCount = 0)    
 BEGIN      
  INSERT INTO #tempSkill    
  SELECT  @iEmployeeID,    
    TRSM.I_Skill_ID,    
    TSM.S_Skill_No,    
    TSM.S_Skill_Desc,    
    TSM.S_Skill_Type,    
    TRSM.I_Status    
  FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)    
  INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)    
  ON TERM.I_Role_ID = TRSM.I_Role_ID    
  INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)    
  ON TRSM.I_Skill_ID = TSM.I_Skill_ID    
  WHERE TERM.I_Status_ID <> 0    
   AND TRSM.I_Status <> 0    
   AND TERM.I_Employee_ID = @iEmployeeID       
   AND TRSM.I_Centre_ID IS NULL    
   AND TRSM.I_Brand_ID = @iBrandID    
 END    
 ELSE    
 BEGIN      
  INSERT INTO #tempSkill    
  SELECT  @iEmployeeID,    
    TRSM.I_Skill_ID,    
    TSM.S_Skill_No,    
    TSM.S_Skill_Desc,    
    TSM.S_Skill_Type,    
    TRSM.I_Status    
  FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)    
  INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)    
  ON TERM.I_Role_ID = TRSM.I_Role_ID    
  INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)    
  ON TRSM.I_Skill_ID = TSM.I_Skill_ID    
  WHERE TERM.I_Status_ID <> 0    
   AND TRSM.I_Status <> 0    
   AND TERM.I_Employee_ID = @iEmployeeID    
   AND TRSM.I_Centre_ID = @iCenterID    
   AND TRSM.I_Brand_ID = @iBrandID    
 END    
     
 CREATE TABLE #tempExam    
  (    
   I_Emp_ID INT,    
   I_Skill_ID INT,    
   I_Exam_Component_ID INT,    
   S_Component_Name VARCHAR(200),    
   S_Component_Type VARCHAR(10),    
   I_Exam_Stage INT,    
   I_Number_Of_Resits INT,    
   I_No_Of_Attempts INT,    
   I_Cut_Off INT,    
   I_Status INT,    
   Is_Pass_Mandatory BIT,    
   B_Appeared BIT,    
   B_Passed BIT,    
   N_Marks NUMERIC(8,2),  
   Dt_Crtd_On DATETIME NULL   
  )    
      
 SELECT @iRowCount = COUNT(TSEM.I_Exam_Component_ID) FROM EOS.T_Skill_Exam_Map TSEM     
 WHERE I_Skill_ID IN (SELECT I_Skill_ID FROM #tempSkill)    
  AND I_Status <> 0    
  AND TSEM.I_Centre_ID = @iCenterID    
      
 IF (@iRowCount = 0)    
 BEGIN       
  INSERT INTO #tempExam    
  -- Get the Skill Exam Details    
  SELECT  T.I_Emp_ID,    
    TSEM.I_Skill_ID,    
    TSEM.I_Exam_Component_ID,    
    TECM.S_Component_Name,    
    TECM.S_Component_Type,    
    TSEM.I_Exam_Stage,    
    TSEM.I_Number_Of_Resits,    
    0,    
    TSEM.I_Cut_Off,    
    TSEM.I_Status,    
    TSEM.Is_Pass_Mandatory,    
    0,0,0,NULL    
  FROM #tempSkill T WITH(NOLOCK)    
  INNER JOIN EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
  ON T.I_Skill_ID = TSEM.I_Skill_ID    
  INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
  ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
  WHERE TSEM.I_Status <> 0    
   AND TSEM.I_Centre_ID IS NULL    
 END    
 ELSE    
 BEGIN    
  INSERT INTO #tempExam    
  -- Get the Skill Exam Details    
  SELECT  T.I_Emp_ID,    
    TSEM.I_Skill_ID,    
    TSEM.I_Exam_Component_ID,    
    TECM.S_Component_Name,    
    TECM.S_Component_Type,    
    TSEM.I_Exam_Stage,    
    TSEM.I_Number_Of_Resits,    
    0,    
    TSEM.I_Cut_Off,    
    TSEM.I_Status,    
    TSEM.Is_Pass_Mandatory,    
    0,0,0,NULL   
  FROM #tempSkill T WITH(NOLOCK)    
  INNER JOIN EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
  ON T.I_Skill_ID = TSEM.I_Skill_ID    
  INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
  ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
  WHERE TSEM.I_Status <> 0    
   AND TSEM.I_Centre_ID = @iCenterID    
 END    
     
 -- get the employee exam details    
 UPDATE #tempExam    
 SET #tempExam.B_Appeared = 1,    
  #tempExam.B_Passed = TEER.B_Passed,    
  --#tempExam.N_Marks = TEER.N_Marks,    

#tempExam.N_Marks=isnull((
					select max(n_marks) from EOS.T_Employee_Exam_Result where I_Employee_ID = @iEmployeeID
					and I_Exam_Component_ID = TEER.I_Exam_Component_ID),0),

  --#tempExam.I_No_Of_Attempts = ISNULL(#tempExam.I_No_Of_Attempts,0) + 1,  
		#tempExam.I_No_Of_Attempts = (select count(*) from EOS.T_Employee_Exam_Result 
						where I_Employee_ID = @iEmployeeID
						and I_Exam_Component_ID = TEER.I_Exam_Component_ID),

  #tempExam.Dt_Crtd_On = TEER.Dt_Crtd_On   
 FROM EOS.T_Employee_Exam_Result TEER    
 WHERE #tempExam.I_Emp_ID = TEER.I_Employee_ID    
  AND #tempExam.I_Exam_Component_ID = TEER.I_Exam_Component_ID    
  AND TEER.B_Passed = 0    
  --AND ISNULL(#tempExam.N_Marks,0) < ISNULL(TEER.N_Marks,0)    
     
 UPDATE #tempExam    
 SET #tempExam.B_Appeared = 1,    
  #tempExam.B_Passed = TEER.B_Passed,    
--  #tempExam.N_Marks = TEER.N_Marks,    
#tempExam.N_Marks=isnull((
					select max(n_marks) from EOS.T_Employee_Exam_Result where I_Employee_ID = @iEmployeeID
					and I_Exam_Component_ID = TEER.I_Exam_Component_ID),0),

  --#tempExam.I_No_Of_Attempts = ISNULL(#tempExam.I_No_Of_Attempts,0) + 1 ,  
		#tempExam.I_No_Of_Attempts = (select count(*) from EOS.T_Employee_Exam_Result
						where I_Employee_ID = @iEmployeeID
						and I_Exam_Component_ID = TEER.I_Exam_Component_ID),

  #tempExam.Dt_Crtd_On = TEER.Dt_Crtd_On    
 FROM EOS.T_Employee_Exam_Result TEER    
 WHERE #tempExam.I_Emp_ID = TEER.I_Employee_ID    
  AND #tempExam.I_Exam_Component_ID = TEER.I_Exam_Component_ID    
  AND TEER.B_Passed = 1    
      
 SELECT DISTINCT * FROM #tempSkill    
 SELECT DISTINCT * FROM #tempExam

 DROP TABLE #tempSkill
 DROP TABLE #tempExam
    
END
