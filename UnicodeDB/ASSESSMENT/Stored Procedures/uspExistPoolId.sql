CREATE PROCEDURE [ASSESSMENT].[uspExistPoolId]     
 (          
    @iPoolID INT = NULL,    
    @iCompetencyID  INT = NULL          
 )          
AS          
          
BEGIN            
 SET NOCOUNT ON;                
 DECLARE @iFlag Int    
           
 IF EXISTS( SELECT  I_Pool_ID FROM  ASSESSMENT.T_Competency_Details AS tcd WHERE tcd.I_Pool_ID = ISNULL(@iPoolID, tcd.I_Pool_ID))             
  BEGIN    
   IF EXISTS(SELECT  I_Pool_ID FROM  ASSESSMENT.T_Competency_Details AS tcd WHERE tcd.I_Pool_ID = ISNULL(@iPoolID, tcd.I_Pool_ID) AND tcd.I_Competency_ID = @iCompetencyID)     
    BEGIN    
      SET @iFlag = 1     
    END            
   ELSE    
    BEGIN    
     SET @iFlag = 0    
    END      
  END       
 ELSE    
  BEGIN    
   SET @iFlag = 1    
  END    
    
SELECT @iFlag  
    
    
END
