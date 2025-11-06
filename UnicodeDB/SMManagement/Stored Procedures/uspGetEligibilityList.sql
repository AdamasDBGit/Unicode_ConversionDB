CREATE PROCEDURE [SMManagement].[uspGetEligibilityList]
    (
      @BrandID INT ,
      @HierarchyListID VARCHAR(MAX) ,
      @CourseID INT,
      @BatchID INT
    )
AS
    BEGIN

        DECLARE @dtUptoDate DATETIME= GETDATE()
		DECLARE @dtStartDate Datetime=DATEADD(m,-12,GETDATE())

		PRINT @dtStartDate
        
        CREATE TABLE #temp
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              I_Fee_Component_ID INT ,
              S_Component_Name VARCHAR(100) ,
			  I_Batch_ID INT,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX),
              S_Brand_Name VARCHAR(100) ,
              S_Cost_Center VARCHAR(100) ,
              Due_Value REAL ,
              Dt_Installment_Date DATETIME ,
              I_Installment_No INT ,
              I_Parent_Invoice_ID INT ,
              I_Invoice_Detail_ID INT ,
              Revised_Invoice_Date DATETIME ,
              Tax_Value DECIMAL(14, 2) ,
              Total_Value DECIMAL(14, 2) ,
              Amount_Paid DECIMAL(14, 2) ,
              Tax_Paid DECIMAL(14, 2) ,
              Total_Paid DECIMAL(14, 2) ,
              Total_Due DECIMAL(14, 2) ,
              IsGSTImplemented INT ,
              Age INT ,
              sInstance VARCHAR(MAX)
            )

		CREATE TABLE #temp1
		(
		S_Student_ID varchar(max),
		I_Student_Detail_ID int,
		I_Course_ID int,
		I_Installment_No int,
		PayableAmount Decimal(14,2),
		TotalDue Decimal(14,2)
		)

		insert into #temp1
		exec SMManagement.uspGetMonthlyCollectableReportSM @BrandID,@HierarchyListID,@dtStartDate,@dtUptoDate

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History_SM @sHierarchyList = @HierarchyListID, -- varchar(max)
                    @iBrandID = @BrandID, -- int
                    @dtUptoDate = @dtUptoDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
		
		
		--TABLE 0--
        SELECT  TSD.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                ISNULL(TBDTLS.I_RollNo,TSD.I_RollNo) AS RollNo,
                CASE WHEN ((ISNULL(TMCOL.TotalDue,0)*100)/ISNULL(TMCOL.PayableAmount,1)>(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100))) OR (ISNULL(TDUE.TotalDue,0)>0) THEN 1
				WHEN (ISNULL(TMCOL.TotalDue,0)*100)/ISNULL(TMCOL.PayableAmount,1)<=(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100)) THEN 0
				ELSE 0
				END AS HasDue,
                TSEP.EligibilityHeaderID ,
                TSEP.CenterDispatchSchemeID ,
                TSEP.CenterID ,
                TCHND.S_Center_Name,
                TSEP.CourseID ,
                TCM.S_Course_Name ,
                TSEP.BatchID ,
                TSBM.S_Batch_Name ,
                TSEP.StatusID ,
                TSEP.IsScheduled ,
                TSED.I_Delivery ,
                TSED.EligibilityDate,
                COUNT(TSED.EligibilityDetailID) AS BookCount
        FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
                INNER JOIN SMManagement.T_Student_Eligibity_Details AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                --inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSEP.CenterID --and TCBD.I_Centre_Id=TCHND.I_Center_ID
                LEFT JOIN
                (
    --            SELECT T1.S_Student_ID,SUM(T1.Total_Due) AS TotalDue--,SUM(T1.Total_Value) AS InitialDue 
				--FROM #temp AS T1 GROUP BY T1.S_Student_ID HAVING SUM(T1.Total_Due)>100
				select TX.S_Student_ID,ISNULL(SUM(TX.TotalDue),0) as TotalDue from
					(
						SELECT T1.S_Student_ID,T1.I_Installment_No,
						CASE WHEN T1.I_Installment_No=1 and (SUM(T1.Total_Due)*100)/SUM(T1.Total_Value)>(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100)) THEN SUM(T1.Total_Due)
						WHEN T1.I_Installment_No=1 and (SUM(T1.Total_Due)*100)/SUM(T1.Total_Value)<=(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100)) THEN 0
						ELSE SUM(T1.Total_Due) END AS TotalDue
						FROM #temp AS T1
						left join T_Center_Batch_Details TCBD on TCBD.I_Batch_ID=T1.I_Batch_ID
						WHERE T1.I_Installment_No>1
						GROUP BY T1.S_Student_ID,T1.I_Installment_No,ISNULL(TCBD.I_Minimum_Regn_Amt,100)
					) TX
					GROUP BY TX.S_Student_ID
					HAVING ISNULL(SUM(TX.TotalDue),0)>100
                ) TDUE ON TDUE.S_Student_ID COLLATE Latin1_General_CI_AI = TSD.S_Student_ID
				left join #temp1 TMCOL on TSD.I_Student_Detail_ID=TMCOL.I_Student_Detail_ID and TMCOL.I_Course_ID=@CourseID
				inner join T_Center_Batch_Details TCBD on TCBD.I_Batch_ID=TSBM.I_Batch_ID
                LEFT JOIN
                (
                SELECT DISTINCT TSBD.I_Student_ID,TSBD.I_Batch_ID,TSBD.I_RollNo FROM dbo.T_Student_Batch_Details AS TSBD 
                WHERE TSBD.I_Batch_ID=@BatchID AND TSBD.I_Status=1 AND TSBD.I_RollNo IS NOT NULL
                ) TBDTLS ON TSEP.BatchID=TBDTLS.I_Batch_ID AND TBDTLS.I_Batch_ID = TSBM.I_Batch_ID AND TSEP.StudentDetailID=TBDTLS.I_Student_ID
        WHERE   TSEP.CourseID = @CourseID AND TSEP.BatchID=@BatchID
                AND TSEP.StatusID = 1
                AND TSED.EligibilityDate <= @dtUptoDate
                AND ( TSED.IsApproved IS NULL
                      OR TSED.IsApproved = 0
                    )
                AND (TSED.IsDelivered IS NULL OR TSED.IsDelivered=0)   
                AND TSD.I_Status = 1
                AND TSEP.CenterID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyListID,@BrandID) AS FGCFR) 
        GROUP BY TSD.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name ,
                ISNULL(TBDTLS.I_RollNo,TSD.I_RollNo),
                CASE WHEN ((ISNULL(TMCOL.TotalDue,0)*100)/ISNULL(TMCOL.PayableAmount,1)>(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100))) OR (ISNULL(TDUE.TotalDue,0)>0) THEN 1
				WHEN (ISNULL(TMCOL.TotalDue,0)*100)/ISNULL(TMCOL.PayableAmount,1)<=(100-ISNULL(TCBD.I_Minimum_Regn_Amt,100)) THEN 0
				ELSE 0 END,
                TSEP.EligibilityHeaderID ,
                TSEP.CenterDispatchSchemeID ,
                TSEP.CenterID ,
                TCHND.S_Center_Name,
                TSEP.CourseID ,
                TCM.S_Course_Name ,
                TSEP.BatchID ,
                TSBM.S_Batch_Name ,
                TSEP.StatusID ,
                TSEP.IsScheduled,
                TSED.I_Delivery,
                TSED.EligibilityDate
                order by TSBM.S_Batch_Name,ISNULL(TBDTLS.I_RollNo,TSD.I_RollNo),TSD.S_Student_ID,TSED.I_Delivery
                
                
                
                
                --TABLE 1--
        --        SELECT  TSD.I_Student_Detail_ID ,
        --        TSD.S_Student_ID ,
        --        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        --        + TSD.S_Last_Name AS StudentName ,
        --        TSEP.EligibilityHeaderID ,
        --        TSEP.CenterDispatchSchemeID ,
        --        TSED.EligibilityDetailID,
        --        TSED.I_Delivery ,
        --        TSED.EligibilityDate,
        --        TSED.ItemType,
        --        TITM.Name AS ItemName,
        --        TSED.BarcodePrefix,
        --        ISNULL(TSED.IsApproved,0)AS IsApproved,
        --        ISNULL(TSED.IsDelivered,0) AS IsDelivered
        --FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
        --        INNER JOIN SMManagement.T_Student_Eligibity_Details AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
        --        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
        --        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
        --        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
        --        INNER JOIN SMManagement.T_ItemType_Master AS TITM ON TSED.ItemType=TITM.ID
        --        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSEP.CenterID
        --        LEFT JOIN
        --        (
        --        SELECT T1.S_Student_ID,SUM(T1.Total_Due) AS TotalDue FROM #temp AS T1 GROUP BY T1.S_Student_ID HAVING SUM(T1.Total_Due)>100
        --        ) TDUE ON TDUE.S_Student_ID = TSD.S_Student_ID
        --WHERE   TSEP.CourseID = @CourseID
        --        AND TSEP.StatusID = 1
        --        AND TSED.EligibilityDate <= @dtUptoDate
        --       AND ( TSED.IsApproved IS NULL
        --              OR TSED.IsApproved = 0
        --            )
        --        AND (TSED.IsDelivered IS NULL OR TSED.IsDelivered=0) 
        --        AND TSD.I_Status = 1
        --        AND TSEP.CenterID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyListID,@BrandID) AS FGCFR)       

    END
