CREATE PROCEDURE [MBP].[uspGetCourseFamilyList]    
(    
@iBrandID INT = NULL,  
@sCourseCode VARCHAR(100) = NULL    
)    
AS    
 BEGIN TRY        
  
 SELECT     
 ISNULL(CFM.I_CourseFamily_ID,0) AS I_CourseFamily_ID,    
 ISNULL(CFM.S_CourseFamily_Name,'') AS S_CourseFamily_Name,    
 ISNULL(CFM.I_Brand_ID ,0) AS I_Brand_ID    
 FROM  dbo.T_CourseFamily_Master CFM    
 WHERE CFM.I_Status != 0    
 AND CFM.I_Brand_ID = COALESCE(@iBrandID,CFM.I_Brand_ID)  
 AND CFM.S_CourseFamily_Name like '%' + @sCourseCode + '%' 
 ORDER BY CFM.S_CourseFamily_Name ASC 

 END TRY    
   BEGIN CATCH    
   --Error occurred:      
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    SELECT @ErrMsg = ERROR_MESSAGE(),    
      @ErrSeverity = ERROR_SEVERITY()    
    RAISERROR(@ErrMsg, @ErrSeverity, 1)    
   END CATCH
