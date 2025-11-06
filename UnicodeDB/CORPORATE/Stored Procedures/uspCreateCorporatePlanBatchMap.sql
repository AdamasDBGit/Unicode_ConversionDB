CREATE PROCEDURE [CORPORATE].[uspCreateCorporatePlanBatchMap]                 
(                   
  @iBatchID INT,          
  @iCorporatePlanID INT         
       
)                  
AS                  
BEGIN TRY       
 
 INSERT INTO CORPORATE.T_Corporate_Plan_Batch_Map
         ( 
           I_Corporate_Plan_ID, 
           I_Batch_ID 
          )
 VALUES  ( 
           @iCorporatePlanID, -- I_Corporate_Plan_ID - int
           @iBatchID  -- I_Batch_ID - int
         )
       

END TRY          
BEGIN CATCH          
 --Error occurred:            
          
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
 SELECT @ErrMsg = ERROR_MESSAGE(),          
   @ErrSeverity = ERROR_SEVERITY()          
          
 RAISERROR(@ErrMsg, @ErrSeverity, 1)          
END CATCH
