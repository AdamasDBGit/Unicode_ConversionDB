CREATE PROCEDURE [LMS].[uspUpdateTeacherCentreForInterface]
(
@EmployeeID INT
)
AS
BEGIN

	DECLARE @ID INT
	DECLARE @centreids VARCHAR(MAX)=''
	DECLARE @centrecodes VARCHAR(MAX)=''
	DECLARE @timeslots VARCHAR(MAX)=''


	DECLARE @centreid int
	DECLARE @centrecode varchar(max)
	DECLARE @timeslot varchar(max)

	IF EXISTS (select * from [LMS].[T_Teacher_Details_Interface_API] 
				where StatusID=1 and NoofAttempts=0 and ActionStatus=0 and ActionType='ADD' and FacultyID=@EmployeeID)
	BEGIN
		PRINT 1
		
		select @ID=ID from [LMS].[T_Teacher_Details_Interface_API] 
				where StatusID=1 and NoofAttempts=0 and ActionStatus=0 and ActionType='ADD' and FacultyID=@EmployeeID

		delete from [LMS].[T_Teacher_CentreMap_Details_API] where ID=@ID

		insert into [LMS].[T_Teacher_CentreMap_Details_API]
		select @ID,A.S_DayofWeek,A.I_Centre_ID,B.S_Center_Code,B.S_Center_Name,A.S_TimeSlots,1 
		from T_Faculty_Day_Centre_Map A
		inner join T_Centre_Master B on A.I_Centre_ID=B.I_Centre_Id
		where A.I_Employee_ID=@EmployeeID and A.I_Status=1



		

		DECLARE bcursor CURSOR FOR 
		select DISTINCT CentreID,CentreCode,TimeSlot from [LMS].[T_Teacher_CentreMap_Details_API] 
		where ID=@ID and StatusID=1

		OPEN bcursor  
		FETCH NEXT FROM bcursor INTO @centreid,@centrecode,@timeslot

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

				set @centreids=@centreids+CAST(@centreid as varchar(10))+','
				set @centrecodes=@centrecodes+@centrecode+','
				set @timeslots=@timeslots+@timeslot

				FETCH NEXT FROM bcursor INTO @centreid,@centrecode,@timeslot
		END 

		CLOSE bcursor  
		DEALLOCATE bcursor

		update [LMS].[T_Teacher_Details_Interface_API] set TimeSlots=@timeslots,CentreCodes=@centrecodes,CentreIDs=@centreids
		where ID=@ID


	END

	ELSE IF EXISTS (select * from [LMS].[T_Teacher_Details_Interface_API] 
				where StatusID=1 and NoofAttempts=0 and ActionStatus=0 and ActionType='UPDATE' and FacultyID=@EmployeeID)
	BEGIN

		PRINT 2

		select @ID=ID from [LMS].[T_Teacher_Details_Interface_API] 
				where StatusID=1 and NoofAttempts=0 and ActionStatus=0 and ActionType='UPDATE' and FacultyID=@EmployeeID

		delete from [LMS].[T_Teacher_CentreMap_Details_API] where ID=@ID

		insert into [LMS].[T_Teacher_CentreMap_Details_API]
		select @ID,A.S_DayofWeek,A.I_Centre_ID,B.S_Center_Code,B.S_Center_Name,A.S_TimeSlots,1 
		from T_Faculty_Day_Centre_Map A
		inner join T_Centre_Master B on A.I_Centre_ID=B.I_Centre_Id
		where A.I_Employee_ID=@EmployeeID and A.I_Status=1


		DECLARE bcursor CURSOR FOR 
		select DISTINCT CentreID,CentreCode,TimeSlot from [LMS].[T_Teacher_CentreMap_Details_API] 
		where ID=@ID and StatusID=1

		OPEN bcursor  
		FETCH NEXT FROM bcursor INTO @centreid,@centrecode,@timeslot

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

				set @centreids=@centreids+CAST(@centreid as varchar(10))+','
				set @centrecodes=@centrecodes+@centrecode+','
				set @timeslots=@timeslots+@timeslot

				FETCH NEXT FROM bcursor INTO @centreid,@centrecode,@timeslot
		END 

		CLOSE bcursor  
		DEALLOCATE bcursor

		print @centreids
		print @centrecodes
		print @timeslots

		update [LMS].[T_Teacher_Details_Interface_API] set TimeSlots=@timeslots,CentreCodes=@centrecodes,CentreIDs=@centreids
		where ID=@ID

	END

	ELSE

	BEGIN

		PRINT 3

		EXEC [LMS].[uspInsertTeacherDetailsForInterface] @EmployeeID,'UPDATE'

	END


END
