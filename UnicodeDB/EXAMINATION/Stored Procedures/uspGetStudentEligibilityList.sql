--uspGetStudentEligibilityList 1,1,1,1
/**************************************************************************************************************
Created by  : DEBARSHI BASU
Date		: 05.05.2007
Description : This SP will retrieve students eligible for an exam
Parameters  : CenterId,CourseId,TermId,ModuleId
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetStudentEligibilityList] 
	@iCenterID int = null,
	@iCourseID int = null ,
	@iTermID int = null,
	@iModuleID int = null
AS
BEGIN

	SELECT I_Student_Detail_ID,S_Student_ID,
	S_First_Name,S_Middle_Name,S_Last_Name 
	FROM dbo.T_Student_Detail
	WHERE dbo.ufnGetStudentStatus(@iCenterID,I_Student_Detail_ID) = 'Active'
	/*AND 
	dbo.ufnGetStudentStatusAttendance(@iCenterID, I_Student_Detail_ID, @iCourseID, @iTermID,@iModuleID) = 'Cleared'
	*/
END
