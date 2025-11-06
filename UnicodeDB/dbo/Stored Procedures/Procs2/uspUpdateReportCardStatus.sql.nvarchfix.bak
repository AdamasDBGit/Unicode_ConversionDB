CREATE PROCEDURE [dbo].[uspUpdateReportCardStatus]  
(  

 @studentResultID INT 
)  
AS  
BEGIN TRY  
  
 UPDATE T_Student_Result set I_IsReportCardGenerate = 1 where I_Student_Result_ID = @studentResultID
  select 1 statusFlag,'Updated' message 
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH