CREATE PROCEDURE [ASSESSMENT].[uspGetStepDetails]          
 (        
   @iRuleID INT = NULL        
 )           
AS            
BEGIN            
    IF( @iRuleID IS NULL)        
     BEGIN        
    SELECT tsd.I_Step_ID,trsm.I_Rule_ID,tsd.S_Step_Name,tsd.I_Parameter_ID,tpm.S_ParameterName,          
    tsd.S_Parameter_Values,tsd.I_EvaluationCriteria_ID,tem.S_EvaluationName,          
    tsd.N_Min_Range,tsd.N_Max_Range,tsd.N_Min_Percent_Range,          
    tsd.N_Max_Percent_Range,tsd.N_CutOff_Score,tsd.I_Step_ID,          
    tsd.S_Crtd_By,tsd.Dt_Crtd_On,tsd.S_Updt_By,tsd.Dt_Updt_On          
    From ASSESSMENT.T_Step_Details AS tsd          
    INNER JOIN ASSESSMENT.T_Parameter_Master AS tpm          
    ON tsd.I_Parameter_ID = tpm.I_ParameterID          
    INNER JOIN ASSESSMENT.T_Evaluation_Master AS tem          
    ON tsd.I_EvaluationCriteria_ID = tem.I_EvaluationID         
    INNER JOIN ASSESSMENT.T_Rule_Step_Map AS trsm        
    ON tsd.I_Step_ID=trsm.I_Step_ID        
    WHERE tsd.I_Status=1   
    ORDER BY tsd.I_Step_ID         
     END        
    ELSE        
     BEGIN        
  SELECT tsd.I_Step_ID,trsm.I_Rule_ID,tsd.S_Step_Name,tsd.I_Parameter_ID,tpm.S_ParameterName,          
    tsd.S_Parameter_Values,tsd.I_EvaluationCriteria_ID,tem.S_EvaluationName,          
    tsd.N_Min_Range,tsd.N_Max_Range,tsd.N_Min_Percent_Range,          
    tsd.N_Max_Percent_Range,tsd.N_CutOff_Score,tsd.I_Step_ID,          
    tsd.S_Crtd_By,tsd.Dt_Crtd_On,tsd.S_Updt_By,tsd.Dt_Updt_On          
    From ASSESSMENT.T_Step_Details AS tsd          
    INNER JOIN ASSESSMENT.T_Parameter_Master AS tpm          
    ON tsd.I_Parameter_ID = tpm.I_ParameterID          
    INNER JOIN ASSESSMENT.T_Evaluation_Master AS tem          
    ON tsd.I_EvaluationCriteria_ID = tem.I_EvaluationID         
    INNER JOIN ASSESSMENT.T_Rule_Step_Map AS trsm        
    ON tsd.I_Step_ID=trsm.I_Step_ID        
    WHERE tsd.I_Status=1   AND trsm.I_Rule_ID = @iRuleID        
    ORDER BY tsd.I_Step_ID     
     END           
           
            
END
