CREATE PROCEDURE [ASSESSMENT].[uspGetCompetencyDetailsList]       
(      
 @iBrandId int       
)       
AS       
BEGIN      
 --Table[1] for the list of Competency Details    
 SELECT * FROM ASSESSMENT.T_Competency_Details WHERE I_Status = 1 AND I_Brand_ID = @iBrandId      
       
 --Table[2] for the Competency Details Skill Mapping      
 SELECT B.I_Competency_ID,A.I_Skill_ID, A.S_Skill_Desc    
 FROM dbo.T_EOS_Skill_Master A      
 INNER JOIN ASSESSMENT.T_Skill_Competency_Map B      
 ON A.I_Skill_ID= B.I_Skill_ID    
 WHERE A.I_Brand_ID = @iBrandId      
 AND A.I_Status = 1      
      
       
END
