CREATE PROCEDURE [dbo].[usp_ERP_GetAdvanceFromStudentWithInvoiceNo]    
(    
  @sHierarchyList NVARCHAR(MAX) =Null,    
  @iBrandID INT =Null,    
  @dtfromDate DATETIME=Null  ,
  @dtUptoDate DATETIME =Null,    
  @sStatus NVARCHAR(MAX) = 'ALL'     
  
)    
AS    
BEGIN    
    
     
 --DECLARE @sHierarchyList VARCHAR(MAX) ='54',    
 --  @iBrandID INT =109,    
 --  @dtUptoDate DATETIME ='2022-02-28',    
 --  @sStatus VARCHAR(100) = 'ALL' ,    
 --  @dtfromDate DATETIME='2022-02-01'    
    
    
        SET NOCOUNT ON ;    
    
        DECLARE @StudentStatus INT    
        DECLARE @dtUptoDate2 DATETIME    
        SET @dtUptoDate2 = '2017-06-30'    
    
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
                                LEFT JOIN dbo.T_Invoice_Parent P2 ON P2.I_Parent_Invoice_ID = C1.I_Invoice_Header_ID    
                       WHERE    C1.I_Status IN ( 1, 3, 0 ,2)    
                               AND (P2.I_Invoice_Header_ID IS NULL OR (P2.I_Invoice_Header_ID IS NOT NULL AND DATEDIFF(dd,@dtUptoDate2,C1.Dt_Upd_On) > 0))    
          --AND P2.I_Invoice_Header_ID IS NULL    
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
                                --ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.Dt_Crtd_On DESC ) AS InvoiceOrderdsc ,    
                                --ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.Dt_Crtd_On ASC )    
                                 ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.I_Invoice_Header_ID DESC ) AS InvoiceOrderdsc ,--akash    
                                ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.I_Invoice_Header_ID ASC )--akash    
                                    
                       FROM     C    
                       WHERE    DATEDIFF(dd, @dtUptoDate, C.Dt_Crtd_On) <= 0    
                                --AND CONVERT(DATE, C.Dt_Invoice_Date) >= '2013-01-01'    
                     )    
            INSERT  INTO #tempinvoice    
                    ( I_Invoice_Header_ID ,    
                      keyid    
                    )    
                    SELECT I_Invoice_Header_ID ,    
                            keyid    
                    FROM    C1    
                    WHERE   InvoiceOrderdsc = 1;     
    
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
            Total_Paid DECIMAL(14, 2),    
   Effective_Advance DECIMAL(14, 2)    
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
                                                              AND (A.I_Status IN (1,3,2) OR (A.I_Status = 0 AND DATEDIFF(dd,@dtUptoDate2,A.Dt_Upd_On) > 0) AND DATEDIFF(dd,@dtUptoDate,A.Dt_Crtd_On) <= 0 AND DATEDIFF(dd,@dtfromDate,A.Dt_Crtd_On) >= 0)    
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
                        FROM    [dbo].[fnGetCentreIdByBrandId](@iBrandID) fnCenter )    
                        AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) > 0    
                        AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)    
      AND ISNULL(C.Flag_IsAdvanceTax, 'N') <> 'Y'    
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
      ,T1.Effective_Advance = ISNULL(ROUND(T2.Amount_Paid, 2), 0)    
        FROM    #temp T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(N_Amount_Paid) Amount_Paid    
                             FROM   T_Receipt_Component_Detail A    
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID    
                                                              AND (I_Status <> 0    
        OR ( I_Status=0 AND DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0)    
                                                              )    
                                                              AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate)    
                                                              AND CONVERT(DATE, @dtUptoDate)    
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
                               
        UPDATE  T1    
        SET     T1.Total_Paid = ISNULL(T1.Amount_Paid, 0) + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2) ,    
    T1.Effective_Advance = ISNULL(T1.Amount_Paid, 0) + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2),    
                T1.Tax_Paid = ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)    
        FROM    #temp T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid    
                             FROM   T_Receipt_Component_Detail A    
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID    
                                                              AND (I_Status <> 0    
                   OR( I_Status=0 AND DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0)    
                                                              )    
                                                              AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate)    
                                                              AND CONVERT(DATE, @dtUptoDate)    
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail    
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
    
  --UPDATE  T1    
  --      SET     T1.Effective_Advance = ISNULL(T1.Effective_Advance, 0) - ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)    
  --      FROM    #temp T1    
  --              INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
  --                                  SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid    
  --                           FROM   T_Receipt_Component_Detail A    
  --                                  INNER JOIN dbo.T_Receipt_Header AS trh     
  --       ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID    
  --                                  AND (I_Status <> 0    
  --        OR( I_Status=0 AND DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0)    
  --                                  )    
  --                                  AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate) AND CONVERT(DATE, @dtUptoDate)             
  --                                  INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID     
  --                                  LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail    
  --                                  AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID    
  --      WHERE CONVERT(DATE, T.Dt_Installment_Date) > CONVERT(DATE, '2017-06-30')    
  --                           GROUP BY A.I_Invoice_Detail_ID    
  --                    ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
                               
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
            Total_Paid DECIMAL(14, 2),    
   Effective_Advance DECIMAL(14, 2)    
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
                                                              AND A.I_Status = 0 AND DATEDIFF(dd,@dtUptoDate2,A.Dt_Upd_On) <= 0    
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
                        FROM    [dbo].[fnGetCentreIdByBrandId](@iBrandID) fnCenter )    
                        AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) > 0                           
                        AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)    
                        AND EXISTS ( SELECT trha.I_Receipt_Header_ID    
                                     FROM   dbo.T_Receipt_Header_Archive trha    
                                     WHERE  trha.I_Invoice_Header_ID = a.I_Invoice_Header_ID )    
    AND ISNULL(C.Flag_IsAdvanceTax, 'N') <> 'Y'    
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
    ,T1.Effective_Advance = ISNULL(ROUND(T2.Amount_Paid, 2), 0)    
        FROM    #temphistory T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(N_Amount_Paid) Amount_Paid    
                             FROM   dbo.T_Receipt_Component_Detail_Archive A    
                                    INNER JOIN dbo.T_Receipt_Header_Archive AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID                                                                 
                                                         AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate)    
                                                              AND CONVERT(DATE, @dtUptoDate)    
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID    
                                                              AND ( tip.Dt_Upd_On IS NULL    
        OR (DATEDIFF(dd, @dtUptoDate, tip.Dt_Upd_On) > 0 AND DATEDIFF(dd,@dtUptoDate2,tip.Dt_Upd_On) <=0)    
                                                              )    
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
                               
        UPDATE  T1    
        SET     T1.Total_Paid = ISNULL(T1.Amount_Paid, 0) + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2),    
    T1.Effective_Advance = ISNULL(T1.Amount_Paid, 0) + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2),    
                T1.Tax_Paid = ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)    
        FROM    #temphistory T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid    
                             FROM   T_Receipt_Component_Detail_Archive A    
                                    INNER JOIN dbo.T_Receipt_Header_Archive AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID                                                                 
                                                              AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate)    
                                                              AND    
                                                              CONVERT(DATE, @dtUptoDate)    
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID    
                                                              AND ( tip.Dt_Upd_On IS NULL    
        OR (DATEDIFF(dd, @dtUptoDate, tip.Dt_Upd_On) > 0 AND DATEDIFF(dd,@dtUptoDate2,tip.Dt_Upd_On) <=0)    
                                                              )    
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail_Archive    
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
                               
              
        UPDATE  T1    
        SET     T1.Amount_Paid = ISNULL(T1.Amount_Paid, 0) + ISNULL(ROUND(T2.Amount_Paid, 2), 0),    
    T1.Effective_Advance = ISNULL(T1.Amount_Paid, 0) + ISNULL(ROUND(T2.Amount_Paid, 2), 0)        
        FROM    #temphistory T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(N_Amount_Paid) Amount_Paid    
                             FROM   dbo.T_Receipt_Component_Detail A    
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID    
                                    AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate) AND CONVERT(DATE, @dtUptoDate)    
                 AND (trh.Dt_Upd_On IS NULL OR DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0 OR I_Status=1)    
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
                               
        UPDATE  T1    
        SET     
                T1.Tax_Paid = ISNULL(T1.Tax_Paid, 0) + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)    
        FROM    #temphistory T1    
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,    
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid    
                             FROM   T_Receipt_Component_Detail A    
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID                                                                 
                                                              AND CONVERT(DATE, Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtfromDate)    
                                                              AND CONVERT(DATE, @dtUptoDate)    
                                                              AND ( trh.Dt_Upd_On IS NULL OR DATEDIFF(dd, @dtUptoDate,trh.Dt_Upd_On) > 0    
                OR I_Status=1    
                                                              )    
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID    
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail    
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID    
                             GROUP BY A.I_Invoice_Detail_ID    
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID    
            
        UPDATE T1    
        SET T1.Total_Paid = ISNULL(T1.Amount_Paid, 0) + ISNULL(T1.Tax_Paid, 0)    
   ,T1.Effective_Advance = ISNULL(T1.Amount_Paid, 0) + ISNULL(T1.Tax_Paid, 0)    
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
                  Tax_Paid,    
                  Total_Paid,    
      Effective_Advance    
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
                        Total_Paid,    
      Effective_Advance    
                FROM    #temphistory    
      
        --end    
    
  IF(CONVERT(DATE, @dtUptoDate) > CONVERT(DATE, '2017-05-31'))    
  BEGIN    
   UPDATE T1    
   SET T1.Effective_Advance = ISNULL(T1.Effective_Advance, 0) - ISNULL(T1.Tax_Paid, 0)    
   FROM #temp T1    
   WHERE CONVERT(DATE, T1.Dt_Installment_Date) > CONVERT(DATE, '2017-06-30')    
  END    
    
  UPDATE #temp SET Effective_Advance = ISNULL(Effective_Advance, 0), Total_Paid = ISNULL(Total_Paid, 0), Tax_Paid = ISNULL(Tax_Paid, 0), Amount_Paid = ISNULL(Amount_Paid, 0)    
    
        SELECT  T.I_Student_Detail_ID,    
    T.S_Mobile_No,    
    T.S_Student_ID,    
    T.I_Roll_No,    
    T.S_Student_Name,    
    T.S_Invoice_No,    
    T.S_Receipt_No ,    
    T.Dt_Invoice_Date,    
    T.S_Component_Name ,    
    T.S_Batch_Name,    
    T.S_Course_Name,    
    T.I_Center_ID,    
    T.S_Center_Name,    
    T.S_Brand_Name,    
    T.S_Cost_Center,    
    T.Due_Value,    
    T.Dt_Installment_Date,    
    T.I_Installment_No,    
    T.I_Parent_Invoice_ID,    
    T.I_Invoice_Detail_ID,    
    T.Revised_Invoice_Date,    
    T.Tax_Value,    
    T.Total_Value,    
    T.Amount_Paid,    
    T.Tax_Paid,    
    T.Total_Paid ,    
    Adv.N_Advance_Amount as Effective_Advance,    
    DATENAME(MONTH,T.Dt_Installment_Date)+' '+CAST(DATEPART(YYYY,T.Dt_Installment_Date) AS VARCHAR) AS MonthYear  
 --,FN2.instanceChain  
 ,--T5.InvoiceNo as AdvanceInvoiceNo,    
    TICD2.S_Invoice_Number AS OrgInvoiceNo,    
    TICD3.S_Invoice_Number as AdvanceInvoiceNo,    
    TGCM.S_State_Code + '-' + TSM.S_State_Name AS StateNameAndCode,    
    18 AS TaxType,    
    TICD3.Dt_Installment_Date as AdvanceInvoiceDate,    
    CAST((9*Adv.N_Advance_Amount)/100 AS DECIMAL(14,2)) as CGST,    
    CAST((9*Adv.N_Advance_Amount)/100 AS DECIMAL(14,2)) as SGST    
        FROM    #temp T    
    inner join     
    (    
     select TAICD.* from T_Advance_Invoice_Child_Detail_Mapping TAICD     
     inner join T_Receipt_Component_Detail TRCD on TAICD.I_Receipt_Component_Detail_ID=TRCD.I_Receipt_Comp_Detail_ID    
     inner join T_Receipt_Header TRH on TRCD.I_Receipt_Detail_ID=TRH.I_Receipt_Header_ID    
     where    
     (TRH.I_Status=1 and TRH.Dt_Crtd_On>=@dtfromDate and TRH.Dt_Crtd_On<DATEADD(d,1,@dtUptoDate))    
     OR    
     (TRH.I_Status=0 and TRH.Dt_Upd_On>@dtUptoDate and TRH.Dt_Crtd_On>=@dtfromDate and TRH.Dt_Crtd_On<DATEADD(d,1,@dtUptoDate))    
    ) Adv on Adv.I_Invoice_Detail_ID=T.I_Invoice_Detail_ID    
    inner join T_Invoice_Child_Detail TICD3 on Adv.I_Advance_Ref_Invoice_Child_Detail_ID=TICD3.I_Invoice_Detail_ID    
    INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = T.I_Center_ID    
                INNER JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = T.I_Center_ID    
                INNER JOIN dbo.T_GST_Code_Master AS TGCM ON TGCM.I_State_ID = TCA.I_State_ID    
                                                            AND TGCM.I_Brand_ID = TCHND.I_Brand_ID    
                INNER JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TCA.I_State_ID    
    --inner join    
    --(    
    -- select T4.I_Invoice_Detail_ID,T4.InvoiceNo from    
    -- (    
    --  SELECT I_Invoice_Detail_ID,    
    --  stuff(    
    --  (    
    --  SELECT ','+ S_Invoice_Number FROM    
    --  (    
    --   SELECT DISTINCT TAICD.I_Invoice_Detail_ID,TICD.S_Invoice_Number    
    --   FROM T_Advance_Invoice_Child_Detail_Mapping TAICD    
    --   inner join T_Invoice_Child_Detail TICD on TAICD.I_Advance_Ref_Invoice_Child_Detail_ID=TICD.I_Invoice_Detail_ID     
    --  ) T1     
    --  WHERE I_Invoice_Detail_ID = T3.I_Invoice_Detail_ID FOR XML PATH('')    
    --  ),1,1,'') as InvoiceNo    
    --  FROM (SELECT DISTINCT T2.I_Invoice_Detail_ID FROM    
    --  (    
    --   SELECT DISTINCT TAICD.I_Invoice_Detail_ID    
    --   FROM T_Advance_Invoice_Child_Detail_Mapping TAICD    
    --   inner join T_Invoice_Child_Detail TICD on TAICD.I_Advance_Ref_Invoice_Child_Detail_ID=TICD.I_Invoice_Detail_ID    
    --  ) T2    
    --  ) T3    
    -- ) T4    
    --) T5 on T.I_Invoice_Detail_ID=T5.I_Invoice_Detail_ID    
                INNER JOIN [dbo].[fnGetCentreIdByBrandId](@iBrandID) FN1 ON T.I_Center_ID = FN1.CenterID    
                --INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,    
                --                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID    
    INNER JOIN dbo.T_Invoice_Child_Detail AS TICD2 ON T.I_Invoice_Detail_ID=TICD2.I_Invoice_Detail_ID    
        WHERE   ISNULL(Total_Paid, 0) <> 0 AND ISNULL(Effective_Advance, 0) <> 0    
        ORDER BY S_Center_Name ,    
                S_Batch_Name ,    
                I_Roll_NO ;    
    
    
drop table #tempinvoice    
drop table #temp    
drop table #temphistory    
    
    
END

