CREATE Proc [dbo].[zz_GetEmpdata](
@rollnumber int
)
AS
bEGIN
sELECT * FROM Emp where Rollnumber=@rollnumber
eND
