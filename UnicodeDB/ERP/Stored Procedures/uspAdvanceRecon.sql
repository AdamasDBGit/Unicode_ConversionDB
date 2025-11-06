CREATE PROCEDURE [ERP].[uspAdvanceRecon]
    (
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS
    BEGIN
    
        DECLARE @BrandName VARCHAR(MAX)
		
        IF @iBrandID = 109
            SET @BrandName = 'RICE Private Limited'
        ELSE
            IF @iBrandID = 111
                SET @BrandName = 'Adamas Career'
            ELSE
                IF @iBrandID = 107
                    SET @BrandName = 'AIS'
                ELSE
                    IF @iBrandID = 108
                        SET @BrandName = 'AIT'
                    ELSE
                        IF @iBrandID = 110
                            SET @BrandName = 'AWS'
                        ELSE
                            IF @iBrandID = 112
                                SET @BrandName = 'AHSMS'

        DECLARE @dtSMSInceptionDate DATETIME = '2011-01-01'
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


        CREATE TABLE #ERPSYNCADV
            (
              [Type] VARCHAR(MAX) ,
              S_Brand_Name VARCHAR(MAX) ,
              S_Center_Name VARCHAR(MAX) ,
              I_Transaction_Nature_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              S_Student_Name VARCHAR(MAX) ,
              S_Transaction_Code VARCHAR(MAX) ,
              Amount DECIMAL(14, 2) ,
              FinalAmount DECIMAL(14, 2)
            )
    
        CREATE TABLE #RECONMONTHADV
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
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
              Effective_Advance DECIMAL(14, 2) ,
              MonthYear VARCHAR(MAX) ,
              instanceChain VARCHAR(MAX)
            ) 


        CREATE TABLE #PREVMONTHADV
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
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
              Effective_Advance DECIMAL(14, 2) ,
              MonthYear VARCHAR(MAX) ,
              instanceChain VARCHAR(MAX)
            )

        CREATE TABLE #ERPADVRECON
            (
              StudentID VARCHAR(MAX) ,
              ReconMonthAdv DECIMAL(14, 2) ,
              PrevMonthAdv DECIMAL(14, 2) ,
              ReconMonthFinalAdv DECIMAL(14, 2) ,
              ERPAdv DECIMAL(14, 2) ,
              AdvDifference DECIMAL(14, 2)
            )
                
        CREATE TABLE #ERPADVCAL
            (
              Std VARCHAR(MAX) ,
              CollectionData DECIMAL(14, 2) ,
              AdjData DECIMAL(14, 2) ,
              ActAdv DECIMAL(14, 2)
            )           
    
    
        INSERT  INTO #ERPSYNCADV
                ( Type ,
                  S_Brand_Name ,
                  S_Center_Name ,
                  I_Transaction_Nature_ID ,
                  S_Student_ID ,
                  S_Student_Name ,
                  S_Transaction_Code ,
                  Amount
                )
                EXEC REPORT.uspGetERPSyncReportDetail @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtStartDate = @dtStartDate, -- datetime
                    @dtEndDate = @dtEndDate
 -- datetime 
 
 
        INSERT  INTO #RECONMONTHADV
                EXEC REPORT.uspGetAdvanceformStudentReport_History @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtEndDate, -- datetime
                    @sStatus = 'ALL', -- varchar(100)
                    @dtfromDate = @dtSMSInceptionDate -- datetime
     
     
        INSERT  INTO #PREVMONTHADV
                EXEC REPORT.uspGetAdvanceformStudentReport_History @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtPrevMonthDate, -- datetime
                    @sStatus = 'ALL', -- varchar(100)
                    @dtfromDate = @dtSMSInceptionDate -- datetime     
 
 
 
        UPDATE  #ERPSYNCADV
        SET     FinalAmount = ISNULL(Amount, 0.00)
        WHERE   I_Transaction_Nature_ID = 6
        UPDATE  #ERPSYNCADV
        SET     FinalAmount = ( -1 ) * ISNULL(Amount, 0.00)
        WHERE   I_Transaction_Nature_ID = 9 
 
        UPDATE  #ERPSYNCADV
        SET     FinalAmount = ISNULL(Amount, 0.00)
        WHERE   I_Transaction_Nature_ID IN ( 5, 3, 7, 8 )
                AND S_Transaction_Code NOT LIKE '%Reversal%'
                AND S_Transaction_Code NOT LIKE '%Deposit%'
        UPDATE  #ERPSYNCADV
        SET     FinalAmount = ( -1 ) * ISNULL(Amount, 0.00)
        WHERE   I_Transaction_Nature_ID IN ( 5, 3, 7, 8 )
                AND S_Transaction_Code LIKE '%Reversal%'
                AND S_Transaction_Code NOT LIKE '%Deposit%'
 
        INSERT  INTO #ERPADVRECON
                ( StudentID
                )
                SELECT DISTINCT
                        T1.S_Student_ID
                FROM    ( SELECT    R1.S_Student_ID
                          FROM      #RECONMONTHADV AS R1
                          UNION ALL
                          SELECT    R1.S_Student_ID
                          FROM      #PREVMONTHADV AS R1
                          UNION ALL
                          SELECT    R1.S_Student_ID
                          FROM      #ERPSYNCADV AS R1
                        ) T1
 
 
        UPDATE  T1
        SET     T1.ReconMonthAdv = T2.TotalAdv
        FROM    #ERPADVRECON AS T1
                INNER JOIN ( SELECT R.S_Student_ID ,
                                    ISNULL(SUM(ISNULL(R.Effective_Advance,
                                                      0.00)), 0.00) AS TotalAdv
                             FROM   #RECONMONTHADV AS R
                             GROUP BY R.S_Student_ID
                           ) T2 ON T1.StudentID = T2.S_Student_ID
 
 
        UPDATE  T1
        SET     T1.PrevMonthAdv = T2.TotalAdv
        FROM    #ERPADVRECON AS T1
                INNER JOIN ( SELECT R.S_Student_ID ,
                                    ISNULL(SUM(ISNULL(R.Effective_Advance,
                                                      0.00)), 0.00) AS TotalAdv
                             FROM   #PREVMONTHADV AS R
                             GROUP BY R.S_Student_ID
                           ) T2 ON T1.StudentID = T2.S_Student_ID
 
 
        INSERT  INTO #ERPADVCAL
                ( Std 
			    )
                SELECT DISTINCT
                        E.S_Student_ID
                FROM    #ERPSYNCADV AS E
			
			
        UPDATE  T1
        SET     T1.CollectionData = T2.Col
        FROM    #ERPADVCAL AS T1
                INNER JOIN ( SELECT E.S_Student_ID ,
                                    ISNULL(SUM(ISNULL(E.FinalAmount, 0.00)),
                                           0.00) AS Col
                             FROM   #ERPSYNCADV AS E
                             WHERE  E.I_Transaction_Nature_ID IN ( 3, 5, 7, 8 )
                             GROUP BY E.S_Student_ID
                           ) T2 ON T1.Std = T2.S_Student_ID
			
			
        UPDATE  T1
        SET     T1.AdjData = T2.Adj
        FROM    #ERPADVCAL AS T1
                INNER JOIN ( SELECT E.S_Student_ID ,
                                    ISNULL(SUM(ISNULL(E.FinalAmount, 0.00)),
                                           0.00) AS Adj
                             FROM   #ERPSYNCADV AS E
                             WHERE  E.I_Transaction_Nature_ID IN ( 6, 9 )
                             GROUP BY E.S_Student_ID
                           ) T2 ON T1.Std = T2.S_Student_ID
			
			
        UPDATE  #ERPADVCAL
        SET     ActAdv = ISNULL(CollectionData, 0.00) - ISNULL(AdjData, 0.00)
			
			
        UPDATE  T1
        SET     T1.ERPAdv = T2.TotalAdv
        FROM    #ERPADVRECON AS T1
                INNER JOIN ( SELECT E.Std ,
                                    ISNULL(SUM(ISNULL(E.ActAdv, 0.00)), 0.00) AS TotalAdv
                             FROM   #ERPADVCAL AS E
                             GROUP BY E.Std
                           ) T2 ON T1.StudentID = T2.Std
			
			
 
 
        UPDATE  #ERPADVRECON
        SET     ReconMonthFinalAdv = ISNULL(ReconMonthAdv, 0.00)
                - ISNULL(PrevMonthAdv, 0.00)
        UPDATE  #ERPADVRECON
        SET     AdvDifference = ISNULL(ERPAdv, 0.00)
                - ISNULL(ReconMonthFinalAdv, 0.00)
 
        INSERT  INTO ERP.T_Oracle_SMS_Recon_Temp
                ( Brand ,
                  MonthYear ,
                  TypeName ,
                  FeeComponent ,
                  Amount
                )
                SELECT  @BrandName ,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'ADVANCE' ,
                        'AdvanceFromStudent' ,  
                        --SUM(ISNULL(E.ERPAdv, 0.00)) AS ERPAdv ,
                        SUM(ISNULL(E.ReconMonthFinalAdv, 0.00)) AS SMSAdv 
                    --SUM(ISNULL(E.AdvDifference, 0.00)) AS Diff,
                    --GETDATE()
                FROM    #ERPADVRECON AS E
 
            --SELECT  *
            --FROM    #ERPADVRECON AS E
            
            --SELECT * FROM #ERPSYNCADV AS E
 
        DROP TABLE #ERPSYNCADV 
        DROP TABLE #RECONMONTHADV
        DROP TABLE #PREVMONTHADV
        DROP TABLE #ERPADVRECON 
        DROP TABLE #ERPADVCAL




    END
