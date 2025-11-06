CREATE PROC [dbo].[uspGetEnrollmentDate]  
(  
@iStudentID INT  
)  
AS  
  
BEGIN  
  
SELECT ISNULL(Dt_Crtd_On,'1/1/2002') EnrDate FROM T_Student_Detail WITH (NOLOCK) WHERE I_Student_Detail_ID = @iStudentID AND I_Status <> 0  
  
END
