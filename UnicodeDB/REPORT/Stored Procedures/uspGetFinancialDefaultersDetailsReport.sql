CREATE PROCEDURE [REPORT].[uspGetFinancialDefaultersDetailsReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtUptoDate datetime
)
AS
BEGIN TRY

		DECLARE @dtUptoDate1 DATETIME
		SET @dtUptoDate1 = DATEADD(d,1,@dtUptoDate)


		 SELECT IP.I_Invoice_Header_ID,
				IP.I_Centre_Id,
				IP.I_Student_Detail_ID,
				SD.S_Student_ID,
				SD.S_Title,
				SD.S_First_Name,
				SD.S_Middle_Name,
				SD.S_Last_Name,
				IP.S_Invoice_No AS Invoice_No,
				IP.Dt_Invoice_Date AS Invoice_Date,
				ISNULL(IP.N_Invoice_Amount,0.00) AS Invoice_Amount,
				ISNULL(IP.N_Tax_Amount,0.00) AS Tax_Amount,
				ISNULL(IP.N_Discount_Amount,0.00) AS N_Discount_Amount,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code,
				--SUM(ISNULL(RH.N_Receipt_Amount,0.00)) AS Receipt_Amount,
				(Select SUM(ISNULL(N_Receipt_Amount,0.00)) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)  AS Receipt_Amount,
				(ISNULL(IP.N_Invoice_Amount,0.00) 
				--- SUM(ISNULL(RH.N_Receipt_Amount,0.00))) AS Outstanding_Amt,
				-(Select ISNULL(SUM(ISNULL(N_Receipt_Amount,0.00)),0) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)) AS Outstanding_Amt,
				--MAX(RH.Dt_Receipt_Date) AS Last_Install_Date
				(Select MAX(Dt_Receipt_Date) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)  AS Last_Install_Date
		   INTO #TmpOutStandingRpt1
		   FROM ACADEMICS.T_Dropout_Details DD
				INNER JOIN dbo.T_Student_Detail SD
				ON DD.I_Student_Detail_ID = SD.I_Student_Detail_ID
				INNER JOIN dbo.T_Invoice_Parent IP
			    ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON IP.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				LEFT OUTER JOIN dbo.T_Receipt_Header RH
				ON IP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
				INNER JOIN dbo.T_Centre_Master CEM
				ON FN1.CenterID=CEM.I_Centre_Id
				INNER JOIN dbo.T_Country_Master COM
				ON CEM.I_Country_ID=COM.I_Country_ID
				INNER JOIN dbo.T_Currency_Master CUM
				ON COM.I_Currency_ID=CUM.I_Currency_ID
		  WHERE IP.Dt_Invoice_Date <= @dtUptoDate
			AND (RH.Dt_Receipt_Date <= @dtUptoDate OR RH.Dt_Receipt_Date IS NULL)
			AND SD.I_Status = 0
			AND DD.I_Dropout_Status = 1
			AND DD.I_Dropout_Type_ID = 2
			AND DD.Dt_Dropout_Date <= @dtUptoDate1
			AND	[SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)

	   GROUP BY IP.I_Invoice_Header_ID,
				IP.I_Centre_Id,
				IP.I_Student_Detail_ID,
				SD.S_Student_ID,
				SD.S_Title,
				SD.S_First_Name,
				SD.S_Middle_Name,
				SD.S_Last_Name,
				IP.S_Invoice_No,
				IP.Dt_Invoice_Date,
				IP.N_Invoice_Amount,
				IP.N_Tax_Amount,
				IP.N_Discount_Amount,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code
				
--select * from #TmpOutStandingRpt1

		 SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--ICH.I_Course_ID,
				ICH.I_Invoice_Child_Header_ID,
				--CM.S_Course_Code AS Course_Code,
				--CM.S_Course_Name AS Course_Name,
				--SUM(ISNULL(RH.N_Receipt_Amount,0.00)) AS Last_Install_Amount,
				(Select SUM(ISNULL(N_Receipt_Amount,0.00)) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=TMP.I_Invoice_Header_ID AND I_Status <> 0 AND Dt_Receipt_Date=TMP.Last_Install_Date)  AS Last_Install_Amount,

				[REPORT].[fnGetStudentStatusForDefaulterReports](TMP.I_Student_Detail_ID,TMP.I_Centre_Id,@dtUptoDate1) AS Student_Status
		   INTO #TmpOutStandingRpt2
		   FROM #TmpOutStandingRpt1 TMP
				INNER JOIN dbo.T_Invoice_Child_Header ICH
				ON TMP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
				--INNER JOIN dbo.T_Course_Master CM
				--ON ICH.I_Course_ID=CM.I_Course_ID		
				LEFT OUTER JOIN dbo.T_Receipt_Header RH
				ON TMP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
				AND TMP.Last_Install_Date=RH.Dt_Receipt_Date
		  WHERE [REPORT].[fnGetStudentStatusForDefaulterReports](TMP.I_Student_Detail_ID,TMP.I_Centre_Id,@dtUptoDate1) LIKE '%FINANCIAL%'
		    --AND TMP.Outstanding_Amt > 10
--		    AND RH.I_Status <> 0
	   GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--ICH.I_Course_ID,
				ICH.I_Invoice_Child_Header_ID--,
				--CM.S_Course_Code,
				--CM.S_Course_Name
				
		--Finding Last Date of the Month
		DECLARE @vOutputDate DATETIME
		SET @vOutputDate = CAST(YEAR(@dtUptoDate) AS VARCHAR(4)) + '/' + CAST(MONTH(@dtUptoDate) AS VARCHAR(2)) + '/01'
		SET @vOutputDate = DATEADD(DD, -1, DATEADD(M, 1, @vOutputDate))


		SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status,
				SUM(ISNULL(ICD.N_Amount_Due,0.00)) AS Amount_Due_LM
		INTO #TmpOutStandingRpt3
		FROM #TmpOutStandingRpt2 TMP
				INNER JOIN dbo.T_Invoice_Child_Detail ICD
				ON TMP.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
				--AND DATEPART(month,ICD.Dt_Installment_Date) <= DATEPART(month, @dtUptoDate)
				--AND DATEPART(year,ICD.Dt_Installment_Date) <= DATEPART(year, @dtUptoDate)
				AND ICD.Dt_Installment_Date <=  @vOutputDate
		GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status
				
		--Finding Last Date of the Next Month
		SET @dtUptoDate=DATEADD(month,1,@dtUptoDate)
		DECLARE @vOutputDate1 DATETIME
		SET @vOutputDate1 = CAST(YEAR(@dtUptoDate) AS VARCHAR(4)) + '/' + CAST(MONTH(@dtUptoDate) AS VARCHAR(2)) + '/01'
		SET @vOutputDate1= DATEADD(DD, -1, DATEADD(M, 1, @vOutputDate1))


	SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status,
				SUM(ISNULL(ICD.N_Amount_Due,0.00)) AS Amount_Due_CM
		INTO #TmpOutStandingRpt4
		FROM #TmpOutStandingRpt2 TMP
				INNER JOIN dbo.T_Invoice_Child_Detail ICD
				ON TMP.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
				--AND DATEPART(month,ICD.Dt_Installment_Date) <= DATEPART(month, (DATEADD(month,1,@dtUptoDate)))
				--AND DATEPART(year,ICD.Dt_Installment_Date) <= DATEPART(year, @dtUptoDate)
				AND ICD.Dt_Installment_Date <= @vOutputDate1
		GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status

	SELECT TMP1.I_Invoice_Header_ID,
				TMP1.I_Centre_Id,
				TMP1.I_Student_Detail_ID,
				TMP1.S_Student_ID,
				TMP1.S_Title,
				TMP1.S_First_Name,
				TMP1.S_Middle_Name,
				TMP1.S_Last_Name,
				TMP1.Invoice_No,
				TMP1.Invoice_Date,
				TMP1.Invoice_Amount,
				TMP1.Tax_Amount,
				TMP1.N_Discount_Amount,
				TMP1.CenterCode,
				TMP1.CenterName,
				TMP1.InstanceChain,
				TMP1.S_Currency_Code,
				TMP1.Receipt_Amount,
				FLOOR(TMP1.Outstanding_Amt) Outstanding_Amt,
				TMP1.Last_Install_Date,
				CM.I_Course_ID,
				CM.S_Course_Code AS Course_Code,
				CM.S_Course_Name AS Course_Name,
				TMP1.Last_Install_Amount,
				TMP1.Student_Status,
				TMP1.Amount_Due_LM,
				TMP2.Amount_Due_CM,
				tsbm.S_Batch_Name
		FROM #TmpOutStandingRpt3 TMP1
				INNER JOIN #TmpOutStandingRpt4 TMP2
				ON TMP1.I_Invoice_Header_ID = TMP2.I_Invoice_Header_ID
				AND TMP1.I_Centre_Id = TMP2.I_Centre_Id
				AND TMP1.I_Student_Detail_ID = TMP2.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Student_ID = TMP1.I_Student_Detail_ID
				INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID			
				INNER JOIN dbo.T_COURSE_MASTER CM ON CM.I_Course_ID = tsbm.I_Course_ID
				INNER JOIN dbo.T_INVOICE_CHILD_HEADER ICH ON ICH.I_Course_ID = tsbm.I_Course_ID
				INNER JOIN dbo.T_INVOICE_PARENT IP ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
				AND IP.I_Invoice_Header_ID=TMP2.I_Invoice_Header_ID
		GROUP BY TMP1.I_Invoice_Header_ID,
				TMP1.I_Centre_Id,
				TMP1.I_Student_Detail_ID,
				TMP1.S_Student_ID,
				TMP1.S_Title,
				TMP1.S_First_Name,
				TMP1.S_Middle_Name,
				TMP1.S_Last_Name,
				TMP1.Invoice_No,
				TMP1.Invoice_Date,
				TMP1.Invoice_Amount,
				TMP1.Tax_Amount,
				TMP1.N_Discount_Amount,
				TMP1.CenterCode,
				TMP1.CenterName,
				TMP1.InstanceChain,
				TMP1.S_Currency_Code,
				TMP1.Receipt_Amount,
				TMP1.Outstanding_Amt,
				TMP1.Last_Install_Date,
				CM.I_Course_ID,
				CM.S_Course_Code,
				CM.S_Course_Name,
				TMP1.Last_Install_Amount,
				TMP1.Student_Status,
				TMP1.Amount_Due_LM,
				TMP2.Amount_Due_CM,
				tsbm.S_Batch_Name

	 DROP TABLE #TmpOutStandingRpt1
	 DROP TABLE #TmpOutStandingRpt2
	 DROP TABLE #TmpOutStandingRpt3
	 DROP TABLE #TmpOutStandingRpt4
	 
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
