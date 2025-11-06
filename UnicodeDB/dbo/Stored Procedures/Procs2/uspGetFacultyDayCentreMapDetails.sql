CREATE PROCEDURE [dbo].[uspGetFacultyDayCentreMapDetails](@EmployeeID INT)
AS
begin

	create table #temp
	(
	EmployeeID INT,
	ClassDay nvarchar(max),
	Centres nvarchar(max)
	)


	DECLARE @empid int
	DECLARE @classday nvarchar(max)
	DECLARE @centres nvarchar(max)


	DECLARE bcursor CURSOR FOR 
	select DISTINCT I_Employee_ID,S_DayofWeek,CAST(I_Centre_ID as varchar(max)) from T_Faculty_Day_Centre_Map 
	where I_Employee_ID=@EmployeeID and I_Status=1 --where CreatedOn>='2021-05-27'

	OPEN bcursor
	FETCH NEXT FROM bcursor INTO @empid,@classday,@centres  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		  if not exists(select * from #temp where EmployeeID=@empid and ClassDay=@classday)
		  begin

			insert into #temp
			select @empid,@classday,@centres

		  end
		  else
		  begin

			update #temp set Centres=Centres+','+@centres where EmployeeID=@empid and ClassDay=@classday

		  end

		  FETCH NEXT FROM bcursor INTO @empid,@classday,@centres
	END 

	CLOSE bcursor  
	DEALLOCATE bcursor

	select * from #temp

	drop table #temp


end
