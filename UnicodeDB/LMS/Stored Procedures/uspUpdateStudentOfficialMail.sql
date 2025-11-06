CREATE PROCEDURE [LMS].[uspUpdateStudentOfficialMail]
(
	@ID INT,
	@PrimaryEmail VARCHAR(MAX),
	@Password VARCHAR(MAX)
)
AS
BEGIN


	Declare @iStudentID INT
	
	select @iStudentID=StudentDetailID from LMS.T_Student_Details_Interface_API where ID=@ID

	if(@PrimaryEmail!='' and @Password!='' and @PrimaryEmail IS NOT NULL and @Password is not null)
		begin

		update 	LMS.T_Student_Details_Interface_API set OrgEmailID=@PrimaryEmail where ID=@ID

		update T_Student_Detail set S_OrgEmailID=@PrimaryEmail,S_OrgEmailPassword=@Password
		where
		I_Student_Detail_ID=(select A.StudentDetailID from LMS.T_Student_Details_Interface_API A where A.ID=@ID)

	end



END
