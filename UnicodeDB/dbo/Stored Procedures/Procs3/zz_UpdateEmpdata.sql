CREATE Proc [dbo].[zz_UpdateEmpdata](
@rollnumber int,
@name NVARCHAR(MAX),
@is_Active bit,
@id int=null

)
AS
bEGIN
if @id is not null
Begin
Update Emp set name =@name,Rollnumber=@rollnumber,Is_Active=@is_Active,Dt=GETDATE()
where Id=@id

End
eND

