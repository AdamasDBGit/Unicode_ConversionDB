CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlanBatchId] 
           
 --@iCorporatePlanID int            
            
            
            
AS            
            
BEGIN            
 SET NOCOUNT ON;            
   
   --SELECT I_Corporate_Plan_ID ,
   --        I_Batch_ID 
   --        INTO #temp
   --        FROM  CORPORATE.T_Corporate_Plan_Batch_Map AS tcpbm
   --        --WHERE tcpbm.I_Corporate_Plan_ID = @iCorporatePlanID
           
   --       SELECT DISTINCT  
   --       BatchIds = STUFF((SELECT ', '+ +CAST(t1.I_Batch_ID AS VARCHAR(8))        
		 -- FROM #temp AS t1          
		 -- WHERE t1.I_Corporate_Plan_ID = t2.I_Corporate_Plan_ID    
		 -- ORDER BY t1.I_Corporate_Plan_ID          
		 -- FOR XML PATH('')),1,1,'')  
		  
		 -- FROM  #temp AS t2
             
   
   --DROP TABLE #temp    
   
   SELECT DISTINCT I_Batch_ID  FROM CORPORATE.T_Corporate_Plan_Batch_Map
       
END
