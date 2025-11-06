CREATE PROCEDURE [ERP].[uspDueRecon]
    (
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS
    BEGIN
    
    
    
				DECLARE @BrandName VARCHAR(MAX)
		
		IF @iBrandID=109
			SET @BrandName='RICE Private Limited'
		ELSE IF @iBrandID=111
			SET @BrandName='Adamas Career'
		ELSE IF @iBrandID=107
			SET @BrandName='AIS'
		ELSE IF @iBrandID=108
			SET @BrandName='AIT'
		ELSE IF @iBrandID=110
			SET @BrandName='AWS'
		ELSE IF @iBrandID=112
			SET @BrandName='AHSMS'

        DECLARE @dtPrevMonthDate DATETIME= CASE WHEN DATEDIFF(MONTH,
                                                              @dtEndDate,
                                                              DATEADD(DAY, 1,
                                                              @dtEndDate)) = 1
                                                THEN DATEADD(DAY, -1,
                                                             DATEADD(MONTH,
                                                              DATEDIFF(MONTH,
                                                              0, @dtEndDate),
                                                              0))
                                                ELSE DATEADD(MONTH, -1,
                                                             @dtEndDate)
                                           END
                                   

        CREATE TABLE #DUERECONMONTH
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
			  I_Batch_ID int,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX) ,
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
              instanceChain VARCHAR(MAX)
            )

        CREATE TABLE #DUEPREVMONTH
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
			  I_Batch_ID int,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX) ,
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
              instanceChain VARCHAR(MAX)
            )

        CREATE TABLE #ERPSYNC
            (
              [Type] VARCHAR(MAX) ,
              S_Brand_Name VARCHAR(MAX) ,
              S_Center_Name VARCHAR(MAX) ,
              I_Transaction_Nature_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              S_Student_Name VARCHAR(MAX) ,
              S_Transaction_Code VARCHAR(MAX) ,
              Amount DECIMAL(14, 2)
            )
    
        CREATE TABLE #ERPDUERECON
            (
              StudentID VARCHAR(MAX) ,
              FeeComponent VARCHAR(MAX),
              ReconMonthDue DECIMAL(14, 2) ,
              PrevMonthDue DECIMAL(14, 2) ,
              ReconMonthFinalDue DECIMAL(14, 2) ,
              ERPDue DECIMAL(14, 2) ,
              DueDifference DECIMAL(14, 2)
            )    


        INSERT  INTO #DUERECONMONTH
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtEndDate, -- datetime
                    @sStatus = 'ALL'
 -- varchar(100)
    
        INSERT  INTO #DUEPREVMONTH
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtPrevMonthDate, -- datetime
                    @sStatus = 'ALL'
 -- varchar(100)
    
    
        INSERT  INTO #ERPSYNC
                EXEC REPORT.uspGetERPSyncReportDetail @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtStartDate = @dtStartDate, -- datetime
                    @dtEndDate = @dtEndDate
 -- datetime

        INSERT  INTO #ERPDUERECON
                ( StudentID,FeeComponent
                )
                SELECT DISTINCT
                        T1.S_Student_ID,T1.S_Component_Name
                FROM    ( SELECT    D1.S_Student_ID,D1.S_Component_Name
                          FROM      #DUERECONMONTH AS D1
                          UNION ALL
                          SELECT    D2.S_Student_ID,D2.S_Component_Name
                          FROM      #DUEPREVMONTH AS D2
                          UNION ALL
                          SELECT    E.S_Student_ID,REPLACE(E.S_Transaction_Code,'(Accrual - Adjustment)','') AS S_Component_Name
                          FROM      #ERPSYNC AS E WHERE E.I_Transaction_Nature_ID=50
                        ) T1 

        UPDATE  T1
        SET     T1.ReconMonthDue = T2.TotalDue
        FROM    #ERPDUERECON AS T1
                INNER JOIN ( SELECT D1.S_Student_ID ,D1.S_Component_Name,
                                    ISNULL(SUM(ISNULL(D1.Total_Due, 0.00)),
                                           0.00) AS TotalDue
                             FROM   #DUERECONMONTH AS D1
                             GROUP BY D1.S_Student_ID,D1.S_Component_Name
                           ) T2 ON T1.StudentID = T2.S_Student_ID AND T1.FeeComponent=T2.S_Component_Name


        UPDATE  T1
        SET     T1.PrevMonthDue = T2.TotalDue
        FROM    #ERPDUERECON AS T1
                INNER JOIN ( SELECT D1.S_Student_ID ,D1.S_Component_Name,
                                    ISNULL(SUM(ISNULL(D1.Total_Due, 0.00)),
                                           0.00) AS TotalDue
                             FROM   #DUEPREVMONTH AS D1
                             GROUP BY D1.S_Student_ID,D1.S_Component_Name
                           ) T2 ON T1.StudentID = T2.S_Student_ID AND T1.FeeComponent=T2.S_Component_Name


        UPDATE  T1
        SET     T1.ERPDue = T2.TotalDue
        FROM    #ERPDUERECON AS T1
                INNER JOIN ( SELECT E1.S_Student_ID ,REPLACE(E1.S_Transaction_Code,'(Accrual - Adjustment)','') AS S_Component_Name,
                                    ISNULL(SUM(ISNULL(E1.Amount, 0.00)), 0.00) AS TotalDue
                             FROM   #ERPSYNC AS E1
                             WHERE  E1.I_Transaction_Nature_ID = 50
                             GROUP BY E1.S_Student_ID,REPLACE(E1.S_Transaction_Code,'(Accrual - Adjustment)','')
                           ) T2 ON T1.StudentID = T2.S_Student_ID AND T1.FeeComponent=T2.S_Component_Name


        UPDATE  #ERPDUERECON
        SET     ReconMonthFinalDue = ISNULL(ReconMonthDue, 0.00)
                - ISNULL(PrevMonthDue, 0.00)
        UPDATE  #ERPDUERECON
        SET     DueDifference = ISNULL(ERPDue, 0.00)
                - ISNULL(ReconMonthFinalDue, 0.00)
		
		
		
        INSERT  INTO ERP.T_Oracle_SMS_Recon_Temp
                ( 
                  Brand ,
                  MonthYear ,
                  TypeName ,
                  FeeComponent,
                  Amount
		        )
                SELECT  @BrandName,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'DUE' ,
                        E.FeeComponent ,
                        --SUM(ISNULL(E.ERPDue, 0.00)) AS ERPDue ,
                        SUM(ISNULL(E.ReconMonthFinalDue, 0.00)) AS SMSDue
                        --SUM(ISNULL(E.DueDifference, 0.00)) AS Diff ,
                        --GETDATE()
                FROM    #ERPDUERECON AS E
                GROUP BY E.FeeComponent


        --SELECT  *
        --FROM    #ERPDUERECON AS E
 
        
        DROP TABLE #DUEPREVMONTH
        DROP TABLE #DUERECONMONTH 
        DROP TABLE #ERPSYNC
        DROP TABLE #ERPDUERECON                                   


    END
