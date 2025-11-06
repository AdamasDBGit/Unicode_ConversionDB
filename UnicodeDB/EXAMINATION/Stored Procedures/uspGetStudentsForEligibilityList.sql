CREATE PROCEDURE [EXAMINATION].[uspGetStudentsForEligibilityList]   
 @iExamID int  
AS  
BEGIN  
 DECLARE @iCenterID INT  
 DECLARE @iCourseID INT   
 DECLARE @iTermID INT   
   
 SELECT @iCenterID = I_Centre_Id,  
   @iCourseID = I_Course_ID,  
   @iTermID = I_Term_ID  
 FROM EXAMINATION.T_Examination_Detail  
 WHERE I_Exam_ID = @iExamID  
   
   
 SELECT I_Student_Detail_ID  
 FROM dbo.T_Student_Detail  
 WHERE --T_Student_Detail.I_Status = 1   AND 
I_Student_Detail_ID IN (SELECT I_Student_Detail_ID FROM dbo.T_Student_Center_Detail WHERE I_Centre_Id = @iCenterID AND I_Status = 1)  
 AND I_Student_Detail_ID IN (SELECT I_Student_Detail_ID FROM dbo.T_Student_Term_Detail WHERE I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Is_Completed = 0)  
END
