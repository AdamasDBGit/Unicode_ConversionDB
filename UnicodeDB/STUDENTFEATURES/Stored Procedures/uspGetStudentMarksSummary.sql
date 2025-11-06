CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentMarksSummary]  
(  
 @iStudentDetailID int,  
 @iCourseID int  
)  
  
AS  
BEGIN  
  
SET NOCOUNT ON  
  
SELECT TCM.I_Sequence,TM.I_Term_ID, TM.S_Term_Name,  
    STD.S_Term_Final_Marks, STD.S_Term_Grade  
  FROM dbo.T_Term_Course_Map TCM  
 INNER JOIN dbo.T_Term_Master TM  
 ON TM.I_Term_ID = TCM.I_Term_ID  
 INNER JOIN dbo.T_Student_Term_Detail STD  
 ON STD.I_Term_ID = TM.I_Term_ID  
  WHERE TCM.I_Course_ID = @iCourseID  
  AND STD.I_Student_Detail_ID = @iStudentDetailID 
  AND TCM.I_Status=1
 ORDER BY TCM.I_Sequence  
  
END
