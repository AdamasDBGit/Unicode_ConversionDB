/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 02/05/2007
Description:Gets the list of Students based CenterID, TimeSlotID, 
			CourseID, TermID, ModuleID, 
			TimeSlotFlag = 1 for fetching student based on the TimeSlot
			0 = for fetching student not in that TimeSlot
			2 = for ignoring the TimeSlot while fetching the student
Parameters: CenterID, TimeSlotID,CourseID, TermID, ModuleID,TimeSlotFlag
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetStudentList]
(
	@iCenterID int,
	@iTimeSlotID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iSessionID int,
	@iTimeSlotFlag int
)
AS

BEGIN

IF @iTimeSlotFlag=0

SELECT SD.I_Student_Detail_ID,
	   SD.S_Student_ID,
	   SD.S_First_Name,
	   SD.S_Middle_Name,
	   SD.S_Last_Name
FROM T_Student_Course_Detail SCD
INNER JOIN T_Student_Module_Detail SMD 
ON SCD.I_Student_Detail_ID = SMD.I_Student_Detail_ID
INNER JOIN T_Student_Detail SD
ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
LEFT JOIN T_Student_Attendance_Details SAD WITH(NOLOCK)
ON SCD.I_Student_Detail_ID = SAD.I_Student_Detail_ID
AND SCD.I_Course_ID = SAD.I_Course_ID
AND SCD.I_Course_ID = SMD.I_Course_ID
AND SCD.I_Course_ID = @iCourseID
AND SCD.I_TimeSlot_ID <> @iTimeSlotID
AND SCD.I_Status <> 0
AND SCD.I_Is_Completed = 0
AND SMD.I_Module_ID = @iModuleID
AND SMD.I_Term_ID = @iTermID
AND SMD.I_Is_Completed = 0
AND SAD.I_Module_ID = @iModuleID
AND SAD.I_Term_ID = @iTermID 
AND SAD.I_Session_ID = @iSessionID 
AND SD.I_Status<>0

ELSE IF @iTimeSlotFlag=1

SELECT SD.I_Student_Detail_ID,
	   SD.S_Student_ID,
	   SD.S_First_Name,
	   SD.S_Middle_Name,
	   SD.S_Last_Name
FROM T_Student_Course_Detail SCD
INNER JOIN T_Student_Module_Detail SMD 
ON SCD.I_Student_Detail_ID = SMD.I_Student_Detail_ID
INNER JOIN T_Student_Detail SD
ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
LEFT JOIN T_Student_Attendance_Details SAD WITH(NOLOCK)
ON SCD.I_Student_Detail_ID = SAD.I_Student_Detail_ID
AND SCD.I_Course_ID = SAD.I_Course_ID
AND SCD.I_Course_ID = SMD.I_Course_ID
AND SCD.I_Course_ID = @iCourseID
AND SCD.I_TimeSlot_ID = @iTimeSlotID
AND SCD.I_Status <> 0
AND SMD.I_Module_ID = @iModuleID
AND SMD.I_Term_ID = @iTermID
AND SCD.I_Is_Completed = 0
AND SMD.I_Is_Completed = 0
AND SAD.I_Module_ID = @iModuleID
AND SAD.I_Term_ID = @iTermID 
AND SAD.I_Session_ID = @iSessionID 
AND SD.I_Status<>0

ELSE IF @iTimeSlotFlag=2

SELECT SD.I_Student_Detail_ID,
	   SD.S_Student_ID,
	   SD.S_First_Name,
	   SD.S_Middle_Name,
	   SD.S_Last_Name
FROM T_Student_Course_Detail SCD
INNER JOIN T_Student_Module_Detail SMD
ON SCD.I_Student_Detail_ID = SMD.I_Student_Detail_ID
INNER JOIN T_Student_Detail SD
ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
LEFT JOIN T_Student_Attendance_Details SAD WITH(NOLOCK)
ON SCD.I_Student_Detail_ID = SAD.I_Student_Detail_ID
AND SCD.I_Course_ID = SAD.I_Course_ID
AND SCD.I_Course_ID = SMD.I_Course_ID
AND SCD.I_Course_ID = @iCourseID
AND SCD.I_Status <> 0
AND SMD.I_Module_ID = @iModuleID
AND SMD.I_Term_ID = @iTermID
AND SCD.I_Is_Completed = 0
AND SMD.I_Is_Completed = 0
AND SAD.I_Module_ID = @iModuleID
AND SAD.I_Term_ID = @iTermID 
AND SAD.I_Session_ID = @iSessionID 
AND SD.I_Status<>0

END
