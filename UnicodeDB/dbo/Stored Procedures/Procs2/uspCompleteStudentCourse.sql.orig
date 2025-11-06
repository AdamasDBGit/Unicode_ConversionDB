CREATE PROCEDURE [dbo].[uspCompleteStudentCourse]    
(    
 @I_Student_Detail_ID int,    
 @I_Batch_ID INT,   
 @S_Upd_By VARCHAR(50)    
)    
AS    
BEGIN    
   
 DECLARE @I_Course_ID INT  
 SELECT @I_Course_ID = I_Course_ID FROM dbo.T_Student_Batch_Master AS tsbm WHERE I_Batch_ID = @I_Batch_ID   
    
 UPDATE dbo.T_Student_Batch_Details    
 SET I_Status = 0     
 WHERE I_Student_ID = @I_Student_Detail_ID    
 AND I_Batch_ID = @I_Batch_ID  
     
 UPDATE dbo.T_Student_Term_Detail    
 SET I_Is_Completed = 1,    
 S_Upd_By = @S_Upd_By,    
 Dt_Upd_On = GETDATE()    
 WHERE I_Student_Detail_ID = @I_Student_Detail_ID    
 AND I_Term_ID IN    
 (    
  SELECT I_Term_ID     
  FROM dbo.T_Term_Course_Map WHERE I_Course_ID = @I_Course_ID    
 )    
 AND I_Batch_ID = @I_Batch_ID  
 
 UPDATE dbo.T_Student_Detail SET I_Status=0 WHERE I_Student_Detail_ID=@I_Student_Detail_ID
    
END
