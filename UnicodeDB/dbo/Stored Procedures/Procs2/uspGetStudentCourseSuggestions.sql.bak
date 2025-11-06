CREATE PROCEDURE [dbo].[uspGetStudentCourseSuggestions]  --338347    
(      
 -- Add the parameters for the stored procedure here      
 @iEnquiryID INT    
)      
AS      
BEGIN      
 declare @tmp varchar(max)    
 SET @tmp = ''    
 SELECT  @tmp = @tmp + S_Course_Name + ', ' FROM ASSESSMENT.T_Student_Assessment_Suggestion A    
 INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map B    
 ON A.I_CourseList_ID = B.I_Course_List_ID    
 INNER JOIN dbo.T_Course_Master C    
 ON B.I_Course_ID = C.I_Course_ID    
 WHERE I_Enquiry_Regn_ID = @iEnquiryID       
 SELECT SUBSTRING(@tmp, 0, LEN(@tmp)) AS [CourseSuggestions]    
END
