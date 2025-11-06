CREATE PROCEDURE [LMS].[uspUpdateTeacherInterfaceAPI]
(
@ID INT,
@ActionStatus INT,
@Remarks VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @dtCompletedOn DATETIME=NULL
	DECLARE @StatusID INT=1
	

	IF(@ActionStatus=1)
		SET @dtCompletedOn=GETDATE()


	if((select NoofAttempts+1 from LMS.T_Teacher_Details_Interface_API where ID=@ID)>=3)
		SET @StatusID=0



	update 	LMS.T_Teacher_Details_Interface_API set ActionStatus=@ActionStatus,NoofAttempts=NoofAttempts+1,StatusID=@StatusID,
													CompletedOn=@dtCompletedOn,Remarks=@Remarks
	where ID=@ID

	


END
