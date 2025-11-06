CREATE PROCEDURE [dbo].[uspGetCourseDetailsForEvalStrategyCopy] --530,286  
(  
 @iCourseID int,  
 @iTermID int  
)  
  
AS   
BEGIN  
  
SET NOCOUNT ON  
  
 SELECT Distinct  
  
 T_Brand_Master.I_Brand_ID,   
 T_Brand_Master.S_Brand_Name,   
 T_CourseFamily_Master.I_CourseFamily_ID,   
 T_CourseFamily_Master.S_CourseFamily_Name,   
 T_Course_Master.I_Course_ID,   
 T_Course_Master.S_Course_Name  
  
 FROM           
  
 T_Brand_Master   
 INNER JOIN T_CourseFamily_Master ON T_Brand_Master.I_Brand_ID = T_CourseFamily_Master.I_Brand_ID    
 INNER JOIN T_Course_Master ON T_CourseFamily_Master.I_CourseFamily_ID = T_Course_Master.I_CourseFamily_ID   
 INNER JOIN T_Term_Course_Map ON T_Course_Master.I_Course_ID = T_Term_Course_Map.I_Course_ID   
 INNER JOIN T_Term_Master ON T_Term_Course_Map.I_Term_ID = T_Term_Master.I_Term_ID  
  
 WHERE  
  
 T_Course_Master.I_Course_ID<>@iCourseID AND  
 T_Term_Master.I_Term_ID =@iTermID AND  
 T_Brand_Master.I_Status<>0 AND  
 T_CourseFamily_Master.I_Status<>0 AND  
 T_Course_Master.I_Status<>0 AND  
 T_Term_Master.I_Status<>0 AND  
 T_Term_Course_Map.I_Status<>0  
  
END
