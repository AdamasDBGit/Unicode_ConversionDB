CREATE PROCEDURE [LMS].[uspStudentInterfaceResetAPI]
(
@ID int
)
AS
BEGIN

	DECLARE @ActionStatus int=0
	DECLARE @StatusID int=1
	declare @NoofAttempts int=0



	if((select ActionStatus from LMS.T_Student_Details_Interface_API where ID=@ID)=0 
	and (select NoofAttempts from LMS.T_Student_Details_Interface_API where ID=@ID)>=2)
	begin
	   set @NoofAttempts = 0
	   update 	LMS.T_Student_Details_Interface_API 
	   set NoofAttempts=@NoofAttempts,StatusID=@StatusID
	where ID=@ID
    end
   
END
