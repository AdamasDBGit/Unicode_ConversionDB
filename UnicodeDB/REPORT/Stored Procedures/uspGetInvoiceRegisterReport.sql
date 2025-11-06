CREATE PROCEDURE [REPORT].[uspGetInvoiceRegisterReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@sCounselorCond varchar(20)
)
AS
BEGIN TRY
	
--	IF (@dtEndDate IS NOT NULL)
--	BEGIN
--		SET @dtEndDate = DATEADD(dd,1,@dtEndDate)
--	END
	
	DECLARE @InvoiceDetail TABLE
	(
		I_Invoice_Header_ID INT,
		S_Student_ID VARCHAR(500),
		S_Title VARCHAR(10),
		S_First_Name VARCHAR(50),
		S_Middle_Name VARCHAR(50),
		S_Last_Name VARCHAR(50),
		I_Status INT,
		S_Invoice_No VARCHAR(50),
		Dt_Invoice_Date DATETIME,
		Invoice_Amount NUMERIC(18,2),
		Tax_Amount NUMERIC(18,2),
		N_Discount_Amount NUMERIC(18,2),
		Invoice_Status VARCHAR(20),
		S_Discount_Scheme_Name VARCHAR(250),
		Coun_Title VARCHAR(10),
		Coun_First_Name VARCHAR(50),
		Coun_Middle_Name VARCHAR(50),
		Coun_Last_Name VARCHAR(50),
		CenterCode VARCHAR(50),
		CenterName VARCHAR(50),
		InstanceChain VARCHAR(200),
		S_Currency_Code VARCHAR(50),
		S_Form_Sold_By VARCHAR(300),
		S_Batch_Name VARCHAR(100)
	)
	
	IF @sCounselorCond ='ALL'
	BEGIN		 
		INSERT INTO @InvoiceDetail
		 SELECT B.I_Invoice_Header_ID,
				A.S_Student_ID,
				A.S_Title,
				A.S_First_Name,
				A.S_Middle_Name,
				A.S_Last_Name,
				A.I_Status,
				B.S_Invoice_No,
				B.Dt_Invoice_Date,
				ISNULL(B.N_Invoice_Amount,0.00) AS Invoice_Amount,
				ISNULL(B.N_Tax_Amount,0.00) AS Tax_Amount,
				ISNULL(B.N_Discount_Amount,0.00) AS N_Discount_Amount,
				'Active',
				C.S_Discount_Scheme_Name,
				D.S_Title AS Coun_Title,
				D.S_First_Name AS Coun_First_Name,
				D.S_Middle_Name AS Coun_Middle_Name,
				D.S_Last_Name AS Coun_Last_Name,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code,
				TUM.S_First_Name + ISNULL(TUM.S_Middle_Name,'') + ISNULL(TUM.S_Last_Name,'') AS FormSoldBy,
				TSBM.S_Batch_Name
		   FROM dbo.T_Student_Detail A
				INNER JOIN dbo.T_Invoice_Parent B
			    ON A.I_Student_Detail_ID = B.I_Student_Detail_ID

				Inner JOIN dbo.T_Student_Batch_Details TSBD 
				ON B.I_Student_Detail_ID=TSBD.I_Student_ID
				Inner JOIN dbo.T_Student_Batch_Master TSBM 
				ON TSBD.I_Batch_ID=TSBM.I_Batch_ID

			    LEFT OUTER JOIN dbo.T_Discount_Scheme_Master C
			    ON B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
				LEFT OUTER JOIN dbo.T_User_Master D
				ON B.S_Crtd_By=D.S_Login_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON B.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				INNER JOIN dbo.T_Centre_Master CEM
				ON FN1.CenterID=CEM.I_Centre_Id
				INNER JOIN dbo.T_Country_Master COM
				ON CEM.I_Country_ID=COM.I_Country_ID
				INNER JOIN dbo.T_Currency_Master CUM
				ON COM.I_Currency_ID=CUM.I_Currency_ID
				INNER JOIN T_Enquiry_Regn_Detail TERD
				ON TERD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
				LEFT OUTER JOIN T_Receipt_Header TRH
				ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
				and I_Receipt_Type IN (31,32,50,51,	57)
				LEFT OUTER JOIN T_User_Master TUM
				ON TUM.S_Login_ID = TRH.S_Crtd_By
			WHERE DATEDIFF(dd,B.Dt_Invoice_Date,@dtStartDate) <= 0 AND DATEDIFF(dd,B.Dt_Invoice_Date,@dtEndDate) >= 0 
			and TRH.I_Status=1 --succesfully executed receipt(by susmita) 
			--WHERE CAST(SUBSTRING(CAST(B.Dt_Invoice_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
			--and B.I_status=1
		 -- WHERE B.Dt_Invoice_Date BETWEEN @dtStartDate AND @dtEndDate

	UNION ALL

		 SELECT B.I_Invoice_Header_ID,
				A.S_Student_ID,
				A.S_Title,
				A.S_First_Name,
				A.S_Middle_Name,
				A.S_Last_Name,
				A.I_Status,
				B.S_Invoice_No,
				ISNULL(B.Dt_Upd_On,B.Dt_Invoice_Date),
				ISNULL(B.N_Invoice_Amount,0.00) AS Invoice_Amount,
				ISNULL(B.N_Tax_Amount,0.00) AS Tax_Amount,
				ISNULL(B.N_Discount_Amount,0.00) AS N_Discount_Amount,
				'Cancelled',
				C.S_Discount_Scheme_Name,
				D.S_Title AS Coun_Title,
				D.S_First_Name AS Coun_First_Name,
				D.S_Middle_Name AS Coun_Middle_Name,
				D.S_Last_Name AS Coun_Last_Name,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code,
				TUM.S_First_Name + ISNULL(TUM.S_Middle_Name,'') + ISNULL(TUM.S_Last_Name,'') AS FormSoldBy,
				TSBM.S_Batch_Name
		   FROM dbo.T_Student_Detail A
				INNER JOIN dbo.T_Invoice_Parent B
			    ON A.I_Student_Detail_ID = B.I_Student_Detail_ID

				Inner JOIN dbo.T_Student_Batch_Details TSBD 
				ON B.I_Student_Detail_ID=TSBD.I_Student_ID
				Inner JOIN dbo.T_Student_Batch_Master TSBM 
				ON TSBD.I_Batch_ID=TSBM.I_Batch_ID

			    LEFT OUTER JOIN dbo.T_Discount_Scheme_Master C
			    ON B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
				LEFT OUTER JOIN dbo.T_User_Master D
				ON B.S_Crtd_By=D.S_Login_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON B.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				INNER JOIN dbo.T_Centre_Master CEM
				ON FN1.CenterID=CEM.I_Centre_Id
				INNER JOIN dbo.T_Country_Master COM
				ON CEM.I_Country_ID=COM.I_Country_ID
				INNER JOIN dbo.T_Currency_Master CUM
				ON COM.I_Currency_ID=CUM.I_Currency_ID
				INNER JOIN T_Enquiry_Regn_Detail TERD
				ON TERD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
				LEFT OUTER JOIN T_Receipt_Header TRH
				ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
				and I_Receipt_Type IN (31,32,50,51,	57)
				LEFT OUTER JOIN T_User_Master TUM
				ON TUM.S_Login_ID = TRH.S_Crtd_By
			WHERE DATEDIFF(dd,B.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(dd,B.Dt_Upd_On,@dtEndDate) >= 0
			and TRH.I_Status=1 --succesfully executed receipt(by susmita) 
			--CAST(SUBSTRING(CAST(B.Dt_Upd_On AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
			--AND CAST(SUBSTRING(CAST(B.Dt_Invoice_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
			--and B.I_status=0
		  --WHERE B.Dt_Upd_On BETWEEN @dtStartDate AND @dtEndDate


	
	END
	ELSE
	BEGIN

		INSERT INTO @InvoiceDetail
		 SELECT B.I_Invoice_Header_ID,
				A.S_Student_ID,
				A.S_Title,
				A.S_First_Name,
				A.S_Middle_Name,
				A.S_Last_Name,
				A.I_Status,
				B.S_Invoice_No,
				B.Dt_Invoice_Date,
				ISNULL(B.N_Invoice_Amount,0.00) AS Invoice_Amount,
				ISNULL(B.N_Tax_Amount,0.00) AS Tax_Amount,
				ISNULL(B.N_Discount_Amount,0.00) AS N_Discount_Amount,
				'Active',
				C.S_Discount_Scheme_Name,
				D.S_Title AS Coun_Title,
				D.S_First_Name AS Coun_First_Name,
				D.S_Middle_Name AS Coun_Middle_Name,
				D.S_Last_Name AS Coun_Last_Name,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code,
				TUM.S_First_Name + ISNULL(TUM.S_Middle_Name,'') + ISNULL(TUM.S_Last_Name,'') AS FormSoldBy,
				TSBM.S_Batch_Name
		   FROM dbo.T_Student_Detail A
				INNER JOIN dbo.T_Invoice_Parent B
			    ON A.I_Student_Detail_ID = B.I_Student_Detail_ID

				Inner JOIN dbo.T_Student_Batch_Details TSBD 
				ON B.I_Student_Detail_ID=TSBD.I_Student_ID
				Inner JOIN dbo.T_Student_Batch_Master TSBM 
				ON TSBD.I_Batch_ID=TSBM.I_Batch_ID

			    LEFT OUTER JOIN dbo.T_Discount_Scheme_Master C
			    ON B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
				LEFT OUTER JOIN dbo.T_User_Master D
				ON B.S_Crtd_By=D.S_Login_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON B.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				INNER JOIN dbo.T_Centre_Master CEM
				ON FN1.CenterID=CEM.I_Centre_Id
				INNER JOIN dbo.T_Country_Master COM
				ON CEM.I_Country_ID=COM.I_Country_ID
				INNER JOIN dbo.T_Currency_Master CUM
				ON COM.I_Currency_ID=CUM.I_Currency_ID
				INNER JOIN T_Enquiry_Regn_Detail TERD
				ON TERD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
				LEFT OUTER JOIN T_Receipt_Header TRH
				ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
				and I_Receipt_Type IN (31,32,50,51,	57)
				LEFT OUTER JOIN T_User_Master TUM
				ON TUM.S_Login_ID = TRH.S_Crtd_By
			WHERE DATEDIFF(dd,B.Dt_Invoice_Date,@dtStartDate) <= 0 AND DATEDIFF(dd,B.Dt_Invoice_Date,@dtEndDate) >= 0
			and TRH.I_Status=1 --succesfully executed receipt(by susmita) 
			--CAST(SUBSTRING(CAST(B.Dt_Invoice_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
		  --WHERE B.Dt_Invoice_Date BETWEEN @dtStartDate AND @dtEndDate
			AND	TRH.S_Crtd_By=@sCounselorCond
			--and B.I_status=1
	UNION ALL

		 SELECT B.I_Invoice_Header_ID,
				A.S_Student_ID,
				A.S_Title,
				A.S_First_Name,
				A.S_Middle_Name,
				A.S_Last_Name,
				A.I_Status,
				B.S_Invoice_No,
				ISNULL(B.Dt_Upd_On,B.Dt_Invoice_Date),
				ISNULL(B.N_Invoice_Amount,0.00) AS Invoice_Amount,
				ISNULL(B.N_Tax_Amount,0.00) AS Tax_Amount,
				ISNULL(B.N_Discount_Amount,0.00) AS N_Discount_Amount,
				'Cancelled',
				C.S_Discount_Scheme_Name,
				D.S_Title AS Coun_Title,
				D.S_First_Name AS Coun_First_Name,
				D.S_Middle_Name AS Coun_Middle_Name,
				D.S_Last_Name AS Coun_Last_Name,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				CUM.S_Currency_Code,
				TUM.S_First_Name + ISNULL(TUM.S_Middle_Name,'') + ISNULL(TUM.S_Last_Name,'') AS FormSoldBy,
				TSBM.S_Batch_Name
		   FROM dbo.T_Student_Detail A
				INNER JOIN dbo.T_Invoice_Parent B
			    ON A.I_Student_Detail_ID = B.I_Student_Detail_ID

				Inner JOIN dbo.T_Student_Batch_Details TSBD 
				ON B.I_Student_Detail_ID=TSBD.I_Student_ID
				Inner JOIN dbo.T_Student_Batch_Master TSBM 
				ON TSBD.I_Batch_ID=TSBM.I_Batch_ID

			    LEFT OUTER JOIN dbo.T_Discount_Scheme_Master C
			    ON B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
				LEFT OUTER JOIN dbo.T_User_Master D
				ON B.S_Crtd_By=D.S_Login_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON B.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				INNER JOIN dbo.T_Centre_Master CEM
				ON FN1.CenterID=CEM.I_Centre_Id
				INNER JOIN dbo.T_Country_Master COM
				ON CEM.I_Country_ID=COM.I_Country_ID
				INNER JOIN dbo.T_Currency_Master CUM
				ON COM.I_Currency_ID=CUM.I_Currency_ID
				INNER JOIN T_Enquiry_Regn_Detail TERD
				ON TERD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
				LEFT OUTER JOIN T_Receipt_Header TRH
				ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
				and I_Receipt_Type IN (31,32,50,51,	57)
				LEFT OUTER JOIN T_User_Master TUM
				ON TUM.S_Login_ID = TRH.S_Crtd_By
			WHERE DATEDIFF(dd,B.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(dd,B.Dt_Upd_On,@dtEndDate) >= 0
			and TRH.I_Status=1 --succesfully executed receipt(by susmita) 
			--CAST(SUBSTRING(CAST(B.Dt_Upd_On AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
			--AND CAST(SUBSTRING(CAST(B.Dt_Invoice_Date AS VARCHAR),1,11) as datetime) BETWEEN @dtStartDate AND @dtEndDate
			AND	TRH.S_Crtd_By=@sCounselorCond
--and B.I_status=0

	END

		 SELECT F.S_Student_ID,
				F.S_Title,
				F.S_First_Name,
				F.S_Middle_Name,
				F.S_Last_Name,
				F.I_Status,
				F.S_Invoice_No,
				F.Dt_Invoice_Date,
				F.Invoice_Amount,
				F.Tax_Amount,
				F.N_Discount_Amount,
				F.Invoice_Status,
				F.S_Discount_Scheme_Name,
				F.Coun_Title,
				F.Coun_First_Name,
				F.Coun_Middle_Name,
				F.Coun_Last_Name,
				F.CenterCode,
				F.CenterName,
				F.InstanceChain,
				F.S_Currency_Code,
				B.I_Invoice_Header_ID,
				D.S_Course_Code,
				D.S_Course_Name,
				E.S_Fee_Plan_Name,
				Course_Fee = 
						CASE 
							WHEN F.Invoice_Status =  'Active' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID = 21
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00)
							WHEN F.Invoice_Status =  'Cancelled' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID = 21
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00) 
						END,
				Exam_Fee =   
						CASE 
							WHEN F.Invoice_Status =  'Active' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID = 4
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00)
							WHEN F.Invoice_Status =  'Cancelled' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID = 4
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00) 
						END,
				Others_Fee = 
						CASE 
							WHEN F.Invoice_Status =  'Active' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID NOT IN (21,4)
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00)
							WHEN F.Invoice_Status =  'Cancelled' THEN 
								ISNULL((SElECT SUM(ISNULL(N_Amount_Due,0.00)) 
								FROM dbo.T_Invoice_Child_Detail AA
								WHERE I_Fee_Component_ID NOT IN (21,4)
								AND AA.I_Invoice_Child_Header_ID = A.I_Invoice_Child_Header_ID),0.00)
						END,
				Tax_Component=
						CASE
							WHEN F.Invoice_Status =  'Active' THEN 
								SUM(N_Tax_Value)
							WHEN F.Invoice_Status =  'Cancelled' THEN 
								SUM(N_Tax_Value)
						END,
				F.S_Form_Sold_By,
				F.S_Batch_Name
		   FROM dbo.T_Invoice_Child_Detail A
				INNER JOIN dbo.T_Invoice_Child_Header B
				ON A.I_Invoice_Child_Header_ID=B.I_Invoice_Child_Header_ID
				LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax C
				ON A.I_Invoice_Detail_ID=C.I_Invoice_Detail_ID
				INNER JOIN dbo.T_Course_Master D
				ON B.I_Course_ID=D.I_Course_ID
				INNER JOIN dbo.T_Course_Fee_Plan E
				ON B.I_Course_FeePlan_ID=E.I_Course_Fee_Plan_ID
				INNER JOIN @InvoiceDetail F
				ON B.I_Invoice_Header_ID=F.I_Invoice_Header_ID

	   GROUP BY B.I_Invoice_Header_ID, 
				A.I_Invoice_Child_Header_ID, 
				D.S_Course_Code,
				D.S_Course_Name,
				E.S_Fee_Plan_Name,
				F.I_Invoice_Header_ID,
				F.S_Student_ID,
				F.S_Title,
				F.S_First_Name,
				F.S_Middle_Name,
				F.S_Last_Name,
				F.I_Status,
				F.S_Invoice_No,
				F.Dt_Invoice_Date,
				F.Invoice_Amount,
				F.Tax_Amount,
				F.N_Discount_Amount,
				F.Invoice_Status,
				F.S_Discount_Scheme_Name,
				F.Coun_Title,
				F.Coun_First_Name,
				F.Coun_Middle_Name,
				F.Coun_Last_Name,
				F.CenterCode,
				F.CenterName,
				F.InstanceChain,
				F.S_Currency_Code,
				F.S_Form_Sold_By,
				F.S_Batch_Name
	   ORDER BY F.InstanceChain,
				F.CenterName,
				F.Coun_Title,
				F.Coun_First_Name,
				F.Coun_Middle_Name,
				F.Coun_Last_Name,
				F.S_Student_ID,
				F.S_Invoice_No

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
