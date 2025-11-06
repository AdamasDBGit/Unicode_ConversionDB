CREATE PROCEDURE [dbo].[uspGetStudentInformation]           
(              
 @iStudentDetailId INT              
 ,@iDestinationCenterId INT              
)              
AS              
BEGIN              
              
SELECT SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name as S_Student_Name              
   ,SD.S_Student_Id              
   ,IP.S_Invoice_No              
   ,IP.Dt_Invoice_Date              
   ,IP.N_Invoice_Amount              
FROM dbo.T_Student_Detail SD              
INNER JOIN dbo.T_Invoice_Parent IP              
 ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID              
WHERE SD.I_Student_Detail_Id = @iStudentDetailId AND IP.I_Status <>0              
              
SELECT CTR.S_Center_Code              
   ,CTR.S_Center_Name              
   ,CTRY.S_Country_Name              
FROM dbo.T_Centre_Master CTR              
INNER JOIN dbo.T_Country_Master CTRY              
 ON CTR.I_Country_ID = CTRY.I_Country_ID              
INNER JOIN T_Invoice_Parent IP              
 ON IP.I_Centre_Id = CTR.I_Centre_Id              
WHERE IP.I_Student_Detail_Id = @iStudentDetailId            
              
SELECT CTR.S_Center_Code              
   ,CTR.S_Center_Name              
   ,CTRY.S_Country_Name              
FROM dbo.T_Centre_Master CTR              
INNER JOIN dbo.T_Country_Master CTRY              
 ON CTR.I_Country_ID = CTRY.I_Country_ID              
WHERE CTR.I_Centre_Id = @iDestinationCenterId              
          
SELECT CM.I_Course_Id              
,CM.S_Course_Name              
FROM dbo.T_Student_Batch_Details AS TSBD      
INNER JOIN dbo.T_Student_Batch_Master AS TSBM      
ON TSBD.I_Batch_ID = TSBM.I_Batch_ID               
INNER JOIN dbo.T_Course_Master CM         
ON TSBM.I_Course_ID = CM.I_Course_ID             
WHERE TSBD.I_Student_Id = @iStudentDetailId AND TSBD.I_Status =1          
              
DECLARE @CourseIDTable TABLE (I_Course_Id INT)              
INSERT INTO @CourseIDTable              
SELECT CM.I_Course_Id              
FROM dbo.T_Student_Course_Detail SCD              
INNER JOIN dbo.T_Course_Master CM              
 ON SCD.I_Course_Id = CM.I_Course_Id              
WHERE SCD.I_Student_Detail_Id = @iStudentDetailId              
              
--------------------- last module taught ---------------              
DECLARE @count INT              
              
SELECT @count = COUNT(MM.I_Module_Id)              
FROM dbo.T_Student_Module_Detail SMD              
INNER JOIN dbo.T_Module_Master MM              
 ON SMD.I_Module_Id = MM.I_Module_Id              
WHERE SMD.I_Student_Detail_Id = @iStudentDetailId              
AND SMD.I_Is_Completed = 1              
AND SMD.Dt_Crtd_On =              
(SELECT MAX(Dt_Crtd_On)              
 FROM dbo.T_Student_Module_Detail              
 WHERE I_Student_Detail_Id = @iStudentDetailId               
 AND I_Is_Completed = 1              
)              
              
PRINT @COUNT              
IF @count > 1              
BEGIN              
              
SELECT TOP 1 MM.I_Module_Id              
   ,MM.S_Module_Name              
 FROM dbo.T_Student_Module_Detail SMD              
 INNER JOIN dbo.T_Module_Master MM              
  ON SMD.I_Module_Id = MM.I_Module_Id              
 WHERE SMD.I_Student_Detail_Id = @iStudentDetailId              
 AND SMD.I_Is_Completed = 1              
 ORDER BY  MM.I_Module_Id DESC              
              
              
               
END              
ELSE              
BEGIN              
               
 SELECT  MM.I_Module_Id              
   ,MM.S_Module_Name              
 FROM dbo.T_Student_Module_Detail SMD              
 INNER JOIN dbo.T_Module_Master MM              
  ON SMD.I_Module_Id = MM.I_Module_Id              
 WHERE SMD.I_Student_Detail_Id = @iStudentDetailId              
 AND SMD.I_Is_Completed = 1              
 AND SMD.Dt_Crtd_On =              
 (SELECT MAX(Dt_Crtd_On)              
  FROM dbo.T_Student_Module_Detail              
  WHERE I_Student_Detail_Id = @iStudentDetailId               
  AND I_Is_Completed = 1              
 )          
              
END              
---------------------------------              
              
              
---- exams appeared ------------              
SELECT ED.I_Exam_Id,SM.I_Exam_Total              
FROM EXAMINATION.T_Examination_Detail ED              
INNER JOIN EXAMINATION.T_Student_Marks SM              
 ON ED.I_Exam_Id = SM.I_Exam_Id              
WHERE SM.I_Student_Detail_Id = @iStudentDetailId              
-------------- courseware list ------------------------------              
              
              
              
SELECT I_Book_ID, S_Book_Code ,S_BOOK_NAME                 
    FROM T_BOOK_MASTER WHERE I_BOOK_ID IN                
     (SELECT DISTINCT I_BOOK_ID FROM T_MODULE_BOOK_MAP MBM WHERE I_MODULE_ID IN                 
      (SELECT I_MODULE_ID FROM T_MODULE_TERM_MAP MTM WHERE I_TERM_ID IN                
       (SELECT I_TERM_ID FROM T_TERM_COURSE_MAP TCM                 
       WHERE I_COURSE_ID IN              
  (SELECT I_Course_Id FROM @CourseIDTable)              
    AND I_Status <> 0 AND                 
       GETDATE() >= ISNULL(TCM.Dt_Valid_From,GETDATE())                
       AND GETDATE() <= ISNULL(TCM.Dt_Valid_To,GETDATE())                
       )                
      AND GETDATE() >= ISNULL(MTM.Dt_Valid_From,GETDATE())                
      AND GETDATE() <= ISNULL(MTM.Dt_Valid_To,GETDATE())                
     )                
     AND GETDATE() >= ISNULL(MBM.Dt_Valid_From,GETDATE())                
     AND GETDATE() <= ISNULL(MBM.Dt_Valid_To,GETDATE())                
     )               
--SELECT               
--FROM    T_BOOK_MASTER BM              
--INNER JOIN T_MODULE_BOOK_MAP MBP ON BM.I_Book_ID = MBP.I_Book_ID              
--INNER JOIN T_MODULE_TERM_MAP MTM ON MBP.I_TERM_ID = MTM.I_TERM_ID              
--INNER JOIN T_TERM_COURSE_MAP TCM ON MTM.I_COURSE_ID = TCM.I_COURSE_ID              
--INNER JOIN T_Student_Cousre_Detail              
              
SELECT ISNULL(SUM(RH.N_Receipt_Amount),0)            
FROM dbo.T_Receipt_Header RH              
INNER JOIN dbo.T_Invoice_Parent IP               
  ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID              
WHERE RH.I_Student_Detail_ID = @iStudentDetailId              
AND IP.I_Centre_Id <> @iDestinationCenterId              
AND RH.I_Status = 1     
AND IP.I_Status <> 0          
  
SELECT ISNULL(SUM(trh.N_Receipt_Amount),0) AS d_Transfer_Amount FROM dbo.T_Receipt_Header AS trh  
INNER JOIN dbo.T_Student_Center_Detail AS tscd  
ON trh.I_Student_Detail_ID = tscd.I_Student_Detail_ID AND trh.I_Status=1  
WHERE trh.I_Student_Detail_ID= @iStudentDetailId  
AND I_Receipt_Type=41 AND trh.I_Centre_Id=tscd.I_Centre_Id  
              
END 
