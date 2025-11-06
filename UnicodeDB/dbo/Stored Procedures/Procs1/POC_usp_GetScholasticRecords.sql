CREATE PROCEDURE [dbo].[POC_usp_GetScholasticRecords]
@Id INT

AS
BEGIN
    select * from T_POC_SHOLASTIC where Id=@Id
END
