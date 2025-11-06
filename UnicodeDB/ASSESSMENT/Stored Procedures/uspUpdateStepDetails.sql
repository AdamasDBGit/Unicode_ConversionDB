CREATE PROCEDURE [ASSESSMENT].[uspUpdateStepDetails]        
(      
    @iStepID INT,      
    @iEvaluationCriteriaID INT ,     
    @dMinRange decimal = NULL,      
    @dMaxRange decimal = NULL,      
    @dMinPercentRange decimal = NULL,      
    @dMaxPercentRange decimal = NULL,      
    @dCutOffScore decimal = NULL,      
    @iStatus int = NULL,      
    @sUpdatedBy varchar(20) = NULL,      
    @dtUpdateOn datetime = NULL  ,  
    @sStepName varchar(50)    
         
         
)      
AS      
BEGIN      
    
UPDATE ASSESSMENT.T_Step_Details    
SET    
I_EvaluationCriteria_ID = @iEvaluationCriteriaID,    
N_Min_Range = @dMinRange,    
N_Max_Range = @dMaxRange,    
N_Min_Percent_Range = @dMinPercentRange,    
N_Max_Percent_Range = @dMaxPercentRange,    
N_CutOff_Score = @dCutOffScore,       
S_Updt_By = @sUpdatedBy,    
Dt_Updt_On  = @dtUpdateOn ,  
S_Step_Name = @sStepName   
    
WHERE I_Step_ID = @iStepID    
AND I_Status = @iStatus         
    
           
END
