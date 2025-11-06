CREATE PROCEDURE [REPORT].[uspGetDueReport_History_dateRange]
    (
      -- Add the parameters for the stored procedure here
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtUptoDate DATETIME ,
      @sStatus VARCHAR(100) = 'ALL',
      @dtFromDate datetime
    )
AS 
    BEGIN

        SET NOCOUNT ON ;

        DECLARE @StudentStatus INT

        IF ( @sStatus = 'ALL' ) 
            BEGIN
                SET @StudentStatus = NULL
            END	
        ELSE 
            IF ( @sStatus = 'Active' ) 
                BEGIN
                    SET @StudentStatus = 1
                END
            ELSE 
                IF ( @sStatus = 'Dropped Out' ) 
                    BEGIN
                        SET @StudentStatus = 0
                    END
                    
        CREATE TABLE #tempinvoice
            (
              I_Invoice_Header_ID INT ,
              keyid INT
            ) ;

        WITH    C ( I_Invoice_Header_ID, S_Invoice_No, Dt_Crtd_On, Dt_Upd_On, Dt_Invoice_Date, I_Parent_Invoice_ID, Parent_S_Invoice_No, Current_I_Invoice_Header_ID, I_Status, keyid, PKeyID )
                  AS ( SELECT   C1.I_Invoice_Header_ID ,
                                C1.S_Invoice_No ,
                                C1.Dt_Crtd_On ,
                                C1.Dt_Upd_On ,
                                C1.Dt_Invoice_Date ,
                                C1.I_Parent_Invoice_ID ,
                                P1.S_Invoice_No AS Parent_S_Invoice_No ,
                                C1.I_Invoice_Header_ID AS Current_I_Invoice_Header_ID ,
                                C1.I_Status ,
                                1 ,
                                ROW_NUMBER() OVER ( ORDER BY C1.I_Invoice_Header_ID )
                       FROM     dbo.T_Invoice_Parent C1
                                LEFT JOIN dbo.T_Invoice_Parent P1 ON c1.I_Parent_Invoice_ID = P1.I_Invoice_Header_ID
                       LEFT JOIN dbo.T_Invoice_Parent P2 ON P2.I_Parent_Invoice_ID=C1.I_Invoice_Header_ID
                       WHERE    C1.I_Status IN ( 1, 3,0 ) AND P2.I_Invoice_Header_ID IS NULL
                               -- AND C1.I_Parent_Invoice_ID IS NOT NULL
                       UNION ALL
                       SELECT   P.I_Invoice_Header_ID ,
                                P.S_Invoice_No ,
                                P.Dt_Crtd_On ,
                                P.Dt_Upd_On ,
                                P.Dt_Invoice_Date ,
                                P.I_Parent_Invoice_ID ,
                                ( SELECT    P1.S_Invoice_No
                                  FROM      dbo.T_Invoice_Parent P1
                                  WHERE     P.I_Parent_Invoice_ID = P1.I_Invoice_Header_ID
                                ) AS Parent_S_Invoice_No ,
                                C.Current_I_Invoice_Header_ID ,
                                P.I_Status ,
                                C.keyid + 1 ,
                                C.PKeyID
                       FROM     dbo.T_Invoice_Parent AS P
                                INNER JOIN C ON C.I_Parent_Invoice_ID = P.I_Invoice_Header_ID
                     ),
                C1 ( I_Invoice_Header_ID, InvoiceOrderdsc, keyid )
                  AS ( SELECT   C.I_Invoice_Header_ID ,
                                ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.Dt_Crtd_On DESC ) AS InvoiceOrderdsc ,
                                ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.Dt_Crtd_On ASC )
                       FROM     C
                       WHERE    DATEDIFF(dd, @dtUptoDate, C.Dt_Crtd_On) <= 0
                                AND CONVERT(DATE, C.Dt_Invoice_Date) >= '2013-01-01'
                     )
            INSERT  INTO #tempinvoice
                    ( I_Invoice_Header_ID ,
                      keyid
                    )
                    SELECT  I_Invoice_Header_ID ,
                            keyid
                    FROM    C1
                    WHERE   InvoiceOrderdsc = 1 ;            

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
              Total_Due DECIMAL(14, 2)
            )

        INSERT  INTO #temp
                ( I_Student_Detail_ID ,
                  S_Mobile_No ,
                  S_Student_ID ,
                  I_Roll_No ,
                  S_Student_Name ,
                  S_Invoice_No ,
                  Dt_Invoice_Date ,
                  S_Component_Name ,
                  S_Batch_Name ,
                  S_Course_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  S_Brand_Name ,
                  S_Cost_Center ,
                  Due_Value ,
                  Dt_Installment_Date ,
                  I_Installment_No ,
                  I_Parent_Invoice_ID ,
                  I_Invoice_Detail_ID ,
                  Revised_Invoice_Date ,
                  Tax_Value ,
                  Total_Value
                )
                SELECT  B.I_Invoice_Child_Header_ID ,
                        E.S_Mobile_No ,
                        S_Student_ID ,
                        E.I_RollNo ,
                        E.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                        + S_Last_Name AS S_Student_Name ,
                        A.S_Invoice_No ,
                        A.Dt_Invoice_Date ,
                        S_Component_Name ,
                        tsbm.S_Batch_Name ,
                        tcm.S_Course_Name ,
                        tcm2.I_Centre_Id ,
                        tcm2.S_Center_Name ,
                        S_Brand_Name ,
                        S_Cost_Center ,
                        C.N_Amount_Due Due_Value ,
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        A.I_Parent_Invoice_ID ,
                        C.I_Invoice_Detail_ID ,
                        CASE WHEN I_Parent_Invoice_ID IS NULL THEN NULL
                             ELSE A.Dt_Crtd_On
                        END AS Revised_Invoice_Date ,
                        ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) Tax_Value ,
                        ISNULL(c.N_Amount_Due, 0)
                        + ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value
                FROM    T_Invoice_Parent A
                        INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                                                              AND A.I_Status IN (
                                                              1, 3 )
                        INNER JOIN #tempinvoice ON #tempinvoice.I_Invoice_Header_ID = A.I_Invoice_Header_ID
                        INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
                        INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID = C.I_Fee_Component_ID
                                                              AND D.I_Status = 1
                        INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID = A.I_Student_Detail_ID
                        INNER JOIN dbo.T_Centre_Master AS tcm2 ON A.I_Centre_Id = tcm2.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm2.I_Centre_Id = tbcd.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
                        --INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Student_ID = a.I_Student_Detail_ID
                        --                                      AND tsbd.I_Status = 1
                         OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                      WHERE     tsbd.I_Student_ID = a.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID
                        LEFT JOIN dbo.T_Course_Master AS tcm ON tcm.I_Course_ID = tsbm.I_Course_ID
                        LEFT JOIN T_Invoice_Detail_Tax F ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
                WHERE   A.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyList,
                                                       @iBrandID) fnCenter )
                        --AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) <= 0
                        AND CONVERT(DATE,Dt_Installment_Date) BETWEEN @dtFromDate AND @dtUptoDate
                        AND ( ( #tempinvoice.keyid = 1
                                AND I_Installment_No <> 1
                              )
                              OR ( #tempinvoice.keyid <> 1 )
                            )
                        AND C.I_Fee_Component_ID <> 36
                        AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)
                GROUP BY B.I_Invoice_Child_Header_ID ,
                        S_Student_ID ,
                        E.S_Mobile_No ,
                        E.I_RollNo ,
                        A.S_Invoice_No ,
                        A.Dt_Invoice_Date ,
                        S_Component_Name ,
                        C.N_Amount_Due ,
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        A.I_Parent_Invoice_ID ,
                        A.Dt_Crtd_On ,
                        C.I_Invoice_Detail_ID ,
                        tsbm.S_Batch_Name ,
                        tcm.S_Course_Name ,
                        tcm2.I_Centre_Id ,
                        tcm2.S_Center_Name ,
                        S_Brand_Name ,
                        S_Cost_Center ,
                        E.S_First_Name ,
                        E.S_Middle_Name ,
                        E.S_Last_Name
 
  
        UPDATE  T1
        SET     T1.Amount_Paid = ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temp T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              AND (I_Status <> 0
                                                              OR
                                                              ( I_Status=0 AND 
                                                               DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              trh.Dt_Upd_On) > 0
                                                              )
                                                              )
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                           
        UPDATE  T1
        SET     T1.Total_Paid = ISNULL(T1.Amount_Paid, 0)
                + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2) ,
                T1.Tax_Paid = ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)
        FROM    #temp T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              AND (I_Status <> 0
                                                              OR
                                                              ( I_Status=0 AND 
                                                               DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              trh.Dt_Upd_On) > 0
                                                              )
                                                              )
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                           
        --for history data
        
        CREATE TABLE #temphistory
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
              Total_Due DECIMAL(14, 2)
            )

        INSERT  INTO #temphistory
                ( I_Student_Detail_ID ,
                  S_Mobile_No ,
                  S_Student_ID ,
                  I_Roll_No ,
                  S_Student_Name ,
                  S_Invoice_No ,
                  Dt_Invoice_Date ,
                  S_Component_Name ,
                  S_Batch_Name ,
                  S_Course_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  S_Brand_Name ,
                  S_Cost_Center ,
                  Due_Value ,
                  Dt_Installment_Date ,
                  I_Installment_No ,
                  I_Parent_Invoice_ID ,
                  I_Invoice_Detail_ID ,
                  Revised_Invoice_Date ,
                  Tax_Value ,
                  Total_Value
                )
                SELECT  B.I_Invoice_Child_Header_ID ,
                        E.S_Mobile_No ,
                        S_Student_ID ,
                        E.I_RollNo ,
                        E.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                        + S_Last_Name AS S_Student_Name ,
                        A.S_Invoice_No ,
                        A.Dt_Invoice_Date ,
                        S_Component_Name ,
                        tsbm.S_Batch_Name ,
                        tcm.S_Course_Name ,
                        tcm2.I_Centre_Id ,
                        tcm2.S_Center_Name ,
                        S_Brand_Name ,
                        S_Cost_Center ,
                        C.N_Amount_Due Due_Value ,
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        A.I_Parent_Invoice_ID ,
                        C.I_Invoice_Detail_ID ,
                        CASE WHEN I_Parent_Invoice_ID IS NULL THEN NULL
                             ELSE A.Dt_Crtd_On
                        END AS Revised_Invoice_Date ,
                        ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) Tax_Value ,
                        ISNULL(c.N_Amount_Due, 0)
                        + ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value
                FROM    T_Invoice_Parent A
                        INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                                                              --AND A.I_Status NOT IN (
                                                              --1, 3 )
                                                               AND A.I_Status=0
                        INNER JOIN #tempinvoice ON #tempinvoice.I_Invoice_Header_ID = A.I_Invoice_Header_ID
                        INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
                        INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID = C.I_Fee_Component_ID
                                                              AND D.I_Status = 1
                        INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID = A.I_Student_Detail_ID
                        INNER JOIN dbo.T_Centre_Master AS tcm2 ON A.I_Centre_Id = tcm2.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm2.I_Centre_Id = tbcd.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
                        --INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Student_ID = a.I_Student_Detail_ID
                        --                                      AND tsbd.I_Status = 1
                         OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                      WHERE     tsbd.I_Student_ID = a.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID
                        LEFT JOIN dbo.T_Course_Master AS tcm ON tcm.I_Course_ID = tsbm.I_Course_ID
                        LEFT JOIN T_Invoice_Detail_Tax F ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
                WHERE   A.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyList,
                                                       @iBrandID) fnCenter )
                       -- AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) <= 0
                       AND CONVERT(DATE,Dt_Installment_Date) BETWEEN @dtFromDate AND @dtUptoDate
                        AND ( ( #tempinvoice.keyid = 1
                                AND I_Installment_No <> 1
                              )
                              OR ( #tempinvoice.keyid <> 1 )
                            )
                        AND C.I_Fee_Component_ID <> 36
                        AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)
                        AND EXISTS ( SELECT trha.I_Receipt_Header_ID
                                     FROM   dbo.T_Receipt_Header_Archive trha
                                     WHERE  trha.I_Invoice_Header_ID = a.I_Invoice_Header_ID )
                GROUP BY B.I_Invoice_Child_Header_ID ,
                        S_Student_ID ,
                        E.S_Mobile_No ,
                        E.I_RollNo ,
                        A.S_Invoice_No ,
                        A.Dt_Invoice_Date ,
                        S_Component_Name ,
                        C.N_Amount_Due ,
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        A.I_Parent_Invoice_ID ,
                        A.Dt_Crtd_On ,
                        C.I_Invoice_Detail_ID ,
                        tsbm.S_Batch_Name ,
                        tcm.S_Course_Name ,
                        tcm2.I_Centre_Id ,
                        tcm2.S_Center_Name ,
                        S_Brand_Name ,
                        S_Cost_Center ,
                        E.S_First_Name ,
                        E.S_Middle_Name ,
                        E.S_Last_Name
 
  
        UPDATE  T1
        SET     T1.Amount_Paid = ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   dbo.T_Receipt_Component_Detail_Archive A
                                    INNER JOIN dbo.T_Receipt_Header_Archive AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              --AND I_Status <> 0 
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND ( tip.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              tip.Dt_Upd_On) > 0
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                           
        UPDATE  T1
        SET     T1.Total_Paid = ISNULL(T1.Amount_Paid, 0)
                + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2) ,
                T1.Tax_Paid = ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid
                             FROM   T_Receipt_Component_Detail_Archive A
                                    INNER JOIN dbo.T_Receipt_Header_Archive AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              --AND I_Status <> 0  
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND ( tip.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              tip.Dt_Upd_On) > 0
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail_Archive
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                           
          
        UPDATE  T1
        SET     T1.Amount_Paid = isnull(T1.Amount_Paid,0)+ ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   dbo.T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              --AND I_Status <> 0 
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                                              AND ( trh.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              trh.Dt_Upd_On) > 0
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                           
        UPDATE  T1
        SET     
        --T1.Total_Paid =ISNULL(T1.Total_Paid,0)+ ISNULL(T1.Amount_Paid, 0)
        --        + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2) ,
                T1.Tax_Paid =ISNULL(T1.Tax_Paid,0)+ ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              --AND I_Status <> 0  
                                                              AND DATEDIFF(dd,
                                                              Dt_Receipt_Date,
                                                              @dtUptoDate) >= 0
                                                              AND ( trh.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,
                                                              @dtUptoDate,
                                                              trh.Dt_Upd_On) > 0
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
        
        UPDATE   T1
        SET     
        T1.Total_Paid = ISNULL(T1.Amount_Paid, 0) + ISNULL(T1.Tax_Paid, 0)
        FROM    #temphistory T1
        
          
        INSERT  INTO #temp
                ( I_Student_Detail_ID ,
                  S_Mobile_No ,
                  S_Student_ID ,
                  I_Roll_No ,
                  S_Student_Name ,
                  S_Invoice_No ,
                  S_Receipt_No ,
                  Dt_Invoice_Date ,
                  S_Component_Name ,
                  S_Batch_Name ,
                  S_Course_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  S_Brand_Name ,
                  S_Cost_Center ,
                  Due_Value ,
                  Dt_Installment_Date ,
                  I_Installment_No ,
                  I_Parent_Invoice_ID ,
                  I_Invoice_Detail_ID ,
                  Revised_Invoice_Date ,
                  Tax_Value ,
                  Total_Value ,
                  Amount_Paid ,
                  Tax_Paid ,
                  Total_Paid ,
                  Total_Due 
                )
                SELECT  I_Student_Detail_ID ,
                        S_Mobile_No ,
                        S_Student_ID ,
                        I_Roll_No ,
                        S_Student_Name ,
                        S_Invoice_No ,
                        S_Receipt_No ,
                        Dt_Invoice_Date ,
                        S_Component_Name ,
                        S_Batch_Name ,
                        S_Course_Name ,
                        I_Center_ID ,
                        S_Center_Name ,
                        S_Brand_Name ,
                        S_Cost_Center ,
                        Due_Value ,
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        I_Parent_Invoice_ID ,
                        I_Invoice_Detail_ID ,
                        Revised_Invoice_Date ,
                        Tax_Value ,
                        Total_Value ,
                        Amount_Paid ,
                        Tax_Paid ,
                        Total_Paid ,
                        Total_Due
                FROM    #temphistory
                     
        --end
        
        
        UPDATE  #temp
        SET     Total_Due = ISNULL(Total_Value, 0) - ISNULL(Total_Paid, 0)
        
        SELECT  T.* ,
                FN2.instanceChain
        FROM    #temp T
                INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                          @iBrandID) FN1 ON T.I_Center_ID = FN1.CenterID
                INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
        --WHERE   ISNULL(Total_Value, 0) > ISNULL(Total_Paid, 0)
        WHERE   ISNULL(Total_Due, 0) >0
        ORDER BY S_Center_Name ,
                S_Batch_Name ,
                I_Roll_NO ;
				
	
			
			
			
    END
