CREATE PROCEDURE [ASSESSMENT].[uspGetCompetencyName]      
 (      
    @iQuestionPoolID INT = NULL        
 )      
AS      
      
BEGIN        
 SET NOCOUNT ON;            
       
         
SELECT tcd.I_Pool_ID,tcd.S_Competency_Name FROM ASSESSMENT.T_Competency_Details tcd WHERE  
tcd.I_Pool_ID = ISNULL(@iQuestionPoolID, tcd.I_Pool_ID) AND tcd.I_Status=1        
   
END
