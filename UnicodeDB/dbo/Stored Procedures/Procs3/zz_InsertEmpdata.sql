CREATE Proc [dbo].[zz_InsertEmpdata](
@rollnumber int,
@name NVARCHAR(MAX),
@is_Active bit

)
AS
bEGIN
Insert Into Emp(name,Rollnumber,Is_Active,Dt)
Values(@name,@rollnumber,@is_Active,GETDATE())
eND

