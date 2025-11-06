CREATE PROCEDURE [REPORT].[uspGetCorporateEABCReport]
(
	@sHierarchyID VARCHAR(Max),
	@iBrandID VARCHAR(20),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@sCourseIDs VARCHAR(MAX)=NULL
)
AS
	BEGIN
		DECLARE @tblCenter TABLE(CenterId INT)		
		DECLARE @tblCourse TABLE(CourseID INT)

		IF ((SELECT COUNT([CenterId]) FROM @tblCenter) = 0)
		BEGIN
			INSERT INTO @tblCenter
			SELECT [I_Center_ID] FROM [dbo].[fnGetCenterIDFromHierarchy](@sHierarchyID, CAST(@iBrandID AS INT)) AS FGCIFH
		END
		
		INSERT INTO @tblCourse
		SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCourseIDs, ',') AS FSR
		
		IF ((SELECT COUNT([CourseID]) FROM @tblCourse) = 0)
		BEGIN
			INSERT INTO @tblCourse
			SELECT I_Course_ID FROM [dbo].T_Course_Master AS FGCIFH
		END

			SELECT DISTINCT
			TCD.I_Corporate_ID,
			CP.I_Corporate_Plan_ID,
			TCD.S_Corporate_Name,
			cp.S_Corporate_Plan_Name,
			cfm.S_CourseFamily_Name,
			CM.S_Course_Code,
			CM.S_Course_Name,
			SBM.S_Batch_Code,
			SBM.S_Batch_Name,
			CFP.S_Fee_Plan_Name,
			SD.S_Student_ID,
			ISNULL(SD.S_First_Name,'') + ' ' + ISNULL(SD.S_Middle_Name,'') + ' ' + ISNULL(SD.S_Last_Name,'') StudentName,
			ISNULL(InvoiceAmount,0) InvStudentPart,
			ISNULL(ExcessInvAmt,0) InvCorpPart,
			ISNULL(ExcessCorAmt,0) ExcessCorInvAmt,
			ISNULL(COLL,0) CollectionAmt, 
			ISNULL(TaxAmt,0) CollectionTax,
			ISNULL(COLL,0)+ISNULL(TaxAmt,0) CollStudentPart,
			ISNULL(ExcessRecAmt,0) CollCorpPart,
			ISNULL(ExcessCorRecAmt,0) ExcessCorpCollAmt
			FROM CORPORATE.T_Corporate_Details TCD
			INNER JOIN CORPORATE.T_Corporate_Plan CP ON TCD.I_Corporate_ID = CP.I_Corporate_ID
			INNER JOIN CORPORATE.T_Corporate_Plan_Batch_Map CPBM ON cp.I_Corporate_Plan_ID = CPBM.I_Corporate_Plan_ID
			INNER JOIN CORPORATE.T_Corporate_Invoice CI ON CP.I_Corporate_Plan_ID=CI.I_Corporate_Plan_ID
			INNER JOIN dbo.T_Student_Batch_Master SBM ON CPBM.I_Batch_ID=SBM.I_Batch_ID 
			INNER JOIN DBO.T_Student_Batch_Details SBD ON SBM.I_Batch_ID = SBD.I_Batch_ID
			INNER JOIN DBO.T_Center_Batch_Details CBD ON SBM.I_Batch_ID=CBD.I_Batch_ID
			INNER JOIN @tblCenter CN ON CBD.I_Centre_Id=CN.CenterId
			INNER JOIN CORPORATE.T_CorporatePlan_FeePlan_Map CPF ON CP.I_Corporate_Plan_ID=CPF.I_Corporate_Plan_ID
			INNER JOIN DBO.T_Course_Fee_Plan CFP ON CPF.I_Course_Fee_Plan_ID=CFP.I_Course_Fee_Plan_ID
			INNER JOIN DBO.T_Course_Master CM ON SBM.I_Course_ID=CM.I_Course_ID
			INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
			INNER JOIN DBO.T_Student_Detail SD ON SBD.I_Student_ID = SD.I_Student_Detail_ID
			LEFT JOIN
			(
			SELECT ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID, (SUM(ISNULL(ICH.N_Amount,0)) + SUM(ISNULL(ich.N_Tax_Amount,0))) InvoiceAmount
			FROM dbo.T_Invoice_Parent IP
			INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
			INNER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map CISIM ON IP.I_Invoice_Header_ID=CISIM.I_Invoice_Header_ID
			INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			INNER JOIN DBO.T_Student_Batch_Master SBM ON IBM.I_Batch_ID = SBM.I_Batch_ID AND SBM.b_IsCorporateBatch=1
			WHERE DATEDIFF(DD,@dtStartDate,IP.Dt_Invoice_Date)>=0
			AND DATEDIFF(DD,@dtEndDate,IP.Dt_Invoice_Date)<=0
			AND ICH.I_Course_ID in (SELECT CourseID FROM @tblCourse)
			GROUP BY ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID			
			)
			AS INVAMT ON SBM.I_Course_ID=INVAMT.I_Course_ID
			AND SBD.I_Batch_ID=INVAMT.I_Batch_ID
			AND SD.I_Student_Detail_ID=INVAMT.I_Student_Detail_ID
			LEFT JOIN
			(
			SELECT ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID,SUM(rcd.N_Amount_Paid) COLL
			FROM dbo.T_Receipt_Component_Detail rcd
			INNER JOIN DBO.T_Receipt_Header RH ON rcd.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
			INNER JOIN CORPORATE.T_CorporateReceipt_StudentReceipt_Map CRSRM ON RH.I_Receipt_Header_ID = CRSRM.I_Receipt_Header_ID  
			INNER JOIN dbo.T_Invoice_Child_Detail ICD ON rcd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			INNER JOIN dbo.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
			INNER JOIN dbo.T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
			INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			INNER JOIN DBO.T_Student_Batch_Master SBM ON IBM.I_Batch_ID = SBM.I_Batch_ID AND SBM.b_IsCorporateBatch=1
			WHERE DATEDIFF(DD,@dtStartDate,RH.Dt_Receipt_Date)>=0
			AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date)<=0
			AND ICH.I_Course_ID in (SELECT CourseID FROM @tblCourse)
			GROUP BY ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID
			)
			AS COLLAMT ON SBM.I_Course_ID=COLLAMT.I_Course_ID
			AND SBD.I_Batch_ID=COLLAMT.I_Batch_ID
			AND SD.I_Student_Detail_ID=COLLAMT.I_Student_Detail_ID
			LEFT JOIN
			(
			SELECT ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID,SUM(rtd.N_Tax_Paid) TaxAmt
			FROM T_Receipt_Tax_Detail RTD
			INNER JOIN dbo.T_Receipt_Component_Detail rcd ON RTD.I_Receipt_Comp_Detail_ID = rcd.I_Receipt_Comp_Detail_ID
			INNER JOIN DBO.T_Receipt_Header RH ON rcd.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
			INNER JOIN CORPORATE.T_CorporateReceipt_StudentReceipt_Map CRSRM ON RH.I_Receipt_Header_ID = CRSRM.I_Receipt_Header_ID  
			INNER JOIN dbo.T_Invoice_Child_Detail ICD ON rcd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			INNER JOIN dbo.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
			INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			INNER JOIN DBO.T_Student_Batch_Master SBM ON IBM.I_Batch_ID = SBM.I_Batch_ID AND SBM.b_IsCorporateBatch=1
			INNER JOIN DBO.T_Invoice_Parent IP ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
			WHERE DATEDIFF(DD,@dtStartDate,RH.Dt_Receipt_Date)>=0
			AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date)<=0
			AND ICH.I_Course_ID in (SELECT CourseID FROM @tblCourse)
			GROUP BY ICH.I_Course_ID,IBM.I_Batch_ID,IP.I_Student_Detail_ID
			)
			AS TAX ON SBM.I_Course_ID=TAX.I_Course_ID
			AND SBD.I_Batch_ID=TAX.I_Batch_ID
			AND SD.I_Student_Detail_ID=TAX.I_Student_Detail_ID
			LEFT JOIN
			(
			SELECT CI.I_Corporate_Plan_ID, SUM(ISNULL(CI.N_Excess_Amt,0)) ExcessInvAmt
			FROM CORPORATE.T_Corporate_Invoice CI
			WHERE DATEDIFF(DD,@dtStartDate,CI.Dt_Crtd_On)>=0
			AND DATEDIFF(DD,@dtEndDate,CI.Dt_Crtd_On)<=0		
			GROUP BY CI.I_Corporate_Plan_ID
			)
			AS EXCESS ON CP.I_Corporate_Plan_ID=EXCESS.I_Corporate_Plan_ID
			LEFT JOIN	
			(
			SELECT CP.I_Corporate_ID, SUM(ISNULL(CI.N_Excess_Amt,0)) ExcessCorAmt
			FROM CORPORATE.T_Corporate_Invoice CI
			INNER JOIN CORPORATE.T_Corporate_Plan CP ON CI.I_Corporate_Plan_ID = CP.I_Corporate_Plan_ID
			WHERE DATEDIFF(DD,@dtStartDate,CI.Dt_Crtd_On)>=0
			AND DATEDIFF(DD,@dtEndDate,CI.Dt_Crtd_On)<=0		
			GROUP BY CP.I_Corporate_ID		
			)
			AS Cor	on TCD.I_Corporate_ID=Cor.I_Corporate_ID
			LEFT JOIN
			(
			SELECT CI.I_Corporate_Plan_ID,SUM(ISNULL(RH.N_Receipt_Amount,0)) ExcessRecAmt
			FROM CORPORATE.T_Corporate_Invoice_Receipt_Map CIRM
			INNER JOIN CORPORATE.T_Corporate_Invoice CI ON CIRM.I_Corporate_Invoice_Id = CI.I_Corporate_Invoice_Id
			INNER JOIN DBO.T_Receipt_Header RH ON CIRM.I_Receipt_Header_ID=RH.I_Receipt_Header_ID
			WHERE DATEDIFF(DD,@dtStartDate,RH.Dt_Receipt_Date)>=0
			AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date)<=0		
			GROUP BY CI.I_Corporate_Plan_ID
			)
			AS ExssRec ON CP.I_Corporate_Plan_ID=ExssRec.I_Corporate_Plan_ID
			LEFT JOIN
			(
			SELECT CP.I_Corporate_ID,SUM(ISNULL(RH.N_Receipt_Amount,0)) ExcessCorRecAmt
			FROM CORPORATE.T_Corporate_Invoice_Receipt_Map CIRM
			INNER JOIN CORPORATE.T_Corporate_Invoice CI ON CIRM.I_Corporate_Invoice_Id = CI.I_Corporate_Invoice_Id
			INNER JOIN DBO.T_Receipt_Header RH ON CIRM.I_Receipt_Header_ID=RH.I_Receipt_Header_ID
			INNER JOIN CORPORATE.T_Corporate_Plan CP ON CI.I_Corporate_Plan_ID = CP.I_Corporate_Plan_ID	
			WHERE DATEDIFF(DD,@dtStartDate,RH.Dt_Receipt_Date)>=0
			AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date)<=0		
			GROUP BY CP.I_Corporate_ID
			)
			AS CorColl on TCD.I_Corporate_ID=CorColl.I_Corporate_ID
			WHERE DATEDIFF(DD,@dtStartDate,CI.Dt_Crtd_On)>=0
			AND DATEDIFF(DD,@dtEndDate,CI.Dt_Crtd_On)<=0
			AND SBM.I_Course_ID in (SELECT CourseID FROM @tblCourse)
	END
	
	
	

--EXEC REPORT.uspGetCorporateEABCReport 1,2,'2011-10-01','2011-11-02',NULL

--DROP PROCEDURE dbo.uspGetCorporateEABCReport

			--SELECT DISTINCT
			--TCD.S_Corporate_Name,
			--cp.S_Corporate_Plan_Name,
			--cfm.S_CourseFamily_Name,
			--CM.S_Course_Code,
			--CM.S_Course_Name,
			--SBM.S_Batch_Code,
			--SBM.S_Batch_Name,
			--CFP.S_Fee_Plan_Name,
			--SD.S_Student_ID,
			--ISNULL(SD.S_First_Name,'') + ' ' + ISNULL(SD.S_Middle_Name,'') + ' ' + ISNULL(SD.S_Last_Name,'') StudentName,
			--IP.S_Invoice_No,
			--IP.Dt_Invoice_Date,
			--ISNULL(ICH.N_Amount,0) InvoiceAmount,
			--ISNULL(ICH.N_Tax_Amount,0) InvoiceTax,
			--ISNULL(ICH.N_Amount,0)+ISNULL(ICH.N_Tax_Amount,0) InvStudentPart,
			--0 InvCorpPart,
			--ISNULL(COLL,0) CollectionAmt, 
			--ISNULL(TaxAmt,0) CollectionTax,
			--ISNULL(COLL,0)+ISNULL(TaxAmt,0) CollStudentPart,
			--0 CollCorpPart
			--FROM CORPORATE.T_Corporate_Details TCD
			--INNER JOIN CORPORATE.T_Corporate_Plan CP ON TCD.I_Corporate_ID = CP.I_Corporate_ID
			--INNER JOIN CORPORATE.T_Corporate_Plan_Batch_Map CPBM ON cp.I_Corporate_Plan_ID = CPBM.I_Corporate_Plan_ID
			--INNER JOIN CORPORATE.T_Corporate_Invoice CI ON CP.I_Corporate_Plan_ID=CI.I_Corporate_Plan_ID
			--INNER JOIN dbo.T_Student_Batch_Master SBM ON CPBM.I_Batch_ID=SBM.I_Batch_ID 
			--INNER JOIN DBO.T_Course_Fee_Plan CFP ON SBM.I_Course_ID = CFP.I_Course_ID
			--INNER JOIN DBO.T_Course_Master CM ON SBM.I_Course_ID=CM.I_Course_ID
			--INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
			--INNER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map CISI ON CI.I_Corporate_Invoice_Id=CISI.I_Corporate_Invoice_Id
			--INNER JOIN DBO.T_Invoice_Parent IP ON CISI.I_Invoice_Header_ID=IP.I_Invoice_Header_ID
			--INNER JOIN @tblCenter CN ON IP.I_Centre_Id=CN.CenterId
			--INNER JOIN DBO.T_Student_Detail SD ON IP.I_Student_Detail_ID = SD.I_Student_Detail_ID
			--INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
			--AND SBM.I_Course_ID=ICH.I_Course_ID
			--INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			--AND CPBM.I_Batch_ID=ibm.I_Batch_ID
			--LEFT JOIN
			--(
			--SELECT ICH.I_Course_ID,IBM.I_Batch_ID,ICH.I_Invoice_Child_Header_ID,SUM(rcd.N_Amount_Paid) COLL
			--FROM dbo.T_Receipt_Component_Detail rcd 
			--INNER JOIN dbo.T_Invoice_Child_Detail ICD ON rcd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			--INNER JOIN dbo.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
			--INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			--GROUP BY ICH.I_Course_ID,IBM.I_Batch_ID,ICH.I_Invoice_Child_Header_ID
			--)
			--AS COLLAMT ON ICH.I_Invoice_Child_Header_ID=COLLAMT.I_Invoice_Child_Header_ID
			--AND IBM.I_Batch_ID=COLLAMT.I_Batch_ID
			--AND ICH.I_Course_ID=COLLAMT.I_Course_ID
			--LEFT JOIN
			--(
			--SELECT ICH.I_Course_ID,IBM.I_Batch_ID,ICH.I_Invoice_Child_Header_ID,SUM(rtd.N_Tax_Paid) TaxAmt
			--FROM T_Receipt_Tax_Detail RTD
			--INNER JOIN dbo.T_Receipt_Component_Detail rcd ON RTD.I_Receipt_Comp_Detail_ID = rcd.I_Receipt_Comp_Detail_ID
			--INNER JOIN dbo.T_Invoice_Child_Detail ICD ON rcd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			--INNER JOIN dbo.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
			--INNER JOIN dbo.T_Invoice_Batch_Map IBM ON ICH.I_Invoice_Child_Header_ID = IBM.I_Invoice_Child_Header_ID
			--GROUP BY ICH.I_Course_ID,IBM.I_Batch_ID,ICH.I_Invoice_Child_Header_ID
			--)
			--AS TAX ON ich.I_Invoice_Child_Header_ID=tax.I_Invoice_Child_Header_ID
			--AND IBM.I_Batch_ID=TAX.I_Batch_ID
			--AND ICH.I_Course_ID=TAX.I_Course_ID
			--WHERE DATEDIFF(DD,@dtStartDate,CI.Dt_Crtd_On)>=0
			--AND DATEDIFF(DD,@dtEndDate,CI.Dt_Crtd_On)<=0
			--AND SBM.I_Course_ID in (SELECT CourseID FROM @tblCourse)
