CREATE PROCEDURE [dbo].[uspValidateUpgradeCourseEnrollment]
(    
@iStudentDetailID INT,    
@iCourseID INT    
)    
AS    
SET NOCOUNT ON    
BEGIN    
IF EXISTS (    
   SELECT 'TRUE' FROM [T_Student_Upgrade_Detail] WITH (nolock)    
   WHERE I_Course_ID = @iCourseID    
   AND I_Student_Detail_ID = @iStudentDetailID    
   --AND I_Status = 1    
   )    
   BEGIN    
     SELECT 0   
   END     
      
ELSE    
  BEGIN    
    SELECT 1
  END    
     
END
