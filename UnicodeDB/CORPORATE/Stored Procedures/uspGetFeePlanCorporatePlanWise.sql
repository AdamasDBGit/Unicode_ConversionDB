CREATE PROCEDURE [CORPORATE].[uspGetFeePlanCorporatePlanWise] --14    
(      
 @iCorporatePlanID INT ,
 @iCourseID INT       
)    
AS      
BEGIN TRY      
  
SELECT FP.I_Course_Fee_Plan_ID ,  
         S_Fee_Plan_Name ,  
         I_Course_Delivery_ID ,  
         I_Course_ID ,  
         I_Currency_ID ,  
         C_Is_LumpSum ,  
         Dt_Valid_To ,  
         Dt_Crtd_On ,  
         N_TotalLumpSum ,  
         Dt_Upd_On ,  
         N_TotalInstallment ,  
         I_Status FROM dbo.T_Course_Fee_Plan FP   
         INNER JOIN  CORPORATE.T_CorporatePlan_FeePlan_Map AS tcpfpm  
         ON FP.I_Course_Fee_Plan_ID = tcpfpm.I_Course_Fee_Plan_ID  
         WHERE tcpfpm.I_Corporate_Plan_ID = @iCorporatePlanID   
         AND FP.I_Course_ID = @iCourseID
         AND FP.I_Status = 1    
         AND GETDATE() <= ISNULL(FP.Dt_Valid_To,GETDATE())    
             
  
    
END TRY      
    
BEGIN CATCH      
 --Error occurred:        
      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
