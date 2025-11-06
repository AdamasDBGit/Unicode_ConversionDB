CREATE PROCEDURE [dbo].[POC_usp_GetStudents]
   
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id,StudentName
    FROM [dbo].[T_POC_SHOLASTIC]
   
END;
