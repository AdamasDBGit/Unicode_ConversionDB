CREATE PROCEDURE [dbo].[uspGetCourseListForStudent]       
(      
 @iStudentDetailId INT    
,@iSourceCenterID INT    
       
)      
AS      
BEGIN     
    
 SELECT SBD.I_Batch_ID
 FROM dbo.T_Student_Batch_Details SBD   
 INNER JOIN dbo.T_Student_Batch_Master SBM ON  SBM.I_Batch_ID = SBD.I_Batch_ID
 INNER JOIN [dbo].[T_Center_Batch_Details] TCBD ON SBM.[I_Batch_ID] = TCBD.[I_Batch_ID]
 WHERE SBD.I_Student_ID = @iStudentDetailId    
 AND TCBD.I_Centre_Id = @iSourceCenterID    
 AND SBM.I_Status <> 0
 AND SBD.I_Status = 1    
END
