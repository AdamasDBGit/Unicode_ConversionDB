/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateNotificationSchedule] 
(
	@iNotificationTemplateID int = null,
	@iType int = null,
	@sBody nvarchar(MAX),
	@iAllStudents bit,
	@iAllTeachers bit,
	@iGroupType int = null,
	@sBatches nvarchar(MAX)=null,
	@sStudents nvarchar(MAX)=null,
	@sTeachers nvarchar(MAX)=null,
	@sClasses  nvarchar(MAX)=null,
	@ScheduleDateTime datetime = null
   ,@SCreatedBy nvarchar(50) = null
   ,@sTitle nvarchar(50) = null
   ,@sSchoolGroup nvarchar(MAX) = null
   ,@sAttachments nvarchar(MAX) = null
)
AS
begin transaction
BEGIN TRY 


INSERT INTO T_NotificationSchedule
(
 S_MessageBody
,I_NotificationGroupType_ID
,Dt_ScheduleDateTime
,Dt_CreatedAt
,S_CreatedBy
,S_Title
,I_NotificationTemplate_ID
,I_NotificationType_ID
)
VALUES
(
 @sBody
,@iGroupType
,@ScheduleDateTime
,GETDATE()
,@SCreatedBy
,@sTitle
,@iNotificationTemplateID
,@iType
)
DECLARE @iLastNotificationScheduleID int;
SET @iLastNotificationScheduleID = SCOPE_IDENTITY();
--if(@iAllStudents=1)
--BEGIN
----save for all active students

--END
--if(@iAllTeachers=1)	
--BEGIN
---- save for all active teachers
--END
--if(@sBatches!=null)
--BEGIN
---- save students for batches
--END

-----------Susmita Paul ----------

if (@iLastNotificationScheduleID > 0 and @iType = 1)
	BEGIN
		
				insert into T_NotificationSchedule_Attachment
				(
				I_NotificationSchedule_ID,
				S_CreatedBy,
				Dt_CreatedOn,
				S_AttachmentFileName
				)
				select 
				@iLastNotificationScheduleID,
				@SCreatedBy,
				GETDATE(),
				CAST(Val as nvarchar(max))
				from fnString2Rows(@sAttachments,',')
		
	END

if (@iGroupType = 8 or @iGroupType = 9 or @iGroupType = 10)
	BEGIN

		IF (@iGroupType = 8 or @iGroupType = 10)  ---- For Student
		
			BEGIN
				
					Declare @SchoolGroup table
						(
						StudentDetailID INT,
						SchoolGroupID INT,
						S_Guardian_Mobile_No nvarchar(max)
						)

		
						insert into @SchoolGroup
						(
						StudentDetailID,
						SchoolGroupID,
						S_Guardian_Mobile_No
						)
						select DISTINCT SCS.I_Student_Detail_ID,SG.I_School_Group_ID,SD.S_Guardian_Mobile_No
						from 
						T_School_Group as SG
						inner join
						T_School_Group_Class as SGC on SG.I_School_Group_ID=SGC.I_School_Group_ID
						inner join
						T_Student_Class_Section as SCS on SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID
						inner join
						T_Student_Detail as SD on SD.I_Student_Detail_ID=SCS.I_Student_Detail_ID
						inner join
						(select CAST(Val as INT) as GID
						from fnString2Rows(@sSchoolGroup,',')
						) as SGroup on SGroup.GID=SG.I_School_Group_ID
						inner join
						T_Student_Batch_Details as SBD on SBD.I_Student_ID=SD.I_Student_Detail_ID and SBD.I_Status=1
						where SCS.I_Status=1
				

			

						INSERT INTO T_NotificationRecipient
						(
						 I_NotificationSchedule_ID
						,I_Recepient_ID
						,I_Type
						,S_CreatedBy
						,Dt_CreatedOn
						,S_MobileNumber
						,S_FireBase_Token
						,S_Email
						)
						select 
						@iLastNotificationScheduleID
						,t2.StudentDetailID
						,1 --Student
						,@SCreatedBy
						,GETDATE()
						,t1.S_Mobile_No
						,t1.S_Firebase_Token
						,t1.S_Guardian_Email 
						from T_Parent_Master t1 right join @SchoolGroup t2
						on t2.S_Guardian_Mobile_No = t1.S_Mobile_No 
						where t1.I_IsPrimary = 1 

				

			END

		IF (@iGroupType = 9 or @iGroupType = 10) -- For Teacher
			
			BEGIN

				-- will be done for Future
				DECLARE @j INT =0

			END
	END

-------- --------------- ---------------
else
	BEGIN
	if(@sStudents is not null)
		BEGIN
		while len(@sStudents) > 0
			BEGIN
			INSERT INTO T_NotificationRecipient
			(
			 I_NotificationSchedule_ID
			,I_Recepient_ID
			,I_Type
			,S_CreatedBy
			,Dt_CreatedOn
			,S_MobileNumber
			,S_FireBase_Token
			,S_Email
			)
			--VALUES
			--(
			--@iLastNotificationScheduleID
			--,left(@sStudents, charindex(',', @sStudents+',')-1)
			--,1
			--,@SCreatedBy
			--,GETDATE()
			--)
			select 
			@iLastNotificationScheduleID
			,t2.I_Student_Detail_ID
			,1 --Student
			,@SCreatedBy
			,GETDATE()
			,t1.S_Mobile_No
			,t1.S_Firebase_Token
			,t1.S_Guardian_Email 
			from T_Parent_Master t1 right join T_Student_Detail t2
			on t2.S_Guardian_Mobile_No = t1.S_Mobile_No 
			where t2.I_Student_Detail_ID = left(@sStudents, charindex(',', @sStudents+',')-1) 
			and t1.I_IsPrimary = 1
			SET @sStudents = stuff(@sStudents, 1, charindex(',', @sStudents+','), '')
			END
		END
	END



if(@sTeachers is not null)
	BEGIN
	-- save for teachers
	while len(@sTeachers) > 0
		BEGIN
		INSERT INTO T_NotificationRecipient
		(
		 I_NotificationSchedule_ID
		,I_Recepient_ID
		,I_Type
		,S_CreatedBy
		,Dt_CreatedOn
		)
		VALUES
		(
		@iLastNotificationScheduleID
		,left(@sTeachers, charindex(',', @sTeachers+',')-1)
		,2 --- Teacher
		,@SCreatedBy
		,GETDATE()
		)
		SET @sTeachers = stuff(@sTeachers, 1, charindex(',', @sTeachers+','), '')
		END
	END





select 
NR.I_NotificationRecepient_ID NotificationRecepientID 
,NR.S_MobileNumber MobileNo
,NR.S_FireBase_Token FirebaseToken
,NR.S_Email GuardianEmail
,NA.AttachmentList
 from T_NotificationRecipient NR
 inner join
 (-- added by susmita for attachment : 2023Aug23
 SELECT I_NotificationSchedule_ID 
       ,STUFF((SELECT ', ' + CAST(S_AttachmentFileName AS VARCHAR(10)) [text()]
         FROM T_NotificationSchedule_Attachment 
         WHERE I_NotificationSchedule_ID=NSA.I_NotificationSchedule_ID
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') AttachmentList
FROM T_NotificationSchedule_Attachment NSA
GROUP BY I_NotificationSchedule_ID
 )
 as NA on NA.I_NotificationSchedule_ID=NR.I_NotificationSchedule_ID -- added by susmita for Attachment : 2023Aug23 
where NR.I_NotificationSchedule_ID = @iLastNotificationScheduleID
--select 1 StatusFlag,'Notification saved succesfully' Message,@iLastNotificationScheduleID LastNotificationId
--if(@sClasses!=null)
--BEGIN
---- save for students for classes
--while len(@sClasses) > 0
----(left(@sStudents, charindex(',', @sStudents+',')-1)
--set @sTeachers = stuff(@sClasses, 1, charindex(',', @sClasses+','), '')
--end
--END

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
