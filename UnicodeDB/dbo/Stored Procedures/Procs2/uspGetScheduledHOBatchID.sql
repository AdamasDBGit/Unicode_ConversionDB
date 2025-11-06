CREATE PROC [dbo].[uspGetScheduledHOBatchID]   
(    
 @iBrandID INT,    
 @iCourseID int
)    
AS     
BEGIN TRY    
 SELECT STUFF(    
 (    
  SELECT ','+CAST(I_Batch_ID AS VARCHAR(10)) FROM    
  (    
  SELECT DISTINCT A.I_Batch_ID FROM dbo.T_Student_Batch_Schedule A    
  INNER JOIN dbo.T_Brand_Center_Details B    
  ON ISNULL(A.I_Centre_ID,B.I_Centre_Id) = B.I_Centre_Id 
  INNER JOIN dbo.T_Student_Batch_Master SBM
  ON A.I_Batch_ID = sbm.I_Batch_ID     
  WHERE I_Brand_ID = @iBrandID  
  AND sbm.I_Course_ID = @iCourseID  
  ) T FOR XML PATH('')    
 ),1,1,'') AS BatchIds    
END TRY     
BEGIN CATCH      
 --Error occurred:        
      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
