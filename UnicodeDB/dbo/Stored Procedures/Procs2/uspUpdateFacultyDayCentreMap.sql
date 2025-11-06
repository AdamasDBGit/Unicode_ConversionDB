--select * from T_Faculty_Day_Centre_Map

CREATE PROCEDURE [dbo].[uspUpdateFacultyDayCentreMap](@EmployeeID INT, @CreatedBy NVARCHAR(MAX))
AS
begin

	update T_Faculty_Day_Centre_Map set I_Status=0,S_Upd_By=@CreatedBy,Dt_Upd_On=GETDATE() where I_Employee_ID=@EmployeeID and I_Status=1

end

