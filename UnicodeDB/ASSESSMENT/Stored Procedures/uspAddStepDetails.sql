CREATE PROCEDURE [ASSESSMENT].[uspAddStepDetails]    
(  
    @sStepName varchar(50),  
    @iParameterID INT,  
    @sParameterValues VARCHAR(250)= NULL,  
    @iEvaluationCriteriaID int,  
    @dMinRange decimal = NULL,  
    @dMaxRange decimal = NULL,  
    @dMinPercentRange decimal = NULL,  
    @dMaxPercentRange decimal = NULL,  
    @dCutOffScore decimal = NULL,  
    @iStatus int = NULL,  
    @sCrtdBy varchar(20) = NULL,  
    @dtCrtdOn datetime = NULL  
     
     
)  
AS  
BEGIN  
INSERT INTO ASSESSMENT.T_Step_Details  
        (   
          S_Step_Name ,  
          I_Parameter_ID ,  
          S_Parameter_Values ,  
          I_EvaluationCriteria_ID ,  
          N_Min_Range ,  
          N_Max_Range ,  
          N_Min_Percent_Range ,  
          N_Max_Percent_Range ,  
          N_CutOff_Score ,  
          I_Status ,  
          S_Crtd_By ,  
          Dt_Crtd_On ,  
          S_Updt_By ,  
          Dt_Updt_On  
        )  
VALUES  (   
          @sStepName ,   
          @iParameterID ,   
          @sParameterValues ,   
          @iEvaluationCriteriaID ,   
          @dMinRange ,   
          @dMaxRange ,   
          @dMinPercentRange ,   
          @dMaxPercentRange ,   
          @dCutOffScore ,   
          @iStatus ,   
          @sCrtdBy ,   
          @dtCrtdOn ,   
          NULL ,  
          NULL  
        )  
          
        SELECT @@IDENTITY  
END
