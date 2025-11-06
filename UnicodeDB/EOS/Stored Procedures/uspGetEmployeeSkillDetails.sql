CREATE PROCEDURE [EOS].[uspGetEmployeeSkillDetails]  
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
   ISNULL(TSM.S_Skill_Type,''),      
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
    ISNULL(TSM.S_Skill_Type,''),      
    2   
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
    ISNULL(TSM.S_Skill_Type,''),      
    2 
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
     
 CREATE TABLE #Skill      
 (      
  I_Emp_ID INT,      
  I_Skill_ID INT,      
  S_Skill_No VARCHAR(20),      
  S_Skill_Desc VARCHAR(100),      
  S_Skill_Type VARCHAR(50),      
  I_Status INT,    
  Dt_Crtd_On DATETIME NULL    
 )    
    
 INSERT INTO #Skill      
 SELECT DISTINCT #tempSkill.*,NULL FROM #tempSkill    
 
--updates the completion status to 1 of those skills which has exams attached to it. 
 UPDATE #Skill SET 
 I_Status = 1,
 Dt_Crtd_On = C.Dt_Upd_On
 FROM 
 #Skill A INNER JOIN EOS.T_Skill_Exam_Map B
 ON A.I_Skill_ID = B.I_Skill_ID
 INNER JOIN EOS.T_Employee_Exam_Result C
 ON B.I_Exam_Component_ID = C.I_Exam_Component_ID
 AND A.I_Emp_ID = C.I_Employee_ID
 WHERE (ISNULL(C.B_Passed,0)  = 1 OR ISNULL(B.Is_Pass_Mandatory,0) = 0)
 
--Updates the completion status to 1 of those skills which does not have any exams. 
	UPDATE #Skill 
		SET I_Status = 1
	WHERE I_Skill_ID IN
		(SELECT A.I_Skill_ID FROM #Skill A
			LEFT OUTER JOIN [EOS].[T_Skill_Exam_Map] B ON A.[I_Skill_ID] = B.[I_Skill_ID]
			WHERE B.[I_Exam_Component_ID] IS NULL)
 
SELECT * FROM #Skill
    
 DROP TABLE #Skill    
 DROP TABLE #tempSkill    
END
