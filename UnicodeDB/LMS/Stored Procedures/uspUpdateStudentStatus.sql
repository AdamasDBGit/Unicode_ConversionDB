CREATE PROCEDURE [LMS].[uspUpdateStudentStatus](@StudentID VARCHAR(MAX),@StatusName VARCHAR(MAX),@StatusFlag BIT, @DueAmount Decimal(14,2), @DefaulterDate Datetime, @DueCourses VARCHAR(MAX)='')
as
begin

IF(@StatusName='Dropout')
BEGIN



	update T_Student_Detail set IsDropOut=@StatusFlag where S_Student_ID=@StudentID

END

IF(@StatusName='Waiting')
BEGIN

	update T_Student_Detail set IsWaiting=@StatusFlag where S_Student_ID=@StudentID

END


IF(@StatusName='Defaulter')
BEGIN

	IF
	(
		((SELECT ISNULL(IsDefaulter,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
		--OR
		--((SELECT ISNULL(DefaulterCourses,'') FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=ISNULL(@DueCourses,''))
	)
	BEGIN

		INSERT INTO [LMS].[T_Student_Details_Interface_API]
		(
		StudentID,
		StudentStatus,
		StatusFlag,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn,
		DueAmount
		)
		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE(),@DueAmount

	END

	update T_Student_Detail set IsDefaulter=@StatusFlag,DefaulterCourses=@DueCourses where S_Student_ID=@StudentID

END

--IF(@StatusName='Leave')
--BEGIN

--	IF ((SELECT ISNULL(IsOnLeave,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
--	BEGIN

--		INSERT INTO [LMS].[T_Student_Details_Interface_API]
--		(
--		StudentID,
--		StudentStatus,
--		StatusFlag,
--		ActionType,
--		ActionStatus,
--		NoofAttempts,
--		StatusID,
--		CreatedOn
--		)
--		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE()

--	END

--	update T_Student_Detail set IsOnLeave=@StatusFlag where S_Student_ID=@StudentID

--END

IF(@StatusName='Completed')
BEGIN

	IF ((SELECT ISNULL(IsCompleted,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
	BEGIN

		INSERT INTO [LMS].[T_Student_Details_Interface_API]
		(
		StudentID,
		StudentStatus,
		StatusFlag,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn
		)
		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE()

	END

	update T_Student_Detail set IsCompleted=@StatusFlag where S_Student_ID=@StudentID

END

IF(@StatusName='Discontinued')
BEGIN

	IF ((SELECT ISNULL(IsDiscontinued,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
	BEGIN

		INSERT INTO [LMS].[T_Student_Details_Interface_API]
		(
		StudentID,
		StudentStatus,
		StatusFlag,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn
		)
		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE()

	END

	update T_Student_Detail set IsDiscontinued=@StatusFlag where S_Student_ID=@StudentID

END

IF(@StatusName='PreDefaulter')
BEGIN

	IF ((SELECT ISNULL(I_IsPreDefaulter,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
	BEGIN

		INSERT INTO [LMS].[T_Student_Details_Interface_API]
		(
		StudentID,
		StudentStatus,
		StatusFlag,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn,
		DefaulterDate
		)
		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE(),@DefaulterDate

	END

	update T_Student_Detail set I_IsPreDefaulter=@StatusFlag where S_Student_ID=@StudentID

END

IF(@StatusName='PaymentDue')
BEGIN

	IF ((SELECT ISNULL(IsPaymentDue,0) FROM T_Student_Detail WHERE S_Student_ID=@StudentID)!=@StatusFlag)
	BEGIN

		INSERT INTO [LMS].[T_Student_Details_Interface_API]
		(
		StudentID,
		StudentStatus,
		StatusFlag,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn,
		DefaulterDate
		)
		SELECT @StudentID,LOWER(@StatusName),@StatusFlag,'STATUS UPDATE',0,0,1,GETDATE(),@DefaulterDate

	END

	update T_Student_Detail set IsPaymentDue=@StatusFlag where S_Student_ID=@StudentID

END


end 


--ALTER TABLE T_Student_Detail
--ADD DefaulterCourses VARCHAR(MAX) DEFAULT ''
