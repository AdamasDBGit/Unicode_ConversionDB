-- =============================================  
-- Author:  Soumya Sikder  
-- Create date: 17/01/2007  
-- Description: Fetches all the Course Family Master Table Details  
-- =============================================  
  
CREATE PROCEDURE [dbo].[uspGetCourseFamily]   
  
AS  
BEGIN  
  
 SELECT  A.I_CourseFamily_ID,   
   A.I_Brand_ID,   
   B.S_Brand_Code,   
   B.S_Brand_Name,   
   A.S_CourseFamily_Name,   
   A.S_Crtd_By,   
   A.S_Upd_By,    
   A.Dt_Crtd_On,   
   A.Dt_Upd_On,   
   A.I_Status ,
   A.I_IsMTech 
 FROM dbo.T_CourseFamily_Master A, dbo.T_Brand_Master B  
 WHERE A.I_Status <> 0  
 AND A.I_Brand_ID = B.I_Brand_ID  
 ORDER BY A.S_CourseFamily_Name  
END
