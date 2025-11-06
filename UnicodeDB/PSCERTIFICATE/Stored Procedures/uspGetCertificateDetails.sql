CREATE PROCEDURE [PSCERTIFICATE].[uspGetCertificateDetails]
(
	@sCertIDs VARCHAR(8000)
)
AS
BEGIN
	SELECT	[TSD].[S_Title], [TSD].[S_First_Name], [TSD].[S_Middle_Name], [TSD].[S_Last_Name],
			[TSD].[S_Student_ID], [TCM].[S_Course_Name], 
			ISNULL([TCBD].[Dt_Upd_On],ISNULL([TSBM].[Dt_Course_Actual_End_Date],[TSBM].[Dt_Course_Expected_End_Date])) AS BatchEndDate,
			[TCM2].[S_Center_Name], [PSCERTIFICATE].fnGetTotalCourseDuration(TSPC.[I_Course_ID]) AS Duration,
			[PSCERTIFICATE].uspGetPerformanceRating(TSPC.[I_Student_Detail_ID], TSPC.[I_Course_ID]) AS Rating
	FROM [PSCERTIFICATE].[T_Student_PS_Certificate] AS TSPC
	INNER JOIN [dbo].[T_Student_Detail] AS TSD
	ON [TSPC].[I_Student_Detail_ID] = [TSD].[I_Student_Detail_ID]
	INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD
	ON [TSD].[I_Student_Detail_ID] = [TSCD].[I_Student_Detail_ID]
	AND [TSCD].[I_Course_ID] = [TSPC].[I_Course_ID]
	INNER JOIN [dbo].[T_Course_Master] AS TCM
	ON [TSPC].[I_Course_ID] = [TCM].[I_Course_ID]
	INNER JOIN [dbo].[T_Centre_Master] AS TCM2
	ON [TCM2].[I_Centre_Id] = [TSCD].[I_Centre_Id]
	INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
	ON [TSBM].[I_Batch_ID] = [TSCD].[I_Batch_ID]
	INNER JOIN [dbo].[T_Center_Batch_Details] AS TCBD
	ON [TSCD].[I_Centre_Id] = [TCBD].[I_Centre_Id]
	AND [TCBD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
	WHERE [TSPC].[I_Student_Certificate_ID] IN
	(SELECT [FSR].[Val] FROM [dbo].[fnString2Rows](@sCertIDs,',') AS FSR)
END
