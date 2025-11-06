
CREATE PROCEDURE [LMS].[upsGetStudentBatchDetails_BeforeClassicRemoval2022_11_30]
AS
BEGIN

	SELECT * FROM LMS.T_Student_Details_Interface_API WHERE StatusID=1 AND ActionStatus=0 AND StudentDetailID IS NOT NULL --and ID=20318
	AND ActionType!='STATUS UPDATE' and ActionType!='UPDATE STUDENT'
	AND (CustomerID!='' AND CustomerID IS NOT NULL)
	ORDER BY ID ASC

END
