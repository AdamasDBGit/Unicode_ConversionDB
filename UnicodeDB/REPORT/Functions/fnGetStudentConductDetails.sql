
CREATE FUNCTION REPORT.fnGetStudentConductDetails
(
	@iStudentID INT,
	@iTermID INT,
	@iBatchID INT
)
RETURNS	VARCHAR(20)
AS
BEGIN
	DECLARE @sConduct VARCHAR(20)

	SELECT TOP 1 @sConduct = tcm.S_Conduct_Code FROM dbo.T_Student_Term_Detail AS tstd
	INNER JOIN dbo.T_Conduct_Master AS tcm ON tstd.I_Conduct_Id = tcm.I_Conduct_Id AND I_Status = 1
	WHERE I_Student_Detail_ID = @iStudentID
	AND I_Term_ID = @iTermID
	AND I_Batch_ID = @iBatchID
	
	RETURN @sConduct
END