CREATE PROCEDURE [dbo].[usGetBridgeDetails] --4  
(  
@iBridgeID INT  
)  
AS  
  
BEGIN TRY  
SELECT BCM.[I_Bridge_ID],  
    BM.[S_Bridge_Code],  
    BCM.[I_Prev_Course_ID] AS S_Prev_Course_ID,  
    CM1.[S_Course_Code] AS S_Prev_Course_Code,  
    CM1.[S_Course_Name] AS S_Prev_Course_Name,  
    BCM.[I_Next_Course_ID] AS S_Next_Course_ID,  
    CM2.[S_Course_Code] AS S_Next_Course_Code,  
    CM2.[S_Course_Name] AS S_Next_Course_Name  
     FROM dbo.[T_Bridge_Course_Mapping] BCM WITH(nolock)  
    INNER JOIN [T_Bridge_Master] BM WITH(nolock)  
    ON BCM.[I_Bridge_ID] = BM.[I_Bridge_ID]  
    INNER JOIN [T_Course_Master] CM1 WITH(nolock)  
    ON CM1.[I_Course_ID]=BCM.[I_Prev_Course_ID]  
    INNER JOIN [T_Course_Master] CM2 WITH(nolock)  
    ON CM2.[I_Course_ID]=BCM.[I_Next_Course_ID]  
    WHERE BCM.[I_Bridge_ID]=@iBridgeID  
    AND BCM.[I_Status]=1  
    AND BM.[I_Status]=1  
    AND CM1.[I_Status]=1  
    AND CM2.[I_Status]=1  
    ORDER BY BCM.[Dt_Crtd_On] ASC   
  
END TRY  
  
BEGIN CATCH      
 --Error occurred:        
      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH   

------------------------------------------------------------------------------------------------------------------------------------------
