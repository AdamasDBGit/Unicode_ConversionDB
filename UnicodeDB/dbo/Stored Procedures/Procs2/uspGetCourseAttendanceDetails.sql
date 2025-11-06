/**************************************************************************************************************
Created by  : Swagata De
Date		: 02.04.2007
Description : This SP will retrieve Course Duration,Completed duration for a particular course and center
Parameters  : student detail id,center id
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspGetCourseAttendanceDetails]

(
	 @iStudentDetailId int,
	 @iCenterId int
)

AS
BEGIN TRY 

	DECLARE
		@iTotalRowCount int,
		@iRowCount int
	
	DECLARE @tblAttendanceDtls TABLE
	(
		[ID] INT IDENTITY(1,1),
		I_Student_Detail_ID INT,
		I_Centre_Id INT,
		I_Course_ID INT,
		I_No_Of_Sessions INT,
		I_Attended_Sessions INT,
		I_Total_Duration_Days INT,
		I_Attended_Duration_Days INT
		
	)

	INSERT INTO @tblAttendanceDtls
	(
		I_Student_Detail_ID,
		I_Centre_Id,
		I_Course_ID,
		I_No_Of_Sessions
	)

	SELECT I_Student_Detail_ID,I_Centre_Id,I_Course_ID,ISNULL(COUNT(*),0)
	FROM dbo.T_Student_Attendance_Details
	GROUP BY I_Student_Detail_ID,I_Course_ID,I_Centre_Id
	HAVING I_Student_Detail_ID=@iStudentDetailId AND I_Centre_Id=@iCenterId

	UPDATE TAD
	SET TAD.I_Attended_Sessions=TT.I_Attended_Sessions
	FROM @tblAttendanceDtls TAD,
	(SELECT I_Student_Detail_ID,I_Centre_Id,I_Course_ID,ISNULL(COUNT(*),0) AS I_Attended_Sessions
	FROM dbo.T_Student_Attendance_Details
	WHERE  I_Has_Attended='TRUE'
	GROUP BY I_Student_Detail_ID,I_Course_ID,I_Centre_Id
	HAVING I_Student_Detail_ID=@iStudentDetailId AND I_Centre_Id=@iCenterId
	) TT
	WHERE TAD.I_Student_Detail_ID=TT.I_Student_Detail_ID
	
	SET @iTotalRowCount=(SELECT COUNT(*) FROM @tblAttendanceDtls)
	SET @iRowCount=1
	
	WHILE (@iRowCount<=@iTotalRowCount)
	BEGIN
		DECLARE 
		@iStDtlID INT,
		@iCtrID INT,
		@iCrseID INT,
		@iSessionDayGap INT
		
		SELECT @iStDtlID=I_Student_Detail_ID,@iCtrID=I_Centre_Id,@iCrseID=I_Course_ID
		FROM @tblAttendanceDtls WHERE [ID]=@iRowCount
		
		SET @iSessionDayGap=ISNULL(dbo.fnGetSessionDayGap(@iStDtlID,@iCtrID,@iCrseID),0)

		UPDATE @tblAttendanceDtls
		SET I_Total_Duration_Days=I_No_Of_Sessions*@iSessionDayGap,I_Attended_Duration_Days=I_Attended_Sessions*@iSessionDayGap
		WHERE [ID]=@iRowCount
		
		 SET @iRowCount=@iRowCount+1		
	END
	
SELECT I_Student_Detail_ID,	I_Centre_Id ,I_Course_ID,I_No_Of_Sessions ,I_Attended_Sessions ,I_Total_Duration_Days ,I_Attended_Duration_Days 
FROM @tblAttendanceDtls
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
