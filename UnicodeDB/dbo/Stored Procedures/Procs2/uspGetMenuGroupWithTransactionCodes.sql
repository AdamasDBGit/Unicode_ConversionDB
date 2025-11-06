CREATE PROCEDURE [dbo].[uspGetMenuGroupWithTransactionCodes]
(
@iBrandID INT
)  
                    
AS                          
BEGIN       


SELECT tmgm.I_Menu_Group_ID ,
        S_Menu_Group_Name ,
        S_Transaction_Code 
        INTO #temp
        FROM dbo.T_Menu_Group_Master AS tmgm
INNER JOIN dbo.T_Transaction_Master AS ttm
ON tmgm.I_Menu_Group_ID = ttm.I_Menu_Group_ID
WHERE tmgm.I_Status = 1 AND ttm.I_Status = 1
AND S_Menu_Group_Name LIKE 'Reports%'
AND ttm.I_Brand_ID=@iBrandID

UNION ALL

SELECT tmgm.I_Menu_Group_ID ,
        S_Menu_Group_Name ,
        S_Transaction_Code 
        FROM dbo.T_Menu_Group_Master AS tmgm
INNER JOIN dbo.T_Transaction_Master AS ttm
ON tmgm.I_Menu_Group_ID = ttm.I_Menu_Group_ID
WHERE tmgm.I_Status = 1 AND ttm.I_Status = 1
AND S_Menu_Group_Name LIKE 'Reports%'
AND ttm.I_Brand_ID IS NULL

ORDER BY tmgm.S_Menu_Group_Name


 SELECT  DISTINCT t4.I_Menu_Group_ID,t4.S_Menu_Group_Name,     
 TransactionCodes = STUFF((SELECT ', '+ +CAST(t3.S_Transaction_Code AS VARCHAR(8))     
 FROM #temp AS t3            
 WHERE t3.I_Menu_Group_ID = t4.I_Menu_Group_ID      
 ORDER BY t3.I_Menu_Group_ID            
 FOR XML PATH('')),1,1,'')         
 FROM #temp AS t4      
 ORDER BY t4.S_Menu_Group_Name
     

 DROP TABLE #temp  
 
       
 END
