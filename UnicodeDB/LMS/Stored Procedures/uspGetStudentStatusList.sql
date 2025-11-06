CREATE PROCEDURE [LMS].[uspGetStudentStatusList]
AS
begin

	SELECT * FROM LMS.T_Student_Details_Interface_API WHERE StatusID=1 AND ActionStatus=0 AND StudentDetailID IS NULL --and ID=177185
	order by ID ASC

end
