--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[uspDeleteGuardian]
(
 @iguardiaID int
)
AS
BEGIN
--DECLARE @iParentID int
UPDATE T_Parent_Master set I_Status = 0
where I_Parent_Master_ID = @iguardiaID
select 1 statusFlag,'Guardian deleted succesfully.' message 

END
