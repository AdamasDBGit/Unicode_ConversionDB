CREATE PROCEDURE [ASSESSMENT].[uspAddEditCompetencyDetails]      
(      
    @iCompetencyID INT = NULL,      
    @sCompetencyCode varchar(150),    
    @sCompetencyName varchar(250),    
    @iStatus int,    
    @iBrandId int,    
    @iPoolId int,  
    @sCrtdBy varchar(50) = NULL,    
    @dtCrtdOn datetime = NULL,    
    @sUpdtBy varchar(50) = NULL,    
    @dtUpdtOn datetime = null     
)      
AS      
BEGIN     
 IF(@iCompetencyID IS NULL)    
  BEGIN    
   INSERT INTO ASSESSMENT.T_Competency_Details  
           (   
             I_Brand_ID ,    
             I_Pool_ID ,  
             S_Competency_Code,    
             S_Competency_Name ,    
             I_Status ,    
             S_Crtd_By ,    
             S_Upd_By ,    
             Dt_Crtd_On ,    
             Dt_Upd_On    
           )    
   VALUES  (   
             @iBrandId ,   
             @iPoolId ,   
             @sCompetencyCode ,   
             @sCompetencyName ,  
             @iStatus ,   
             @sCrtdBy ,     
             NULL , -- S_Upd_By - varchar(50)    
             @dtCrtdOn , -- Dt_Crtd_On - datetime    
             NULL  -- Dt_Upd_On - datetime    
           )    
   SELECT @@IDENTITY    
  END    
ELSE     
  BEGIN    
    
   UPDATE ASSESSMENT.T_Competency_Details SET     
       I_Pool_ID = @iPoolId,  
       S_Competency_Code = @sCompetencyCode,    
       S_Competency_Name = @sCompetencyName,    
       I_Status = @iStatus,    
       S_Upd_By = @sUpdtBy,    
       Dt_Upd_On = @dtUpdtOn    
   WHERE I_Competency_ID = @iCompetencyID    
     
   SELECT @iCompetencyID    
  END    
END
