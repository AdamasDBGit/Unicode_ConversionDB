CREATE FUNCTION [ACADEMICS].[ufnGetStudentDropoutLeaveStatus]
(
	@iStudentID int,
	@iCenterID int,
	@CurrentDate datetime
)
RETURNS  CHAR(1)

AS 
-- Returns the Student Status whether ON LEAVE or DROPOUT.
BEGIN
DECLARE @cDropoutStatus CHAR(1)

SET @CurrentDate=CAST(SUBSTRING(CAST(@CurrentDate AS VARCHAR),1,11) as datetime)

-- Check if Student is on leave
IF EXISTS(SELECT A.I_Student_Leave_ID 
				FROM dbo.T_Student_Leave_Request A
				INNER JOIN  dbo.T_Student_Center_Detail B
				ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
                WHERE A.I_Student_Detail_ID = @iStudentID
				AND DATEDIFF(DAY, A.Dt_From_Date, @CurrentDate) >= 0
				AND DATEDIFF(DAY, @CurrentDate, A.Dt_To_Date) >= 0
				--AND A.Dt_From_Date <= @dCurrenDate
				--AND A.Dt_To_Date >= @dCurrenDate
				AND A.I_Status = 1
				AND B.I_Status = 1
                AND B.I_Centre_ID = @iCenterID)
BEGIN
	SET @cDropoutStatus = 'Y'
END
-- Check if Student is Dropout
ELSE IF EXISTS(SELECT I_Dropout_ID
				FROM Academics.T_Dropout_Details DD
				INNER JOIN dbo.T_Student_Center_Detail SCD
				ON DD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
				WHERE DD.I_Student_Detail_ID = @iStudentID
				AND DD.I_Dropout_Status = 1
				AND SCD.I_Status = 1
				AND SCD.I_Centre_ID = @iCenterID) 
BEGIN

	SET @cDropoutStatus = 'Y'
END
ELSE
-- Default 'N'
BEGIN
	SET @cDropoutStatus = 'N'
END	
    -- Return the information to the caller
    RETURN @cDropoutStatus

END