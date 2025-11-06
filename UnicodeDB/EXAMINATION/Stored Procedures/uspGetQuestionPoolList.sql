CREATE PROCEDURE [EXAMINATION].[uspGetQuestionPoolList] 
 (    
  @iQuestionBankID INT,    
  @iBrandID INT = NULL      
 )    
AS    
    
BEGIN      
 SET NOCOUNT ON;       
     
 -- from application @iBrand comming as hierarchy master id    
 SELECT @iBrandID = I_Brand_ID FROM dbo.T_Hierarchy_Brand_Details    
 WHERE I_Hierarchy_Master_ID = @iBrandID AND I_Status = 1    
    
 DECLARE @tempTable TABLE      
 (      
  I_Pool_ID INT,      
  S_Pool_Desc VARCHAR(200),  
  S_Competency_Name VARCHAR(250)      
 )      
         
 IF (@iQuestionBankID IS NULL)      
 BEGIN      
 INSERT INTO @tempTable      
 SELECT TPM.I_Pool_ID,TPM.S_Pool_Desc,A.S_Competency_Name      
 FROM EXAMINATION.T_Pool_Master TPM WITH (NOLOCK)  
 LEFT OUTER JOIN ASSESSMENT.T_Competency_Details A      
 ON TPM.I_Pool_ID = A.I_Pool_ID      
 WHERE TPM.I_Brand_ID = ISNULL(@iBrandID, TPM.I_Brand_ID) AND TPM.I_Status=1      
 ORDER BY TPM.S_Pool_Desc   
 END      
 ELSE      
 BEGIN      
  INSERT INTO @tempTable      
  SELECT TPM.I_Pool_ID,TPM.S_Pool_Desc,A.S_Competency_Name       
  FROM EXAMINATION.T_Pool_Master TPM WITH (NOLOCK)  
  LEFT OUTER JOIN ASSESSMENT.T_Competency_Details A      
  ON TPM.I_Pool_ID = A.I_Pool_ID          
  WHERE TPM.I_Pool_ID       
   IN (SELECT TBPM.I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping TBPM WITH(NOLOCK)      
    WHERE TBPM.I_Question_Bank_ID      
    IN (SELECT TQBM.I_Question_Bank_ID FROM EXAMINATION.T_Question_Bank_Master TQBM WITH(NOLOCK)      
     WHERE TQBM.I_Question_Bank_ID = @iQuestionBankID)) AND TPM.I_Status <> 0      
  ORDER BY TPM.S_Pool_Desc           
 END       
       
 SELECT I_Pool_ID,S_Pool_Desc,S_Competency_Name FROM @tempTable      
       
 SELECT I_Pool_ID, I_Question_ID, I_Complexity_ID FROM Examination.T_Question_Pool       
 WHERE I_Pool_ID IN (SELECT DISTINCT I_Pool_ID FROM @tempTable)      
END
