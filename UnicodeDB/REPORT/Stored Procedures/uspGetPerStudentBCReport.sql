CREATE PROCEDURE [REPORT].[uspGetPerStudentBCReport] 
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@iCourseFamilyID int= NULL,
	@sCourseFamilyName varchar(50) = NULL
)

AS

BEGIN TRY
	SET NOCOUNT ON
---------------------------------------------------------	
	 SELECT IP.I_Invoice_Header_ID,
			IP.I_Student_Detail_ID,
			ICH.I_Invoice_Child_Header_ID,
			ICH.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			CFM.S_CourseFamily_Name,
			ICD.I_Invoice_Detail_ID,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code,
			ISNULL(ICD.N_Amount_Due,0.00) AS N_Amount_Due,
			SUM(ISNULL(IDT.N_Tax_Value,0.00)) AS N_Tax_Value
	   INTO #TmpBCRpt11

	   FROM dbo.T_Invoice_Parent IP
			INNER JOIN dbo.T_Invoice_Child_Header ICH
			ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
			INNER JOIN dbo.T_Invoice_Child_Detail ICD
			ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
			LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax IDT
			ON ICD.I_Invoice_Detail_ID=IDT.I_Invoice_Detail_ID
			INNER JOIN dbo.T_Course_Master CM
			ON ICH.I_Course_ID=CM.I_Course_ID
			INNER JOIN dbo.T_CourseFamily_Master CFM
			ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON IP.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_Centre_Master CEM
			ON FN1.CenterID=CEM.I_Centre_Id
			INNER JOIN dbo.T_Country_Master COM
			ON CEM.I_Country_ID=COM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CUM
			ON COM.I_Currency_ID=CUM.I_Currency_ID
	  WHERE CFM.I_CourseFamily_ID=ISNULL(@iCourseFamilyID,CFM.I_CourseFamily_ID)
	AND CAST(SUBSTRING(CAST(IP.Dt_Invoice_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
	AND [IP].[I_Student_Detail_ID] NOT IN (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
   GROUP BY IP.I_Invoice_Header_ID,
			IP.I_Student_Detail_ID,
			ICH.I_Invoice_Child_Header_ID,
			ICH.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			CFM.S_CourseFamily_Name,
			ICD.I_Invoice_Detail_ID,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code,
			ICD.N_Amount_Due

	 SELECT IP.I_Invoice_Header_ID,
			IP.I_Student_Detail_ID,
			ICH.I_Invoice_Child_Header_ID,
			ICH.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			CFM.S_CourseFamily_Name,
			ICD.I_Invoice_Detail_ID,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code,
			-ISNULL(ICD.N_Amount_Due,0.00) AS N_Amount_Due,
			-SUM(ISNULL(IDT.N_Tax_Value,0.00)) AS N_Tax_Value
	   INTO #TmpBCRpt12
	   FROM dbo.T_Invoice_Parent IP
			INNER JOIN dbo.T_Invoice_Child_Header ICH
			ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
			INNER JOIN dbo.T_Invoice_Child_Detail ICD
			ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
			LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax IDT
			ON ICD.I_Invoice_Detail_ID=IDT.I_Invoice_Detail_ID
			INNER JOIN dbo.T_Course_Master CM
			ON ICH.I_Course_ID=CM.I_Course_ID
			INNER JOIN dbo.T_CourseFamily_Master CFM
			ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON IP.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_Centre_Master CEM
			ON FN1.CenterID=CEM.I_Centre_Id
			INNER JOIN dbo.T_Country_Master COM
			ON CEM.I_Country_ID=COM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CUM
			ON COM.I_Currency_ID=CUM.I_Currency_ID
	  WHERE CFM.I_CourseFamily_ID=ISNULL(@iCourseFamilyID,CFM.I_CourseFamily_ID)
		AND IP.I_STATUS=0 
		AND CAST(SUBSTRING(CAST(IP.DT_UPD_ON AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
		AND [IP].[I_Student_Detail_ID] NOT IN (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
   GROUP BY IP.I_Invoice_Header_ID,
			IP.I_Student_Detail_ID,
			ICH.I_Invoice_Child_Header_ID,
			ICH.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			CFM.S_CourseFamily_Name,
			ICD.I_Invoice_Detail_ID,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code,
			ICD.N_Amount_Due

SELECT T1.* INTO #TmpBCRpt1 FROM
(
	SELECT * FROM #TmpBCRpt11
	UNION ALL
	SELECT * FROM #TmpBCRpt12
) T1

---------------------------------------

	 SELECT TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value,
			RCD.I_Receipt_Comp_Detail_ID,
			ISNULL(RCD.N_Amount_Paid,0.00) AS N_Amount_Paid,
			SUM(ISNULL(RTD.N_Tax_Paid,0.00)) AS N_Tax_Paid
	   INTO #TmpBCRpt21
	   FROM #TmpBCRpt1 TMP
			LEFT OUTER JOIN dbo.T_Receipt_Header RH
			ON TMP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
			LEFT OUTER JOIN dbo.T_Receipt_Component_Detail RCD
			ON RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID
			AND TMP.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
			LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail RTD
			ON RCD.I_Receipt_Comp_Detail_ID=RTD.I_Receipt_Comp_Detail_ID
	WHERE 
		 CAST(SUBSTRING(CAST( RH.Dt_Receipt_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
	GROUP BY TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value,
			RCD.I_Receipt_Comp_Detail_ID,
			RCD.N_Amount_Paid



	SELECT TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value,
			RCD.I_Receipt_Comp_Detail_ID,
			-ISNULL(RCD.N_Amount_Paid,0.00) AS N_Amount_Paid,
			-SUM(ISNULL(RTD.N_Tax_Paid,0.00)) AS N_Tax_Paid
	   INTO #TmpBCRpt22
	   FROM #TmpBCRpt1 TMP
			LEFT OUTER JOIN dbo.T_Receipt_Header RH
			ON TMP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
			LEFT OUTER JOIN dbo.T_Receipt_Component_Detail RCD
			ON RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID
			AND TMP.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
			LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail RTD
			ON RCD.I_Receipt_Comp_Detail_ID=RTD.I_Receipt_Comp_Detail_ID
	WHERE RH.I_STATUS=0 
	AND CAST(SUBSTRING(CAST( RH.DT_UPD_ON AS VARCHAR),1,11) AS DATETIME) BETWEEN @DTSTARTDATE AND @DTENDDATE
	GROUP BY TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value,
			RCD.I_Receipt_Comp_Detail_ID,
			RCD.N_Amount_Paid

	SELECT T2.* INTO #TmpBCRpt2 FROM
	(
		SELECT * FROM #TmpBCRpt21
		UNION ALL
		SELECT * FROM #TmpBCRpt22
	) T2

------------------------------------------------

	 SELECT TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value,
			SUM(N_Amount_Paid) AS N_Amount_Paid,
			SUM(N_Tax_Paid) AS N_Tax_Paid
	   INTO #TmpBCRpt3
	   FROM #TmpBCRpt2 TMP
   GROUP BY TMP.I_Invoice_Header_ID,
			TMP.I_Student_Detail_ID,
			TMP.I_Invoice_Child_Header_ID,
			TMP.I_Course_ID,
			TMP.S_Course_Code,
			TMP.S_Course_Name,
			TMP.S_CourseFamily_Name,
			TMP.I_Invoice_Detail_ID,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			TMP.S_Currency_Code,
			TMP.N_Amount_Due,
			TMP.N_Tax_Value


	 SELECT InstanceChain,
			CenterCode,
			CenterName,
			S_Currency_Code,
			S_CourseFamily_Name,
			S_Course_Code,
			S_Course_Name,
			COUNT(DISTINCT I_Student_Detail_ID) AS Enroll_Total,
			SUM(N_Amount_Due) AS N_Amount_Due,
			SUM(N_Tax_Value) AS N_Tax_Value,
			SUM(N_Amount_Paid) AS N_Amount_Paid,
			SUM(N_Tax_Paid) AS N_Tax_Paid
	   FROM #TmpBCRpt3
   GROUP BY InstanceChain,
			CenterCode,
			CenterName,
			S_Currency_Code,
			S_CourseFamily_Name,
			S_Course_Code,
			S_Course_Name
   ORDER BY InstanceChain,CenterName,S_CourseFamily_Name,S_Course_Name

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
