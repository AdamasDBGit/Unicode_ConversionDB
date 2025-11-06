/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Insert Check business rule for student placement registration 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspCheckBusinessRule]
(
@iStudentDetailID INT,
@iAge INT = null,
@iTime INT = NULL
)
AS
BEGIN

DECLARE @RtValid VARCHAR (1)
	
IF EXISTS(SELECT TS.S_Student_ID,TS.S_Age,TSC.Dt_Course_Start_Date,	TSC.Dt_Course_Expected_End_Date
	FROM T_Student_Detail TS INNER JOIN T_Student_Course_Detail TSC ON TS.I_Student_Detail_ID = TSC.I_Student_Detail_ID 
	WHERE TS.S_Age < @iAge	AND DATEDIFF(year,TSC.Dt_Course_Start_Date , TSC.Dt_Course_Expected_End_Date) >= @iTime
	AND TS.I_Student_Detail_ID = @iStudentDetailID )
BEGIN
	SET @RtValid ='T'
END
ELSE
 BEGIN
	SET @RtValid = 'F'
  END
SELECT @RtValid



END
