CREATE PROCEDURE [REPORT].[uspGetDefaultersDetailsReport] 
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtUptoDate datetime
)
AS
BEGIN TRY
	 SELECT DD.I_Student_Detail_ID,
			SD.S_Student_ID         AS Roll_NO,
			SD.S_Title              AS Title,
			SD.S_First_Name         AS First_Name,
			SD. S_Middle_Name       AS Middle_Name,
			SD.S_Last_Name          AS Last_Name,
			SCD.I_Course_ID,
			CM.S_Course_Code        AS Course_Code,
			CM.S_Course_Name        AS Course_Name,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			MAX(Dt_Attendance_Date) AS Attendance_Date,
			MAX(Dt_Receipt_Date)    AS Receipt_Date
	   INTO #tmpDefaulters

	   FROM ACADEMICS.T_Dropout_Details DD
			INNER JOIN dbo.T_Student_Detail SD
			ON SD.I_Student_Detail_ID=DD.I_Student_Detail_ID
			INNER JOIN dbo.T_Student_Course_Detail SCD
			ON SD.I_Student_Detail_ID=SCD.I_Student_Detail_ID
			INNER JOIN dbo.T_Course_Master CM
			ON SCD.I_Course_ID=CM.I_Course_ID
			LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
			ON DD.I_Student_Detail_ID = SAD.I_Student_Detail_ID
			AND SCD.I_Course_ID=SAD.I_Course_ID
			LEFT OUTER JOIN dbo.T_Receipt_Header RH
			ON DD.I_Student_Detail_ID = RH.I_Student_Detail_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON DD.I_Center_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			
	  WHERE I_Dropout_Status=1
		AND I_Dropout_Type_ID = 1
		AND DATEDIFF(dd,Dt_Dropout_Date,@dtUptoDate) <= 0
		AND [SD].[I_Student_Detail_ID] NOT IN 
		(SELECT DISTINCT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)		

   GROUP BY DD.I_Student_Detail_ID,
			SD.S_Student_ID,
			SD.S_Title,
			SD.S_First_Name,
			SD. S_Middle_Name,
			SD.S_Last_Name,
			SCD.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain


	 SELECT DISTINCT TMP.*,
			ED.S_Emp_ID             AS Emp_ID,
			ED.S_Title              AS Emp_Title,
			ED.S_First_Name         AS Emp_First_Name,
			ED.S_Middle_Name        AS Emp_Middle_Name,
			ED.S_Last_Name          AS Emp_Last_Name
	   FROM #tmpDefaulters TMP
			LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD
			ON TMP.I_Student_Detail_ID = SAD.I_Student_Detail_ID
			AND TMP.I_Course_ID=SAD.I_Course_ID
			AND TMP.Attendance_Date=SAD.Dt_Attendance_Date
			LEFT OUTER JOIN dbo.T_Employee_Dtls ED
			ON ED.I_Employee_ID=SAD.I_Employee_ID

	DROP TABLE #tmpDefaulters


END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
