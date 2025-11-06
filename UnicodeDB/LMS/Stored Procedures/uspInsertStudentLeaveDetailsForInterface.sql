CREATE PROCEDURE [LMS].[uspInsertStudentLeaveDetailsForInterface]
(
@StudentDetailID INT,
@LeaveID INT,
@StartDate DATETIME,
@EndDate DATETIME,
@ActionType VARCHAR(MAX)=NULL
)
AS
BEGIN

	IF (@ActionType='ADD')
	begin

		insert into LMS.T_Student_Leave_Details_Interface_API
		select A.I_Student_Detail_ID,A.S_Student_ID,A.S_First_Name,ISNULL(A.S_Middle_Name,'') as MiddleName,A.S_Last_Name,@LeaveID,@StartDate,@EndDate,
		@ActionType,0,0,1,GETDATE(),NULL,NULL
		from 
		T_Student_Detail A 
		where A.I_Student_Detail_ID=@StudentDetailID


	end
	


END
