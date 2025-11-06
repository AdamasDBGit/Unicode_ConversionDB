/*******************************************************  
Description : Gets the list of Modules which contains EProject as one of its Exam under the Term  
Author :     Soumya Sikder  
Date :   03/05/2007  
*********************************************************/  
  
CREATE PROCEDURE [dbo].[uspGetTeacherSubjects]   
(  
 @BrandID int = null  
)  
AS  
BEGIN TRY   
 -- getting records for Table [0]  
 SELECT TOP (1000) [SubjectID]  
      ,[SubjectName]  
        
      ,[StatusID] AS Status  
        
  FROM [ECOMMERCE].[T_Schedule_Subject]  
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  