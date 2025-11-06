CREATE PROCEDURE [ASSESSMENT].[uspAddCompetencyDetailsSkillMapping]      
(    
 @iCompetencyID INT,    
 @sSkillIds VARCHAR(MAX),    
 @sCrtdBy varchar(50) = NULL,    
 @dtCrtdOn datetime = NULL,    
 @sUpdtBy varchar(50) = NULL,    
 @dtUpdtOn datetime =  NULL      
)    
AS     
BEGIN    
 DELETE FROM ASSESSMENT.T_Skill_Competency_Map WHERE I_Competency_ID = @iCompetencyID    
     
 declare @xml_hndl int    
     
 --prepare the XML Document by executing a system stored procedure    
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sSkillIds    
     
 Insert Into ASSESSMENT.T_Skill_Competency_Map  
            (    
             I_Competency_ID,    
             I_Skill_ID,    
             S_Ctrd_by,  
             S_Updt_by,    
             Dt_Crtd_On,  
             Dt_Updt_On    
            )    
   Select    
            @iCompetencyID,IDToInsert,@sCrtdBy,@sUpdtBy,@dtCrtdOn,@dtUpdtOn    
From    
            OPENXML(@xml_hndl, '/Root/Skills', 1)    
            With    
                        (    
                        IDToInsert int '@ID'    
                        )    
END
