CREATE FUNCTION [dbo].[fnGetStudentCourseDetailForShortTermCourse]
(
	@StudentID INT,
	@iCourseID INT	
)
RETURNS @Temp TABLE
(
DtStartDate DATETIME,
DtEndDate DATETIME,
Duration INT
)

AS 
 --Return the Table containing the student marks details.
BEGIN

DECLARE @DtStartDate DATETIME
DECLARE @DtEndDate DATETIME
DECLARE @iSessionTime INT
DECLARE @Duration INT	

---- For start day 
	SET @DtStartDate = (SELECT  TOP 1(Dt_Attendance_Date)
	FROM dbo.T_Student_Attendance_Details
	WHERE I_Student_Detail_ID = @StudentID
	AND I_Has_Attended = 1
	AND I_Course_ID = ISNULL(@iCourseID,I_Course_ID))

-- Course end day

SET @DtEndDate =(SELECT Max(Dt_Crtd_On) FROM PSCERTIFICATE.T_Student_PS_Certificate
WHERE I_Student_Detail_ID = @StudentID
AND I_Course_ID = ISNULL(@iCourseID,I_Course_ID)
AND B_PS_Flag = 0)


SET @iSessionTime = (SELECT SUM(B.N_Session_Duration)
					FROM dbo.T_Session_Module_Map A
						INNER JOIN dbo.T_Session_Master B
						ON A.I_Session_ID = B.I_Session_ID
						INNER JOIN dbo.T_Module_Term_Map C
						ON A.I_Module_ID = C.I_Module_ID
						INNER JOIN dbo.T_Term_Course_Map D   
						ON C.I_Term_ID = D.I_Term_ID
						AND D.I_Course_ID = @iCourseID
						AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
						AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
						AND A.I_Status <> 0
						AND B.I_Status <> 0
						AND C.I_Status <> 0
						AND D.I_Status <> 0
						GROUP BY B.N_Session_Duration)


IF(@iSessionTime <> 0)
BEGIN
	SET @Duration = (SELECT ROUND((@iSessionTime/60),0))
END

INSERT INTO @Temp
SELECT @DtStartDate, @DtEndDate, ISNULL(@Duration,0)


	RETURN;
END