CREATE PROCEDURE [DOCUMENT].[uspGetStudentUserDocument]   
(    
 -- Add the parameters for the stored procedure here    
 @dtCurrentDate DATETIME = NULL ,  
 @sStudentID VARCHAR(50) = NULL  
)    
        
AS      
BEGIN      
   SET NOCOUNT OFF    
     
   DECLARE @iStudentDetailID INT  
     
   SELECT @iStudentDetailID=I_Student_Detail_ID FROM dbo.T_Student_Detail AS tsd  
   WHERE tsd.S_Student_ID = @sStudentID  
  
   --PRINT   @iStudentDetailID  
     
   SELECT tud.I_Document_ID,I_Category_ID,tud.I_Brand_ID,S_File_Name,S_File_Path,Dt_Expiry_Date,I_File_Size,tcm.S_Course_Name FROM DOCUMENT.T_User_Documents AS tud  
   INNER JOIN dbo.T_Course_Master AS tcm  
   ON tud.I_Course_ID = tcm.I_Course_ID  
   WHERE tud.I_Status = 1   
   AND tud.I_Course_ID IN (SELECT I_Course_ID FROM dbo.T_Student_Course_Detail AS tscd  
                           WHERE tscd.I_Student_Detail_ID = @iStudentDetailID)  
   AND tud.Dt_Expiry_Date >= CONVERT(date, @dtCurrentDate)
     
END
