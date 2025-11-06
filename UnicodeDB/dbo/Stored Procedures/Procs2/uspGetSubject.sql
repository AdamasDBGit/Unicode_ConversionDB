CREATE PROCEDURE [dbo].[uspGetSubject] 
 @iBrandID int = null,
 @iCourseId int = null
AS
BEGIN TRY   
 SET NOCOUNT OFF;  
BEGIN

	SELECT  S_Component_Name from T_Exam_Component_Master where I_Brand_ID =@iBrandID and I_Course_ID=@iCourseId and I_Status <> 0
END
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
