CREATE PROCEDURE [EXAMINATION].[uspGetInterviewQuestionPaper] 
(  
 @iExamComponentID INT,    
 @iFeedbackTypeID INT = NULL    
 )  
AS    
    
BEGIN    
 SET NOCOUNT ON; 
     
   SELECT DISTINCT tfm.I_Feedback_Group_ID,S_Description FROM ACADEMICS.T_Feedback_Group AS tfg
   INNER JOIN ACADEMICS.T_Feedback_Master AS tfm
   ON tfg.I_Feedback_Group_ID = tfm.I_Feedback_Group_ID
   WHERE tfm.I_Exam_Component_ID = @iExamComponentID AND tfm.I_Status = 1  AND tfm.I_Feedback_Type_ID = @iFeedbackTypeID
   
 CREATE TABLE #TEMPBANK    
 (     
  ID_Identity int identity(1,1),   
  I_Feedback_Master_ID INT,  
  I_Feedback_Group_ID INT,  
  I_Exam_Component_ID INT,  
  S_Feedback_Question VARCHAR(500),  
  I_Status INT  
 )    
   
 CREATE TABLE #tempTable    
 (     
  I_Feedback_Option_Master_ID INT,  
  I_Feedback_Master_ID INT,  
  S_Feedback_Option_Name VARCHAR(500),  
  I_Value INT,  
  I_Status INT  
 )    
   
 INSERT INTO #TEMPBANK   
 SELECT I_Feedback_Master_ID,I_Feedback_Group_ID,I_Exam_Component_ID,S_Feedback_Question,I_Status FROM ACADEMICS.T_Feedback_Master AS tfm  
 WHERE tfm.I_Exam_Component_ID = @iExamComponentID AND tfm.I_Status = 1  AND tfm.I_Feedback_Type_ID = @iFeedbackTypeID
   
 DECLARE @iCount INT    
 DECLARE @iRowCount INT    
 DECLARE @iFeedbackMasterId INT    
 SELECT @iRowCount = count(ID_Identity) FROM #TEMPBANK    
 SET @iCount = 1    
   
 WHILE (@iCount <= @iRowCount)    
 BEGIN    
   
  SELECT @iFeedbackMasterId = I_Feedback_Master_ID from #TEMPBANK where ID_Identity = @iCount    
    
  INSERT INTO #tempTable    
  SELECT I_Feedback_Option_Master_ID,I_Feedback_Master_ID,S_Feedback_Option_Name,I_Value,I_Status  
  FROM ACADEMICS.T_Feedback_Option_Master WHERE  
  I_Feedback_Master_ID = @iFeedbackMasterId AND I_Status = 1    
      
  SET @iCount = @iCount + 1    
    
 END   
   
 SELECT * FROM #TEMPBANK   
 SELECT * FROM #tempTable    
  
   
 TRUNCATE TABLE #tempTable    
 DROP TABLE #tempTable    
    
 TRUNCATE TABLE #TEMPBANK    
 DROP TABLE #TEMPBANK    
   
END
