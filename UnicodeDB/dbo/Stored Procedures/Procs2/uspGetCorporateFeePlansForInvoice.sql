CREATE PROCEDURE [dbo].[uspGetCorporateFeePlansForInvoice]
(
	@CorporateId INT = NULL,
	@CenterId INT = NULL	
)
AS
BEGIN  
SELECT A.I_Center_Corp_Plan_ID,    
    A.I_Corporate_ID,    
    A.I_Course_Fee_Plan_ID, 
    C.I_Course_ID,   
    A.S_Fee_Plan_Name,    
    A.Dt_Valid_From,    
    A.Dt_Valid_To,    
    A.I_Corporate_Type_ID,    
    A.N_Minimum_Amount,    
    A.I_Max_Strength,    
    B.N_TotalLumpSum,    
    B.N_TotalInstallment,'<Root>'+[dbo].[fnGetCorporatePlanDetails](A.I_Center_Corp_Plan_ID)+'</Root>' AS CorporatePlan_Details    
FROM dbo.T_Center_Corporate_Plan A    
INNER JOIN dbo.T_Course_Fee_Plan B    
ON A.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID    
INNER JOIN dbo.T_Course_Master C
ON B.I_Course_ID = C.I_Course_ID
WHERE A.I_Corporate_ID = ISNULL(@CorporateId, A.I_Corporate_ID)   
AND A.I_Centre_Id = ISNULL(@CenterId, A.I_Centre_Id)   
AND A.I_Corporate_Type_ID <> 1  
AND A.I_Status = 1    
AND B.I_Status = 1 
 
  
END
