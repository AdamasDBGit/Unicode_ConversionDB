CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentLeaveRequestList]
(
	-- Add the parameters for the stored procedure here
	@iCenterID int
)

AS
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  LReq.*,
			SD.S_Student_ID, 
			SD.S_First_Name,
			SD.S_Middle_Name,
			SD.S_Last_Name
	FROM dbo.T_Student_Leave_Request AS LReq
	INNER JOIN dbo.T_Student_Detail AS SD
	ON LReq.I_Student_Detail_ID = SD.I_Student_Detail_ID
	AND SD.I_Status =1
	INNER JOIN dbo.T_Student_Center_Detail SCD
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	WHERE SCD.I_Centre_Id = @iCenterID
	AND SCD.I_Status = 1
	AND GETDATE() >= ISNULL(SCD.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(SCD.Dt_Valid_To, GETDATE())
	ORDER BY LReq.I_Status DESC, LReq.Dt_From_Date DESC
