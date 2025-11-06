CREATE PROCEDURE [dbo].[uspModuleWiseBookList]     
(    
 @sCourseList VARCHAR(500)   
)  
AS  
BEGIN  
  
DECLARE @hDoc INT         
EXEC SP_XML_PREPAREDOCUMENT @hDoc OUTPUT,@sCourseList     
  
SELECT DISTINCT   
   MM.I_Module_ID  
  ,MM.S_Module_Name AS ModuleName  
  ,BM.S_Book_Name   AS BookName  
FROM dbo.T_Book_Master BM  
INNER JOIN dbo.T_Module_Book_Map MBM ON BM.I_Book_ID = MBM.I_Book_ID  
INNER JOIN dbo.T_Module_Term_Map MTM ON MBM.I_Module_ID = MTM.I_Module_ID  
INNER JOIN dbo.T_Module_Master   MM ON MM.I_Module_ID = MTM.I_Module_ID  
INNER JOIN dbo.T_Term_Course_Map TCM ON MTM.I_Term_ID = TCM.I_Term_ID  
WHERE TCM.I_Course_Id  IN   
(  
 SELECT DISTINCT I_Course_Id        
 FROM OPENXML (@hDoc,'/COURSE/COURSEIDTABLE',2)         
 WITH ( I_Course_Id INT )   
)  
  AND GETDATE() >= ISNULL(MBM.Dt_Valid_From , GETDATE())    
  AND GETDATE() <= ISNULL(MBM.Dt_Valid_To   , GETDATE())   
  AND GETDATE() >= ISNULL(MTM.Dt_Valid_From , GETDATE())    
  AND GETDATE() <= ISNULL(MTM.Dt_Valid_To   , GETDATE())   
  
END
