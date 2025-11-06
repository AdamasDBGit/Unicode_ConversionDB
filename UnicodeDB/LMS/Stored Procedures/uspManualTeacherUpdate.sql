CREATE PROCEDURE [LMS].[uspManualTeacherUpdate]
(
@Email VARCHAR(MAX),
@SubjectList VARCHAR(MAX)='',
@LeaveDay VARCHAR(MAX)='',
@TeacherAvailability NVARCHAR(MAX)='',
@CenterAvailability NVARCHAR(MAX)='',
@EmployeeID INT=0
)
AS
BEGIN

	DECLARE @availability NVARCHAR(MAX)=''
	DECLARE @i INT=1
	DECLARE @c INT=0

	SELECT @EmployeeID=I_Employee_ID FROM T_Employee_Dtls where S_Email_ID=@Email and I_Status=3

	create table #temp
	(
	Val NVARCHAR(MAX)
	)

	create table #final
	(
	ID INT IDENTITY(1,1),
	Val NVARCHAR(MAX)
	)


	IF(@EmployeeID>0)
	BEGIN

		--update EOS.T_Employee_Skill_Map set I_Status=0 where I_Emp_Skill_Dtl_ID in
		--(
		--	select I_Emp_Skill_Dtl_ID from EOS.T_Employee_Skill_Map where I_Employee_ID=@EmployeeID and I_Status=2
		--)

		--insert into EOS.T_Employee_Skill_Map
		--select T1.SubjectID,A.I_Employee_ID,2,'rice-group-admin',NULL,GETDATE(),NULL 
		--from T_Employee_Dtls A
		--inner join
		--(
		--	select @EmployeeID as EmpID,CAST(Val as INT) as SubjectID from fnString2Rows(@SubjectList,'|')
		--) T1 on A.I_Employee_ID=T1.EmpID
		--where A.I_Employee_ID=@EmployeeID

		--update T_Employee_Dtls set S_LeaveDay=@LeaveDay where I_Employee_ID=@EmployeeID

		

		IF(@TeacherAvailability!='')
		BEGIN

			SET @availability=''
			SET @i=1
			SET @c=0


			TRUNCATE TABLE #temp
			TRUNCATE TABLE #final

			insert into #temp
			select Val from fnString2Rows(@TeacherAvailability,',')

			insert into #final
			select DISTINCT Val from #temp

			SELECT @c=COUNT(*) FROM #final

			WHILE(@i<=@c)
			BEGIN

				SELECT @availability=@availability+Val+',' FROM #final where ID=@i

				SET @i=@i+1

			END

			--SELECT SUBSTRING(@availability,1,LEN(@availability)-1)
			--SELECT @TeacherAvailability

			update T_Employee_Dtls set S_TeacherAvailability=SUBSTRING(@availability,1,LEN(@availability)-1) where I_Employee_ID=@EmployeeID

		END

		IF(@CenterAvailability!='')
			BEGIN

				SET @availability=''
				SET @i=1
				SET @c=0


				TRUNCATE TABLE #temp
				TRUNCATE TABLE #final

				insert into #temp
				select Val from fnString2Rows(@CenterAvailability,',')

				insert into #final
				select DISTINCT Val from #temp

				SELECT @c=COUNT(*) FROM #final

				WHILE(@i<=@c)
				BEGIN

					SELECT @availability=@availability+Val+',' FROM #final where ID=@i

					SET @i=@i+1

				END

				--SELECT SUBSTRING(@availability,1,LEN(@availability)-1)
				--SELECT @TeacherAvailability

				update T_Employee_Dtls set S_CenterAvailability=SUBSTRING(@availability,1,LEN(@availability)-1) where I_Employee_ID=@EmployeeID

			END

	END


	select * from T_Employee_Dtls where I_Employee_ID=@EmployeeID
	--select * from EOS.T_Employee_Skill_Map where I_Employee_ID=@EmployeeID

	drop table #temp
	drop table #final

END


--ALTER TABLE T_Employee_Dtls
--ADD S_CenterAvailability NVARCHAR(MAX)


--EXEC LMS.uspManualTeacherUpdate 'subhro.sahu@riceindia.org','','','14:00T15:15,15:15T16:30,15:20T16:35,16:40T17:55,09:30T11:00,11:10T12:40,13:15T14:45,14:55T16:25,16:35T18:05,18:15T19:45,09:00T10:00,17:30T18:30'
