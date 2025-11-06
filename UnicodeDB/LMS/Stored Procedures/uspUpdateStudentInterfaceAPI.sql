CREATE PROCEDURE [LMS].[uspUpdateStudentInterfaceAPI]
(
@ID INT,
@ActionStatus INT,
@Remarks VARCHAR(MAX),
@PrimaryEmail VARCHAR(MAX),
@Password VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @dtCompletedOn DATETIME=NULL
	DECLARE @StatusID INT=1
	DECLARE @ActionType VARCHAR(MAX)=NULL
	Declare @sMobileNo VARCHAR(MAX)
	Declare @iStudentID INT
	
	select @ActionType=ActionType,@sMobileNo=ContactNo,@iStudentID=StudentDetailID from LMS.T_Student_Details_Interface_API where ID=@ID

	IF(@ActionStatus=1)
		SET @dtCompletedOn=GETDATE()


	if((select NoofAttempts+1 from LMS.T_Student_Details_Interface_API where ID=@ID)>=3)
		SET @StatusID=0



	update 	LMS.T_Student_Details_Interface_API set ActionStatus=@ActionStatus,NoofAttempts=NoofAttempts+1,StatusID=@StatusID,
													CompletedOn=@dtCompletedOn,Remarks=@Remarks
	where ID=@ID

--	IF(@ActionType='ADD STUDENT')
--	begin
		
--		if(@PrimaryEmail!='' and @Password!='')
--		begin

--		update 	LMS.T_Student_Details_Interface_API set OrgEmailID=@PrimaryEmail where ID=@ID

--		update T_Student_Detail set S_OrgEmailID=@PrimaryEmail,S_OrgEmailPassword=@Password
--		where
--		I_Student_Detail_ID=(select A.StudentDetailID from LMS.T_Student_Details_Interface_API A where A.ID=@ID)

--		end

----		INSERT INTO dbo.T_SMS_SEND_DETAILS
----        ( S_MOBILE_NO ,
----          I_SMS_STUDENT_ID ,
----          I_SMS_TYPE_ID ,
----          S_SMS_BODY ,
          
          
----          I_REFERENCE_ID ,
----          I_REFERENCE_TYPE_ID ,
          
----          I_Status ,
----          S_Crtd_By ,
          
----          Dt_Crtd_On 
          
----        )
----VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
----          @iStudentID , -- I_SMS_STUDENT_ID - int
----          14 , -- I_SMS_TYPE_ID - int
----          'Dear student, Your MS Teams User ID:'+@PrimaryEmail+' Pwd:'+@Password+' User manual: https://bit.ly/3hc7MTY please login with above details thanks.' , -- S_SMS_BODY - varchar(160)
          
          
----          @iStudentID , -- I_REFERENCE_ID - int
----          3 , -- I_REFERENCE_TYPE_ID - int
         
----          1 , -- I_Status - int
----          'dba' , -- S_Crtd_By - varchar(20)
          
----          GETDATE()  -- Dt_Crtd_On - datetime
          
----        )

--	end
	


	


END
