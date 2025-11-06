CREATE PROCEDURE [dbo].[uspCheckExamCompDependency]  
  
 -- Add the parameters for the stored procedure here  
 @iExamComponentID INT  

 AS  
BEGIN TRY  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON
 
SELECT COUNT(1) FROM EOS.T_SKILL_EXAM_MAP WHERE I_Exam_Component_ID = @iExamComponentID
 
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
