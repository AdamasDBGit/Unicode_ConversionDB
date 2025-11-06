CREATE PROCEDURE [dbo].[uspUpdateStudentWiseSpecialStudyMaterialSet]      
@StudentDetailId Nnvarchar(max),      
@ExamDetails XML      
AS      
BEGIN TRY       
declare @iStudentID int    
select @iStudentID=I_student_detail_id from T_student_detail where S_student_id =@StudentDetailId    
    
--DELETE FROM Tbl_KPMG_StudentExaminationDetails WHERE Fld_KPMG_StudentDetailId=@StudentDetailId   
 CREATE TABLE #tempStudentExaminationDetails  
            (  
              Fld_KPMG_ExaminationId int,  
              Fld_KPMG_StudentDetailId Nnvarchar(max),  
              Fld_KPMG_MaterialBarCode Nnvarchar(max),  
              I_Student_detail_id INT,  
              Fld_KPMG_Admit_Path nvarchar(max)  
            )            
     
INSERT INTO #tempStudentExaminationDetails  
        ( Fld_KPMG_ExaminationId ,  
          Fld_KPMG_StudentDetailId ,  
          Fld_KPMG_MaterialBarCode ,  
          I_Student_detail_id ,  
          Fld_KPMG_Admit_Path  
        )  
       SELECT      
 a.b.value('EXAMID[1]','INT') ,      
 @StudentDetailId,      
 CASE WHEN ISNULL(a.b.value('BARCODE[1]','nnvarchar(max)'),'')<>'' THEN a.b.value('BARCODE[1]','nnvarchar(max)')  ELSE  null END,    
 @iStudentID,    
 a.b.value('FileName[1]','nvarchar(max)')    
 FROM @ExamDetails.nodes('ROOT/EXAM') a(b)  
   
   IF NOT EXISTS(SELECT * FROM Tbl_KPMG_StudentExaminationDetails TKS INNER JOIN #tempStudentExaminationDetails temp ON TKS.I_Student_Detail_ID = temp.I_Student_detail_id  
   WHERE tks.Fld_KPMG_StudentDetailId=@StudentDetailId AND TKS.Fld_KPMG_ExaminationId=temp.Fld_KPMG_ExaminationId)  
   BEGIN  
INSERT INTO Tbl_KPMG_StudentExaminationDetails (Fld_KPMG_ExaminationId,Fld_KPMG_StudentDetailId,Fld_KPMG_MaterialBarCode,I_Student_detail_id,Fld_KPMG_Admit_Path)      
 SELECT      
 a.b.value('EXAMID[1]','INT') ,      
 @StudentDetailId,      
 CASE WHEN ISNULL(a.b.value('BARCODE[1]','nnvarchar(max)'),'')<>'' THEN a.b.value('BARCODE[1]','nnvarchar(max)')  ELSE  null END,    
 @iStudentID,    
 a.b.value('FileName[1]','nvarchar(max)')    
 FROM @ExamDetails.nodes('ROOT/EXAM') a(b)     
   END   
 ELSE   
 BEGIN  
 UPDATE Tbl_KPMG_StudentExaminationDetails  
 SET Fld_KPMG_Admit_Path=TSED.Fld_KPMG_Admit_Path  
 FROM Tbl_KPMG_StudentExaminationDetails tks  
 INNER JOIN #tempStudentExaminationDetails AS TSED  
 ON tks.I_Student_Detail_ID = TSED.I_Student_detail_id  
   
 END  
   
   
END TRY      
BEGIN CATCH      
      
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int      
      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
