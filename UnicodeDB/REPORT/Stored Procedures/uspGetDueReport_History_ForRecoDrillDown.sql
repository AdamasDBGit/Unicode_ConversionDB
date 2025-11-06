

CREATE PROCEDURE [REPORT].[uspGetDueReport_History_ForRecoDrillDown] 
--EXEC [REPORT].[uspGetDueReport_History] '54', 109, '2018-04-30', 'ALL'
    (
      -- Add the parameters for the stored procedure here
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtUptoDate DATETIME ,
      @sStatus VARCHAR(100) = 'ALL' 
    )
AS 
    BEGIN

        SET NOCOUNT ON ;
        
        DECLARE @StudentStatus INT

        IF ( @sStatus = 'ALL' ) 
            BEGIN
                SET @StudentStatus = NULL
            END	
        ELSE IF ( @sStatus = 'Active' ) 
            BEGIN
                SET @StudentStatus = 1
            END
        ELSE IF ( @sStatus = 'Dropped Out' ) 
            BEGIN
                SET @StudentStatus = 0
            END
        
                    
        CREATE TABLE #tempinvoice
            (
              I_Invoice_Header_ID INT ,
              keyid INT
            ) ;

	    CREATE TABLE #tempinvoicedt
            (
              I_Invoice_Header_ID INT ,
              Dt_Upd_On DATE,
			  Dt_Installment_Date DATE
            ) ;

       INSERT INTO #tempinvoicedt(I_Invoice_Header_ID,Dt_Upd_On, Dt_Installment_Date)
		 SELECT Ch.I_Invoice_Header_ID,th.Dt_Upd_On ,cd.Dt_Installment_Date
				FROM T_Invoice_Child_Header AS ch 
				INNER JOIN T_Invoice_Child_Detail as cd on ch.I_Invoice_Child_Header_ID=cd.I_Invoice_Child_Header_ID
				INNER JOIN T_Receipt_Component_Detail as tc on cd.I_Invoice_Detail_ID=tc.I_Invoice_Detail_ID
				INNER JOIN T_Receipt_Header as th on tc.I_Receipt_Detail_ID=th.I_Receipt_Header_ID 
						AND cd.Dt_Installment_Date < th.Dt_Upd_On 

        ;WITH    C ( I_Invoice_Header_ID, S_Invoice_No, Dt_Crtd_On, Dt_Upd_On, Dt_Invoice_Date, I_Parent_Invoice_ID, Parent_S_Invoice_No, Current_I_Invoice_Header_ID, I_Status, keyid, PKeyID )
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
                       FROM     dbo.T_Invoice_Parent C1 WITH ( NOLOCK )
                                LEFT JOIN dbo.T_Invoice_Parent P1  WITH ( NOLOCK ) ON c1.I_Parent_Invoice_ID = P1.I_Invoice_Header_ID
								LEFT JOIN dbo.T_Invoice_Parent P2 WITH ( NOLOCK ) ON P2.I_Parent_Invoice_ID=C1.I_Invoice_Header_ID
                       WHERE    C1.I_Status IN ( 1, 3,0,2 ) 
					   AND P2.I_Invoice_Header_ID IS NULL
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
                       FROM     dbo.T_Invoice_Parent AS P WITH ( NOLOCK )
                                INNER JOIN C ON C.I_Parent_Invoice_ID = P.I_Invoice_Header_ID
                     ),
                C1 ( I_Invoice_Header_ID, InvoiceOrderdsc, keyid )
                  AS ( SELECT   C.I_Invoice_Header_ID,
								 (CASE WHEN (C.I_Status=0 
								 AND (CASE WHEN C.Dt_Crtd_On>=C.Dt_Upd_On THEN C.Dt_Crtd_On ELSE C.Dt_Upd_On END)>='2017-07-01'
								 AND (C.Dt_Upd_On> ( SELECT TOP 1 T.Dt_Upd_On 
															FROM 
															#tempinvoicedt as T Inner Join C on T.I_Invoice_Header_ID=C.I_Invoice_Header_ID
															and C.I_Status=0
															AND C.Dt_Upd_On > T.Dt_Installment_Date
								 ))) THEN 1 ELSE (ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.I_Invoice_Header_ID DESC )) END ) AS InvoiceOrderdsc ,--akash
                                (ROW_NUMBER() OVER ( PARTITION BY C.PKeyID ORDER BY C.I_Invoice_Header_ID ASC ))--raj
                       FROM     C
                       WHERE    DATEDIFF(dd, @dtUptoDate, C.Dt_Crtd_On) <= 0
                     )
            INSERT  INTO #tempinvoice
                    ( I_Invoice_Header_ID ,
                      keyid
                    )
                    SELECT  DISTINCT I_Invoice_Header_ID ,
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
          I_Fee_Component_ID INT,
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
          Total_Due DECIMAL(14, 2),
          IsGSTImplemented INT
        )
        
        CREATE TABLE #tempTaxAmountGST
		(
		  I_Invoice_Detail_ID INT ,
		  Amount_Paid DECIMAL(14, 2) ,
		  Tax_Amount DECIMAL(14, 2) ,
		)

        INSERT  INTO #temp
        ( I_Student_Detail_ID ,
          S_Mobile_No ,
          S_Student_ID ,
          I_Roll_No ,
          S_Student_Name ,
          S_Invoice_No ,
          Dt_Invoice_Date ,
          I_Fee_Component_ID,
          S_Component_Name ,
		  I_Batch_ID,
          S_Batch_Name ,
          S_Course_Name ,
          I_Center_ID ,
          S_Center_Name ,
          TypeofCentre,
          S_Brand_Name ,
          S_Cost_Center ,
          Due_Value ,
          Dt_Installment_Date ,
          I_Installment_No ,
          I_Parent_Invoice_ID ,
          I_Invoice_Detail_ID ,
          Revised_Invoice_Date ,
          Tax_Value ,
          Total_Value,

		  Amount_Paid,
		  Tax_Paid,
		  Total_Paid,
		  Total_Due,

          IsGSTImplemented
        )
        SELECT  B.I_Invoice_Child_Header_ID ,
                E.S_Mobile_No ,
                S_Student_ID ,
                E.I_RollNo ,
                E.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                + S_Last_Name AS S_Student_Name ,
                A.S_Invoice_No ,
                A.Dt_Invoice_Date ,
                C.I_Fee_Component_ID,
                S_Component_Name ,
				tsbm.I_Batch_ID,
                tsbm.S_Batch_Name ,
                tcm.S_Course_Name ,
                tcm2.I_Centre_Id ,
                tcm2.S_Center_Name ,
                CASE WHEN tcm2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
                                WHEN tcm2.S_Center_Code LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN tcm2.S_Center_Code='BRST' THEN 'AIPT'
                                WHEN tcm2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                S_Brand_Name ,
                S_Cost_Center ,
                --C.N_Amount_Due Due_Value ,--susmita
				ISNULL((ISNULL(C.N_Amount_Due,0)-ISNULL(C.N_Discount_Amount,0)),0) Due_Value ,--susmita
                Dt_Installment_Date ,
                I_Installment_No ,
                A.I_Parent_Invoice_ID ,
                C.I_Invoice_Detail_ID ,
                CASE WHEN I_Parent_Invoice_ID IS NULL THEN NULL
                     ELSE A.Dt_Crtd_On
                END AS Revised_Invoice_Date ,
                0,--ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) Tax_Value ,
                --ISNULL(c.N_Amount_Due, 0) + 0, -- ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value,--susmita
				ISNULL((ISNULL(c.N_Amount_Due,0)-ISNULL(c.N_Discount_Amount,0)), 0) + 0, -- ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value,--susmita
				0.00,
				0.00,
				0.00,
				0.00,
                CASE WHEN DATEDIFF(dd, '2017-07-01', Dt_Installment_Date) >= 0 THEN 1
					 ELSE 0
				END
        FROM    T_Invoice_Parent A
                INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                INNER JOIN #tempinvoice ON #tempinvoice.I_Invoice_Header_ID = A.I_Invoice_Header_ID
                INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
				AND (A.I_Status IN (1,3,2 )
				OR 
				(A.I_Status=0 and C.I_Invoice_Detail_ID in(Select tc.I_Invoice_Detail_ID From T_Receipt_Component_Detail as tc 
				 Inner Join T_Receipt_Header as th on tc.I_Receipt_Detail_ID=th.I_Receipt_Header_ID 
				 AND ((C.Dt_Installment_Date<A.Dt_Upd_On and C.Dt_Installment_Date<th.Dt_Upd_On) or (C.Dt_Installment_Date>A.Dt_Upd_On)) 
				 and (((CASE WHEN C.Dt_Installment_Date>=th.Dt_Upd_On Then C.Dt_Installment_Date ELSE th.Dt_Upd_On END)>='2017-07-01')
				      or ((CASE WHEN A.Dt_Upd_On>=th.Dt_Upd_On Then A.Dt_Upd_On ELSE th.Dt_Upd_On END)>='2017-07-01'))
				 and tc.I_Invoice_Detail_ID not in(Select I_Invoice_Detail_ID From T_Credit_Note_Invoice_Child_Detail)))
				)
                INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID = C.I_Fee_Component_ID
                                                      AND D.I_Status = 1
                INNER JOIN T_Student_Detail E  WITH ( NOLOCK ) ON E.I_Student_Detail_ID = A.I_Student_Detail_ID
                INNER JOIN dbo.T_Centre_Master AS tcm2 WITH ( NOLOCK ) ON A.I_Centre_Id = tcm2.I_Centre_Id
                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm2.I_Centre_Id = tbcd.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
                OUTER APPLY ( SELECT TOP 1
                                        tsbd.I_Student_Batch_ID ,
                                        tsbd.I_Status ,
                                        tsbd.I_Batch_ID
                              FROM      dbo.T_Student_Batch_Details AS tsbd
                              WHERE     tsbd.I_Student_ID = a.I_Student_Detail_ID
                                        AND tsbd.I_Status IN (1,2)
                              ORDER BY  tsbd.I_Student_Batch_ID DESC
                            ) tsbd
                LEFT JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID
                LEFT JOIN dbo.T_Course_Master AS tcm ON tcm.I_Course_ID = tsbm.I_Course_ID
                --LEFT JOIN T_Invoice_Detail_Tax F ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
        WHERE   A.I_Centre_Id IN (
                SELECT  fnCenter.centerID
                FROM    fnGetCentersForReports(@sHierarchyList,@iBrandID) fnCenter )
                AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) <= 0
                AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)
                AND Isnull(C.Flag_IsAdvanceTax,'N') <> 'Y'
    --    GROUP BY B.I_Invoice_Child_Header_ID,
    --            S_Student_ID ,
    --            E.S_Mobile_No ,
    --            E.I_RollNo ,
    --            A.S_Invoice_No ,
    --            A.Dt_Invoice_Date ,
    --            C.I_Fee_Component_ID,
    --            S_Component_Name ,
    --            C.N_Amount_Due ,
    --            Dt_Installment_Date ,
    --            I_Installment_No ,
    --            A.I_Parent_Invoice_ID ,
    --            A.Dt_Crtd_On ,
    --            C.I_Invoice_Detail_ID ,
    --            tsbm.S_Batch_Name ,
    --            tcm.S_Course_Name ,
    --            tcm2.I_Centre_Id ,
    --            tcm2.S_Center_Name ,
    --            CASE WHEN tcm2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
    --                            WHEN tcm2.S_Center_Code LIKE 'Judiciary T%' THEN 'Judiciary'
    --                            WHEN tcm2.S_Center_Code='BRST' THEN 'AIPT'
    --                            WHEN tcm2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'
    --                            ELSE 'Own' END,
    --            S_Brand_Name ,
    --            S_Cost_Center ,
    --            E.S_First_Name ,
    --            E.S_Middle_Name ,
    --            E.S_Last_Name,
    --            CASE WHEN DATEDIFF(dd, '2017-07-01', Dt_Installment_Date) >= 0 THEN 1
				--	 ELSE 0
				--END
        
		UPDATE T
			SET T.Tax_Value = TA.Tax_Value
				,T.Total_Value = T.Total_Value + TA.Tax_Value
		FROM #temp T
		INNER JOIN (SELECT F.I_Invoice_Detail_ID,ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Tax_Value
				FROM  #temp C
					INNER JOIN T_Invoice_Detail_Tax F WITH (NOLOCK)  ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
					GROUP BY F.I_Invoice_Detail_ID) TA ON TA.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID

select * from #temp -- amount need to pay

        INSERT INTO #tempTaxAmountGST
		(
			I_Invoice_Detail_ID,
			Amount_Paid,
			Tax_Amount
		)		
		SELECT A.I_Invoice_Detail_ID, Amount_Paid, IsNull(Tax_Amount,0) AS Tax_Amount
		FROM(
				SELECT RCD.I_Invoice_Detail_ID,Sum(N_Amount_Paid) AS Amount_Paid
				FROM T_Receipt_Component_Detail RCD
				INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
				INNER JOIN #temp T ON RCD.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID AND IsGSTImplemented = 1
				AND DATEDIFF(dd, '2017-07-01', T.Dt_Installment_Date) >= 0
				And RH.I_Status = 1
				GROUP BY RCD.I_Invoice_Detail_ID
			) A
		LEFT JOIN ( SELECT RCD.I_Invoice_Detail_ID,SUM(N_Tax_Paid) AS Tax_Amount 
					FROM T_Receipt_Tax_Detail RTD 
					INNER JOIN T_Receipt_Component_Detail RCD ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
					INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
					INNER JOIN #temp T ON RCD.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID
					AND DATEDIFF(dd, '2017-07-01', T.Dt_Installment_Date) >= 0
					And RH.I_Status = 1
					GROUP BY RCD.I_Invoice_Detail_ID
				  )xx ON A.I_Invoice_Detail_ID = xx.I_Invoice_Detail_ID

		
		select * from #tempTaxAmountGST

		UPDATE #temp
		SET Tax_Value = (CASE WHEN (tmp.Due_Value - isnull(tmtaxAmt.Amount_Paid,0)) < 1 THEN tmtaxAmt.Tax_Amount
							  ELSE tmtaxAmt.Tax_Amount + (SELECT dbo.fnGetTaxAmtOnDue(tmp.I_Fee_Component_ID, tmp.Dt_Installment_Date, 
															(tmp.Due_Value - isnull(tmtaxAmt.Amount_Paid,0))))
						 END)
		FROM   #temp AS tmp
		INNER JOIN #tempTaxAmountGST AS tmtaxAmt ON tmp.I_Invoice_Detail_ID = tmtaxAmt.I_Invoice_Detail_ID

		UPDATE #temp SET Total_Value = isnull(Due_Value,0) + isnull(Tax_Value,0)
		  
        UPDATE  T1
        SET     T1.Amount_Paid = ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temp T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh 
                                    ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                    AND (I_Status <> 0 OR (I_Status=0 AND DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0))
                                    AND DATEDIFF(dd,Dt_Receipt_Date,@dtUptoDate) >= 0
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
           select * from #temp --amount paid 
			
        UPDATE  T1
        SET     T1.Total_Paid = ISNULL(T1.Amount_Paid, 0)
                + ROUND(ISNULL(T2.N_Tax_Paid, 0), 2) ,
                T1.Tax_Paid = ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)
        FROM    #temp T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh
                                    ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                    AND (I_Status <> 0 OR (I_Status=0 AND DATEDIFF(dd, @dtUptoDate, trh.Dt_Upd_On) > 0))
                                    AND DATEDIFF(dd, Dt_Receipt_Date, @dtUptoDate) >= 0
                                    INNER JOIN #temp T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                      
		select * from #temp --total paid			  

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
          I_Fee_Component_ID INT,
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
          Total_Due DECIMAL(14, 2),
          IsGSTImplemented INT
        )

        INSERT  INTO #temphistory
                ( I_Student_Detail_ID ,
                  S_Mobile_No ,
                  S_Student_ID ,
                  I_Roll_No ,
                  S_Student_Name ,
                  S_Invoice_No ,
                  Dt_Invoice_Date ,
                  I_Fee_Component_ID,
                  S_Component_Name ,
				  I_Batch_ID,
                  S_Batch_Name ,
                  S_Course_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  TypeofCentre,
                  S_Brand_Name ,
                  S_Cost_Center ,
                  Due_Value ,
                  Dt_Installment_Date ,
                  I_Installment_No ,
                  I_Parent_Invoice_ID ,
                  I_Invoice_Detail_ID ,
                  Revised_Invoice_Date ,
                  Tax_Value ,
                  Total_Value,

				  Amount_Paid,
			      Tax_Paid,
			      Total_Paid,
			      Total_Due,

                  IsGSTImplemented
                )
                SELECT  B.I_Invoice_Child_Header_ID ,
                        E.S_Mobile_No ,
                        S_Student_ID ,
                        E.I_RollNo ,
                        E.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                        + S_Last_Name AS S_Student_Name ,
                        A.S_Invoice_No ,
                        A.Dt_Invoice_Date ,
                        C.I_Fee_Component_ID,
                        S_Component_Name ,
						tsbm.I_Batch_ID,
                        tsbm.S_Batch_Name ,
                        tcm.S_Course_Name ,
                        tcm2.I_Centre_Id ,
                        tcm2.S_Center_Name ,
                        CASE WHEN tcm2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
                                WHEN tcm2.S_Center_Code LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN tcm2.S_Center_Code='BRST' THEN 'AIPT'
                                WHEN tcm2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                        --TypeofCentre,
                        S_Brand_Name ,
                        S_Cost_Center ,
                      --  C.N_Amount_Due Due_Value ,--susmita
					    ISNULL((ISNULL(C.N_Amount_Due,0)-ISNULL(C.N_Discount_Amount,0)),0) Due_Value ,--susmita
                        Dt_Installment_Date ,
                        I_Installment_No ,
                        A.I_Parent_Invoice_ID ,
                        C.I_Invoice_Detail_ID ,
                        CASE WHEN I_Parent_Invoice_ID IS NULL THEN NULL
                             ELSE A.Dt_Crtd_On
                        END AS Revised_Invoice_Date ,
                        0, --ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) Tax_Value ,
						--ISNULL(c.N_Amount_Due, 0) + 0, -- ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value,
                        ISNULL((ISNULL(c.N_Amount_Due,0)-ISNULL(c.N_Discount_Amount,0)), 0) + 0, -- ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Total_Value,--susmita

						0.00,
					    0.00,
					    0.00,
					    0.00,

                        CASE WHEN DATEDIFF(dd, '2017-07-01', Dt_Installment_Date) >= 0 THEN 1
							 ELSE 0
						END
                FROM    T_Invoice_Parent A
                        INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                                                               AND A.I_Status=0
                        INNER JOIN #tempinvoice ON #tempinvoice.I_Invoice_Header_ID = A.I_Invoice_Header_ID
                        INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
                        INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID = C.I_Fee_Component_ID
                                                              AND D.I_Status = 1
                        INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID = A.I_Student_Detail_ID
                        INNER JOIN dbo.T_Centre_Master AS tcm2 ON A.I_Centre_Id = tcm2.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm2.I_Centre_Id = tbcd.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
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
                        --LEFT JOIN T_Invoice_Detail_Tax F ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
                WHERE   A.I_Centre_Id IN (SELECT fnCenter.centerID FROM fnGetCentersForReports(@sHierarchyList, @iBrandID) fnCenter )
                        AND DATEDIFF(dd, @dtUptoDate, Dt_Installment_Date) <= 0
                        AND E.I_Status = ISNULL(@StudentStatus, E.I_Status)
                        AND DATEDIFF(dd, @dtUptoDate, A.Dt_Upd_On) > 0          
                        AND Isnull(C.Flag_IsAdvanceTax,'N') <> 'Y'  
						
				
				        
      --          GROUP BY B.I_Invoice_Child_Header_ID ,
      --                  S_Student_ID ,
      --                  E.S_Mobile_No ,
      --                  E.I_RollNo ,
      --                  A.S_Invoice_No ,
      --                  A.Dt_Invoice_Date ,
      --                  C.I_Fee_Component_ID,
      --                  S_Component_Name ,
      --                  C.N_Amount_Due ,
      --                  Dt_Installment_Date ,
      --                  I_Installment_No ,
      --                  A.I_Parent_Invoice_ID ,
      --                  A.Dt_Crtd_On ,
      --                  C.I_Invoice_Detail_ID ,
      --                  tsbm.S_Batch_Name ,
      --                  tcm.S_Course_Name ,
      --                  tcm2.I_Centre_Id ,
      --                  tcm2.S_Center_Name ,
      --                  CASE WHEN tcm2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
      --                          WHEN tcm2.S_Center_Code LIKE 'Judiciary T%' THEN 'Judiciary'
      --                          WHEN tcm2.S_Center_Code='BRST' THEN 'AIPT'
      --                          WHEN tcm2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'
      --                          ELSE 'Own' END,
      --                  S_Brand_Name ,
      --                  S_Cost_Center ,
      --                  E.S_First_Name ,
      --                  E.S_Middle_Name ,
      --                  E.S_Last_Name,
      --                  CASE WHEN DATEDIFF(dd, '2017-07-01', Dt_Installment_Date) >= 0 THEN 1
						--	 ELSE 0
						--END
		

		UPDATE T
			SET T.Tax_Value = TA.Tax_Value
				,T.Total_Value = T.Total_Value + TA.Tax_Value
		FROM #temphistory T
		INNER JOIN (SELECT F.I_Invoice_Detail_ID,ISNULL(SUM(ROUND(F.N_Tax_Value, 2)), 0) AS Tax_Value
				FROM  #temphistory C
					INNER JOIN T_Invoice_Detail_Tax F WITH (NOLOCK)  ON F.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID
					GROUP BY F.I_Invoice_Detail_ID) TA ON TA.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID
				
		INSERT INTO #tempTaxAmountGST
		(
			I_Invoice_Detail_ID,
			Amount_Paid,
			Tax_Amount
		)		
		SELECT A.I_Invoice_Detail_ID, Amount_Paid, IsNull(Tax_Amount,0) AS Tax_Amount
		FROM(
				SELECT RCD.I_Invoice_Detail_ID,Sum(N_Amount_Paid) AS Amount_Paid
				FROM T_Receipt_Component_Detail RCD
				INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
				INNER JOIN #temphistory T ON RCD.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID AND IsGSTImplemented = 1
				AND DATEDIFF(dd, '2017-07-01', T.Dt_Installment_Date) >= 0
				And RH.I_Status = 1
				GROUP BY RCD.I_Invoice_Detail_ID
			) A
		LEFT JOIN ( SELECT RCD.I_Invoice_Detail_ID,SUM(N_Tax_Paid) AS Tax_Amount 
					FROM T_Receipt_Tax_Detail RTD 
					INNER JOIN T_Receipt_Component_Detail RCD ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
					INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
					INNER JOIN #temphistory T ON RCD.I_Invoice_Detail_ID = T.I_Invoice_Detail_ID
					AND DATEDIFF(dd, '2017-07-01', T.Dt_Installment_Date) >= 0
					And RH.I_Status = 1
					GROUP BY RCD.I_Invoice_Detail_ID
				  )xx ON A.I_Invoice_Detail_ID = xx.I_Invoice_Detail_ID
		select * from #tempTaxAmountGST
		UPDATE #temphistory
		SET Tax_Value = (CASE WHEN (tmp.Due_Value - isnull(tmtaxAmt.Amount_Paid,0)) < 1 THEN tmtaxAmt.Tax_Amount
							  ELSE tmtaxAmt.Tax_Amount + (SELECT dbo.fnGetTaxAmtOnDue(tmp.I_Fee_Component_ID, tmp.Dt_Installment_Date, 
															(tmp.Due_Value - isnull(tmtaxAmt.Amount_Paid,0))))
						 END)
		FROM   #temphistory AS tmp
		INNER JOIN #tempTaxAmountGST AS tmtaxAmt ON tmp.I_Invoice_Detail_ID = tmtaxAmt.I_Invoice_Detail_ID
		
		UPDATE #temphistory SET Total_Value = isnull(Due_Value,0) + isnull(Tax_Value,0)
   select * from #temphistory
  
        UPDATE  T1
        SET     T1.Amount_Paid = ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   dbo.T_Receipt_Component_Detail_Archive A
                                    INNER JOIN dbo.T_Receipt_Header_Archive AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              AND DATEDIFF(dd, Dt_Receipt_Date, @dtUptoDate) >= 0
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND ( tip.Dt_Upd_On IS NULL
                                                              OR (DATEDIFF(dd,@dtUptoDate,tip.Dt_Upd_On) > 0 AND DATEDIFF(dd,'2017-06-30',tip.Dt_Upd_On) <=0)
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
                                                              AND DATEDIFF(dd,Dt_Receipt_Date,@dtUptoDate) >= 0
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON trh.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND ( tip.Dt_Upd_On IS NULL
                                                              OR (DATEDIFF(dd,@dtUptoDate,tip.Dt_Upd_On) > 0 AND DATEDIFF(dd,'2017-06-30',tip.Dt_Upd_On) <=0)
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail_Archive
                                    AS trtd ON A.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
            select * from #temphistory                 
          
        UPDATE  T1
        SET     T1.Amount_Paid = isnull(T1.Amount_Paid,0)+ ISNULL(ROUND(T2.Amount_Paid, 2), 0)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(N_Amount_Paid) Amount_Paid
                             FROM   dbo.T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              --AND I_Status <> 0 
                                                              AND DATEDIFF(dd,Dt_Receipt_Date,@dtUptoDate) >= 0
                                                              AND ( trh.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0
                                                              OR  I_Status=1
                                                              )
                                    INNER JOIN #temphistory T ON T.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
                             GROUP BY A.I_Invoice_Detail_ID
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
           select * from #temphistory                  
        UPDATE  T1
        SET
                T1.Tax_Paid =ISNULL(T1.Tax_Paid,0)+ ROUND(ISNULL(T2.N_Tax_Paid, 0), 2)
        FROM    #temphistory T1
                INNER JOIN ( SELECT A.I_Invoice_Detail_ID ,
                                    SUM(ISNULL(trtd.N_Tax_Paid, 0)) N_Tax_Paid
                             FROM   T_Receipt_Component_Detail A
                                    INNER JOIN dbo.T_Receipt_Header AS trh ON A.I_Receipt_Detail_ID = trh.I_Receipt_Header_ID
                                                              AND DATEDIFF(dd,Dt_Receipt_Date,@dtUptoDate) >= 0
                                                              AND ( trh.Dt_Upd_On IS NULL
                                                              OR DATEDIFF(dd,@dtUptoDate,trh.Dt_Upd_On) > 0
                                                              OR  I_Status=1
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
        
          select * from #temphistory
        INSERT  INTO #temp
                ( I_Student_Detail_ID ,
                  S_Mobile_No ,
                  S_Student_ID ,
                  I_Roll_No ,
                  S_Student_Name ,
                  S_Invoice_No ,
                  S_Receipt_No ,
                  Dt_Invoice_Date ,
                  I_Fee_Component_ID,
                  S_Component_Name ,
				  I_Batch_ID,
                  S_Batch_Name ,
                  S_Course_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  TypeofCentre,
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
                  Total_Due,
                  IsGSTImplemented
                )
                SELECT DISTINCT  I_Student_Detail_ID ,
                        S_Mobile_No ,
                        S_Student_ID ,
                        I_Roll_No ,
                        S_Student_Name ,
                        S_Invoice_No ,
                        S_Receipt_No ,
                        Dt_Invoice_Date ,
                        I_Fee_Component_ID,
                        S_Component_Name ,
						I_Batch_ID,
                        S_Batch_Name ,
                        S_Course_Name ,
                        I_Center_ID ,
                        S_Center_Name ,
                        TypeofCentre,
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
                        Total_Due,
                        IsGSTImplemented
                FROM    #temphistory
        
        
        UPDATE  #temp
        SET     Total_Due = ISNULL(Total_Value, 0) - ISNULL(Total_Paid, 0)
        
        --------------***********----------------------
     
    
		SELECT DISTINCT  T.I_Student_Detail_ID , T.S_Mobile_No ,T.S_Student_ID ,T.I_Roll_No ,T.S_Student_Name ,T.S_Invoice_No ,T.S_Receipt_No ,
				T.Dt_Invoice_Date ,T.I_Fee_Component_ID,T.S_Component_Name ,T.I_Batch_ID,
				REPLACE(REPLACE(REPLACE(T.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') as S_Batch_Name ,
				T.S_Course_Name ,T.I_Center_ID ,
				T.S_Center_Name ,T.TypeofCentre,T.S_Brand_Name ,T.S_Cost_Center ,T.Due_Value ,T.Dt_Installment_Date ,T.I_Installment_No ,
				T.I_Parent_Invoice_ID ,T.I_Invoice_Detail_ID ,T.Revised_Invoice_Date ,T.Tax_Value ,T.Total_Value ,T.Amount_Paid ,
				T.Tax_Paid ,T.Total_Paid ,T.Total_Due,T.IsGSTImplemented ,
				CAST(DATEDIFF(d,T.Dt_Installment_Date,GETDATE()) AS INT) AS Age,
				FN2.instanceChain
		FROM    #temp T
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1 ON T.I_Center_ID = FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
		WHERE ISNULL(Total_Due, 0)>0
		ORDER BY S_Center_Name,	S_Batch_Name, I_Roll_NO;
		
		DROP TABLE #temp
		DROP TABLE #tempinvoice
		DROP TABLE #tempinvoicedt
		DROP TABLE #temphistory
		DROP TABLE #tempTaxAmountGST
	
END
