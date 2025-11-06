CREATE PROCEDURE [LMS].[uspGetTeacherDetailsFromInterface]
AS
BEGIN

	select DISTINCT A.* from [LMS].[T_Teacher_Details_Interface_API] A
	inner join LMS.T_Teacher_CentreMap_Details_API B on A.ID=B.ID
	WHERE A.StatusID=1 and A.NoofAttempts<3 and A.ActionStatus=0 and B.StatusID=1 --and A.ID=8

	select * from LMS.T_Teacher_CentreMap_Details_API WHERE StatusID=1 --and ID=8


END
