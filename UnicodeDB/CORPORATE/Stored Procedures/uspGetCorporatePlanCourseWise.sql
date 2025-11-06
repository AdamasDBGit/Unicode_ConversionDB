CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlanCourseWise] --1,2480       
(    
 @iCorporateID INT,
 @iCourseID INT  
)  
AS    
BEGIN TRY    
  
SELECT DISTINCT TCP1.I_Corporate_Plan_ID,TCP1.S_Corporate_Plan_Name   
FROM CORPORATE.T_CorporatePlan_FeePlan_Map AS TCPFPM  
INNER JOIN CORPORATE.T_Corporate_Plan AS TCP1  
ON TCPFPM.I_Corporate_Plan_ID = TCP1.I_Corporate_Plan_ID  
INNER JOIN dbo.T_Course_Fee_Plan AS TCFP  
ON TCPFPM.I_Course_Fee_Plan_ID = TCFP.I_Course_Fee_Plan_ID  
WHERE I_Corporate_ID = @iCorporateID  
AND I_Course_ID = @iCourseID  
AND TCP1.Dt_Valid_To >= CONVERT(DATE, GETDATE()) 

END TRY    
  
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
