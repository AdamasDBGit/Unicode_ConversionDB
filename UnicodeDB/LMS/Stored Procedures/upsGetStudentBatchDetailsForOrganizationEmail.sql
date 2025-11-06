


CREATE PROCEDURE [LMS].[upsGetStudentBatchDetailsForOrganizationEmail]
AS
BEGIN

	SELECT * FROM LMS.T_Student_Details_Interface_API WHERE StudentDetailID IS NOT NULL --and ID=20318
	AND ActionType!='STATUS UPDATE' and ActionType!='UPDATE STUDENT'
	AND (OrgEmailID IS NULL OR OrgEmailID = '')
	ORDER BY ID ASC

END
