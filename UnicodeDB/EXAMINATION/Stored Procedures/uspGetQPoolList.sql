CREATE PROCEDURE [EXAMINATION].[uspGetQPoolList]    
 (    
    @iBrandID INT = NULL      
 )    
AS    
    
BEGIN      
 SET NOCOUNT ON;          
     
       
 SELECT tpm.I_Pool_ID,S_Pool_Desc FROM EXAMINATION.T_Pool_Master AS tpm     
 WHERE tpm.I_Brand_ID = ISNULL(@iBrandID, tpm.I_Brand_ID) AND tpm.I_Status=1      
 
END
