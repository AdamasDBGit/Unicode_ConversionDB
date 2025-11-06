CREATE PROCEDURE [dbo].[GetVideoContent] 
(  
@iBatchID INT =NULL  
)  
As  
BEGIN  
  
DECLARE @dtCurrentDate DATETIME         
            
SET @dtCurrentDate = ISNULL(@dtCurrentDate,CONVERT (date, GETDATE()))   
      
SELECT * FROM dbo.T_Batch_Content_Details A   
 INNER JOIN dbo.T_Term_Master B                    
 ON A.I_Term_ID = B.I_Term_ID                    
 INNER JOIN dbo.T_Module_Master C                    
 ON A.I_Module_ID = C.I_Module_ID      
 LEFT OUTER JOIN dbo.T_Session_Master D  
 ON A.I_Session_ID = D.I_Session_ID  
 WHERE A.I_Batch_ID = @iBatchID  
                      
END
