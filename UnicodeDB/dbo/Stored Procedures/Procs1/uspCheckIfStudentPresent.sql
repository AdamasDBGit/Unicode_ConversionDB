CREATE PROC [dbo].[uspCheckIfStudentPresent]    
(    
  @sLoginID NVARCHAR(MAX) 
)    
AS     
BEGIN    

 SET NOCOUNT ON    
   
 SELECT * FROM dbo.T_Student_Detail AS tsd WHERE S_Student_ID =@sLoginID

END

