  
CREATE PROCEDURE ups_Exam_GetExamFacultyList   
AS  
 BEGIN  
  SELECT   
    I_User_ID AS inUserId,  
    S_First_Name+' '+ISNULL(S_Middle_Name,'')+' '+ISNULL(S_Last_Name,'') AS stFacultyName  
  FROM T_ERP_User WHERE Is_Teaching_Staff=1  
END  