CREATE PROCEDURE [LMS].[uspInsertTeacherDetailsForInterfaceManual]
(
	@EmployeeID INT,
	@EntryType VARCHAR(MAX)=NULL
)
AS
BEGIN

	if (@EntryType is not null)
	begin

		DECLARE @subjectid int
		DECLARE @subjects varchar(max)=''
		

		IF(@EntryType='ADD')
		begin

			

			DECLARE bcursor CURSOR FOR 
			select DISTINCT I_Skill_ID from EOS.T_Employee_Skill_Map 
			where I_Employee_ID=@EmployeeID and I_Status=2--where CreatedOn>='2021-05-27'

			OPEN bcursor  
			FETCH NEXT FROM bcursor INTO @subjectid  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  

				  set @subjects=@subjects+CAST(@subjectid as varchar(10))+','

				  FETCH NEXT FROM bcursor INTO @subjectid
			END 

			CLOSE bcursor  
			DEALLOCATE bcursor


			insert into [LMS].[T_Teacher_Details_Interface_API]
			select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name as EmployeeName,TED.S_Email_ID,
			'' as TimeSlots,'' as CentreCodes,'' as CentreIDs,ISNULL(TED.S_LeaveDay,'') as DayofLeave,1 as ForOnline,1 as ForOffline,
			@subjects as Subjects,@EntryType,0,0,1,GETDATE(),NULL,''
			from T_Employee_Dtls TED
			inner join T_Center_Hierarchy_Name_Details TCHND on TED.I_Centre_Id=TCHND.I_Center_ID
			where TED.I_Employee_ID=@EmployeeID 
			and TED.I_Status=3

		end

		IF(@EntryType='UPDATE')
		begin

			

			DECLARE bcursor CURSOR FOR 
			select DISTINCT I_Skill_ID from EOS.T_Employee_Skill_Map 
			where I_Employee_ID=@EmployeeID and I_Status=2--where CreatedOn>='2021-05-27'

			OPEN bcursor  
			FETCH NEXT FROM bcursor INTO @subjectid  

			WHILE @@FETCH_STATUS = 0  
			BEGIN  

				  set @subjects=@subjects+CAST(@subjectid as varchar(10))+','

				  FETCH NEXT FROM bcursor INTO @subjectid
			END 

			CLOSE bcursor  
			DEALLOCATE bcursor


			insert into [LMS].[T_Teacher_Details_Interface_API]
			select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name as EmployeeName,TED.S_Email_ID,
			TED.S_TeacherAvailability as TimeSlots,TED.S_CenterAvailability as CentreCodes,'' as CentreIDs,ISNULL(TED.S_LeaveDay,'') as DayofLeave,1 as ForOnline,1 as ForOffline,
			@subjects as Subjects,@EntryType,0,0,1,GETDATE(),NULL,''
			from T_Employee_Dtls TED
			inner join T_Center_Hierarchy_Name_Details TCHND on TED.I_Centre_Id=TCHND.I_Center_ID
			where TED.I_Employee_ID=@EmployeeID 
			and TED.I_Status=3


			--EXEC [LMS].[uspUpdateTeacherCentreForInterface] @EmployeeID

		end

	end

END
