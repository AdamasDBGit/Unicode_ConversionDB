
CREATE PROCEDURE [LMS].[upsGetStudentBatchDetails]
AS
BEGIN

	SELECT * FROM LMS.T_Student_Details_Interface_API WHERE StatusID=1 AND ActionStatus=0 AND StudentDetailID IS NOT NULL --and ID=20318
	AND ActionType!='STATUS UPDATE' and ActionType!='UPDATE STUDENT'
	AND (CustomerID!='' AND CustomerID IS NOT NULL)
	AND CentreID in (132) ---added by susmita : 2022-11-30: for pick only Pro students
	ORDER BY ID ASC

END
