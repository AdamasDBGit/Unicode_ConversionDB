
--EXEC REPORT.uspStudentDetail @iBatchID = 783, @iStudentID = 4695
--EXEC REPORT.uspStudentDetail @iBatchID = 1656
--EXEC REPORT.uspStudentDetail @iBatchID = 8058, @iStudentID = 6077
CREATE PROCEDURE [REPORT].[uspStudentDetail] 
	@iBatchID INT
	,@iStudentID INT = NULL
AS
BEGIN	
	
	SELECT DISTINCT
	TSD.I_Student_Detail_ID
	, TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') 
                        + ' ' + TSD.S_Last_Name AS [S_Student_Name]
	,TSD.S_Student_ID AS S_Roll_No
	,tcm.I_Course_ID
	,tcm.S_Course_Name
	,@iBatchId AS I_Batch_Id
	,tsbm.S_Batch_Name AS S_Batch_Name
	,S_Student_Photo
	,(SELECT 
			CONVERT(VARCHAR(4),YEAR(SBM.Dt_BatchStartDate)) +'-'+ RIGHT(CONVERT(VARCHAR(4),YEAR(SBM.Dt_BatchStartDate)+1),2)  
		FROM T_Student_Batch_Master SBM WITH (NOLOCK) WHERE I_Batch_ID = @iBatchID
		) AS S_Academic_Session
	FROM dbo.T_Student_Batch_Details TSBD WITH (NOLOCK)
	INNER JOIN dbo.T_Student_Detail AS TSD WITH (NOLOCK) ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
	INNER JOIN dbo.T_Student_Batch_Master AS tsbm WITH (NOLOCK) ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
	INNER JOIN T_Course_Master tcm WITH (NOLOCK) ON tcm.I_Course_ID = tsbm.I_Course_ID
	INNER JOIN T_Enquiry_Regn_Detail E  WITH (NOLOCK) ON E.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
	WHERE TSBD.I_Batch_ID= @iBatchID
	AND I_Student_Id =ISNULL(@iStudentID, I_Student_Id)
	AND TSBD.I_Status IN ( 1, 2 ) 
END
