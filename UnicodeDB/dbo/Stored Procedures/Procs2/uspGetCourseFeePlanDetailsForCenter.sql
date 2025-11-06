CREATE PROCEDURE [dbo].[uspGetCourseFeePlanDetailsForCenter] ---743,2480,29,14    
(    
  @iCenterID int = NULL,    
  @iCourseID int = NULL,    
  @I_Delivery_Pattern_ID int = NULL,
  @iCorporatePlanID  INT = NULL  
)    
 AS    
BEGIN TRY    

 --SELECT B.I_Course_Fee_Plan_ID ,    
 --        B.S_Fee_Plan_Name ,    
 --        B.I_Currency_ID ,    
 --        B.N_TotalLumpSum ,    
 --        B.N_TotalInstallment     
 --    FROM dbo.T_Course_Center_Detail X         
 --    INNER JOIN dbo.T_Course_Center_Delivery_FeePlan Y       
 --    ON X.I_Course_Center_ID = Y.I_Course_Center_ID        
 --    INNER JOIN dbo.T_Course_Delivery_Map C        
 --    ON Y.I_Course_Delivery_ID = C.I_Course_Delivery_ID       
 --    INNER JOIN dbo.T_Delivery_Pattern_Master Z      
 --    ON Z.I_Delivery_Pattern_ID = C.I_Delivery_Pattern_ID      
 --    INNER JOIN dbo.T_Course_Fee_Plan B        
 --    ON Y.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID        
 --    INNER JOIN dbo.T_Course_Master A        
 --    ON X.I_Course_ID = A.I_Course_ID     
 --    WHERE I_Centre_Id = ISNULL(@iCenterID,I_Centre_Id)    
 --    AND A.I_Course_ID = ISNULL(@iCourseID,A.I_Course_ID)    
 --    AND C.I_Delivery_Pattern_ID = ISNULL(@I_Delivery_Pattern_ID,C.I_Delivery_Pattern_ID)    
 --    AND X.I_STATUS <> 0 AND Y.I_STATUS <> 0 AND C.I_STATUS <> 0 AND B.I_STATUS <> 0 AND A.I_STATUS <> 0      
 --    AND GETDATE() >= ISNULL(Y.Dt_Valid_From,GETDATE()) AND GETDATE() <= ISNULL(Y.Dt_Valid_To,GETDATE())  
 --    AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE()) 
 
    
    SELECT B.I_Course_Fee_Plan_ID ,
B.S_Fee_Plan_Name ,
B.I_Currency_ID ,
B.N_TotalLumpSum ,
B.N_TotalInstallment
FROM dbo.T_Course_Center_Detail X
INNER JOIN dbo.T_Course_Center_Delivery_FeePlan Y
ON X.I_Course_Center_ID = Y.I_Course_Center_ID
INNER JOIN dbo.T_Course_Delivery_Map C
ON Y.I_Course_Delivery_ID = C.I_Course_Delivery_ID
INNER JOIN dbo.T_Delivery_Pattern_Master Z
ON Z.I_Delivery_Pattern_ID = C.I_Delivery_Pattern_ID
INNER JOIN dbo.T_Course_Fee_Plan B
ON Y.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID
INNER JOIN dbo.T_Course_Master A
ON X.I_Course_ID = A.I_Course_ID
LEFT OUTER JOIN CORPORATE.T_CorporatePlan_FeePlan_Map AS tcpfpm
ON B.I_Course_Fee_Plan_ID = tcpfpm.I_Course_Fee_Plan_ID
WHERE I_Centre_Id = ISNULL(@iCenterID,I_Centre_Id)
AND A.I_Course_ID = ISNULL(@iCourseID,A.I_Course_ID)
AND C.I_Delivery_Pattern_ID = ISNULL(@I_Delivery_Pattern_ID,C.I_Delivery_Pattern_ID)
AND ISNULL(tcpfpm.I_Corporate_Plan_ID,0) = ISNULL(@iCorporatePlanID,ISNULL(tcpfpm.I_Corporate_Plan_ID,0))
AND X.I_STATUS <> 0 AND Y.I_STATUS <> 0 AND C.I_STATUS <> 0 AND B.I_STATUS <> 0 AND A.I_STATUS <> 0
AND GETDATE() >= ISNULL(Y.Dt_Valid_From,GETDATE()) AND GETDATE() <= ISNULL(Y.Dt_Valid_To,GETDATE())
AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE())

       
END TRY    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
