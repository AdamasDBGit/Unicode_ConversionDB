CREATE PROCEDURE [dbo].[uspValidateModuleModification]   
(  
 @iModuleID int  
)  
AS  
BEGIN TRY  
  
--Table[0]
 SELECT COUNT(A.I_Course_Center_ID) As Course_Center_Count
 FROM dbo.T_Course_Center_Detail A  
 INNER JOIN dbo.T_Centre_Master CM  
 ON CM.I_Centre_Id = A.I_Centre_Id  
 INNER JOIN dbo.T_Term_Course_Map B  
 ON A.I_Course_ID = B.I_Course_ID  
 INNER JOIN dbo.T_Module_Term_Map C  
 ON B.I_Term_ID = C.I_Term_ID  
 INNER JOIN dbo.T_Module_Master D  
 ON C.I_Module_ID = D.I_Module_ID  
 WHERE C.I_Module_ID = @iModuleID  
 AND A.I_Status = 1  
 AND B.I_Status = 1  
 AND C.I_Status = 1  
 AND D.I_Status = 1  
 AND CM.I_Status = 1  
 AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())  
 AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())  
 AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())  
 AND GETDATE() >= ISNULL(CM.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())  

--Table[1]
SELECT Count(*) As Session_Count FROM T_SESSION_MODULE_MAP WHERE I_MODULE_ID=@iModuleID AND I_STATUS=1
   
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
