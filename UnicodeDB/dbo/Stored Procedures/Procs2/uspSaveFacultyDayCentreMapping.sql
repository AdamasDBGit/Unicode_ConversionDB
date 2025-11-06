CREATE PROCEDURE [dbo].[uspSaveFacultyDayCentreMapping](@EmployeeID int, @DayofWeek Nnvarchar(max), @CentreID INT, @TimeSlot Nnvarchar(max),@CreatedBy Nnvarchar(max))
AS
begin

	if not exists(select * from T_Faculty_Day_Centre_Map where I_Employee_ID=@EmployeeID and S_DayofWeek=@DayofWeek and I_Centre_ID=@CentreID
					and I_Status=1)
	begin

		insert into T_Faculty_Day_Centre_Map
		select @EmployeeID,@DayofWeek,@CentreID,@TimeSlot,1,@CreatedBy,GETDATE(),NULL,NULL

	end
	--else
	--begin

	--	update T_Faculty_Day_Centre_Map set I_Status=0,S_Upd_On=@CreatedBy,Dt_Upd_On=GETDATE() 
	--	where I_Employee_ID=@EmployeeID and S_DayofWeek=@DayofWeek and I_Centre_ID=@CentreID and I_Status=1


	--	insert into T_Faculty_Day_Centre_Map
	--	select @EmployeeID,@DayofWeek,@CentreID,@TimeSlot,1,@CreatedBy,GETDATE(),NULL,NULL

	--end

end

