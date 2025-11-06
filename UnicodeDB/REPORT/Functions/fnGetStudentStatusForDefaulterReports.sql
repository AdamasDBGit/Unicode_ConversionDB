CREATE FUNCTION [REPORT].[fnGetStudentStatusForDefaulterReports]
(
@iStudentID INT,
@iCenterID INT,
@CurrentDate DATETIME
)

RETURNS VARCHAR(50)

AS
-- Returns the Student Status whether ON LEAVE/BREAK or DROPOUT.
BEGIN

DECLARE @Status varchar(50)
DECLARE @Dropout VARCHAR(100)

SET @Status = 'INACTIVE'

IF EXISTS ( SELECT I_Student_Detail_ID
FROM dbo.T_Student_Detail
WHERE I_Student_Detail_ID=@iStudentID
AND I_Status=1
)
BEGIN
IF EXISTS (SELECT I_Student_Leave_ID
FROM dbo.T_Student_Leave_Request
WHERE I_Student_Detail_ID=@iStudentID
AND Dt_From_Date <=@CurrentDate
AND Dt_To_Date >=@CurrentDate
AND I_Status=1
AND S_Leave_Type ='B'
)
BEGIN
SET @Status = 'BREAK'
END
ELSE IF EXISTS (SELECT I_Student_Leave_ID
FROM dbo.T_Student_Leave_Request
WHERE I_Student_Detail_ID=@iStudentID
AND Dt_From_Date <=@CurrentDate
AND Dt_To_Date >=@CurrentDate
AND I_Status=1
AND S_Leave_Type ='L'
)
BEGIN
SET @Status = 'LEAVE'
END
ELSE
BEGIN
SET @Status = 'ACTIVE'
END
END
ELSE IF EXISTS ( SELECT DTM.S_Description
FROM ACADEMICS.T_Dropout_Details DD
INNER JOIN ACADEMICS.T_Dropout_Type_Master DTM
ON DD.I_Dropout_Type_ID=DTM.I_Dropout_Type_ID
WHERE DD.I_Dropout_Status=1
AND DD.I_Student_Detail_ID=@iStudentID
AND DD.I_Center_Id=@iCenterID
AND Dt_Dropout_Date<=@CurrentDate
)

BEGIN
SET @Dropout = ''
SELECT @Dropout = @Dropout + ',' + DTM.S_Description
FROM ACADEMICS.T_Dropout_Details DD
INNER JOIN ACADEMICS.T_Dropout_Type_Master DTM
ON DD.I_Dropout_Type_ID=DTM.I_Dropout_Type_ID
WHERE DD.I_Dropout_Status=1
AND DD.I_Student_Detail_ID=@iStudentID
AND DD.I_Center_Id=@iCenterID
AND Dt_Dropout_Date<=ISNULL(@CurrentDate,GETDATE())

SET @Status = @Dropout
END

RETURN @Status
END