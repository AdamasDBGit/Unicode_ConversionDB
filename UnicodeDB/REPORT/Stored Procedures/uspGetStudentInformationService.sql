CREATE PROCEDURE [REPORT].[uspGetStudentInformationService]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @sStudentID VARCHAR(MAX)
    )
    --1516/RICE/378
AS 
    BEGIN
    
    
        DECLARE @InvID INT
    
        IF ( @iBrandID = 109
             OR @iBrandID = 111
           ) 
            BEGIN

                SELECT  DISTINCT
                        TSD.I_Student_Detail_ID AS iStudentDetailID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        CONVERT(DATE, TSD.Dt_Crtd_On) AS AdmDate ,
                        TSD.I_RollNo ,
                        CONVERT(DATE, TSD.Dt_Birth_Date) AS DOB ,
                        TERD.S_Father_Name ,
                        TERD.S_Mother_Name ,
                        TSD.S_Mobile_No ,
                        TSD.S_Phone_No ,
                        TSD.S_Email_ID ,
                        ISNULL(TERD.S_Second_Language_Opted, '') AS SecondLanguageOpted ,
                        TERD.S_Age ,
                        THM2.S_House_Name ,
                --TSD.S_Guardian_Mobile_No,
                        TSD.S_Guardian_Phone_No ,
                        TSD.S_Curr_Address1 ,
                        TSM.S_State_Name ,
                        TCM2.S_City_Name ,
                        TSD.S_Curr_Pincode ,
                        TCM3.S_Caste_Name ,
                        TUS.S_Sex_Name ,
                        TUR.S_Religion_Name ,
                        TBG.S_Blood_Group ,
                        TMS.S_Marital_Status ,
                        T7.S_PickupPoint_Name ,
                        T7.S_Route_No ,
                        TCM.S_Course_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name+' ('+TCHND.S_Center_Name+')' AS S_Batch_Name ,
                --TIP.S_Invoice_No,
                        T2.CourseAmount ,
                        T2.ServiceTax ,
                        T2.TotalCourseAmount ,
                        T1.AmountPaid ,
                --ISNULL(T2.TotalCourseAmount, 0.0) - ISNULL(T1.AmountPaid, 0.0) AS AmountDue ,
                        ISNULL(T2.TotalCourseAmount, 0.0)
                        - ISNULL(T1.AmountPaid, 0.0) AS AmountDue ,
                        T1.LastPaymentDate ,
                        T3.TotalClassAllotted ,
                        T4.TotalAttendedClasses ,
                        CAST(( CAST(T4.TotalAttendedClasses AS DECIMAL(14, 2))
                               / CAST(T3.TotalClassAllotted AS DECIMAL(14, 2))
                               * 100 ) AS DECIMAL(14, 2)) AS OverallPercentage ,
                        CAST(( ( CAST(( T3.TotalClassAllotted
                                        - T4.TotalAttendedClasses ) AS DECIMAL(14,
                                                              2))
                                 / CAST(T3.TotalClassAllotted AS DECIMAL(14, 2)) )
                               * 100 ) AS DECIMAL(14, 2)) AS AbsentPercentage ,
                        T5.LastClassDate ,
                        TERD.S_Student_Photo ,
                        CASE WHEN TSBM.Dt_BatchStartDate > GETDATE()
                             THEN 'Waiting'
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()
                                  AND ( T4.TotalAttendedClasses IS NULL
                                        OR T4.TotalAttendedClasses = 0
                                      ) THEN 'Waiting'
                             WHEN ( ISNULL(T2.TotalCourseAmount, 0.0)
                                    - ISNULL(T1.AmountPaid, 0.0) ) > 100.00
                             THEN 'DEFAULTER'
                             WHEN DATEDIFF(d, T5.LastClassDate, GETDATE()) > 30
                             THEN 'DROPOUT'
                             WHEN TSD.I_Status = 0 THEN 'INACTIVE'
                             WHEN TSD.I_Status = 1 THEN 'ACTIVE'
                        END AS CurrentStatus
                FROM    dbo.T_Student_Detail TSD
                        INNER JOIN dbo.T_Student_Course_Detail TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_Detail_ID
                --( SELECT T1.I_Student_ID ,
                --                    T2.I_Batch_ID
                --             FROM   ( SELECT    TSBD2.I_Student_ID ,
                --                                MAX(TSBD2.I_Student_Batch_ID) AS ID
                --                      FROM      dbo.T_Student_Batch_Details TSBD2
                --                      WHERE     TSBD2.I_Status IN ( 1 )
                --                      GROUP BY  TSBD2.I_Student_ID
                --                    ) T1
                --                    INNER JOIN ( SELECT TSBD3.I_Student_ID ,
                --                                        TSBD3.I_Student_Batch_ID AS ID ,
                --                                        TSBD3.I_Batch_ID
                --                                 FROM   dbo.T_Student_Batch_Details TSBD3
                --                                 WHERE  TSBD3.I_Status IN ( 1 )
                --                               ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                --                                       AND T1.ID = T2.ID
                --           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN ( SELECT InvAmt.I_Student_Detail_ID ,
                                            InvAmt.CourseAmount ,
                                            InvTax.ServiceTax ,
                                            SUM(InvAmt.CourseAmount
                                                + InvTax.ServiceTax) AS TotalCourseAmount
                                     FROM   ( SELECT    TSD2.I_Student_Detail_ID ,
                                                        SUM(TICD.N_Amount_Due) AS CourseAmount
                                              FROM      dbo.T_Invoice_Parent TIP2
                                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                        INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                    --LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                              WHERE     TIP2.I_Status IN ( 1,
                                                              3 ) 
                             --AND TICD.Dt_Installment_Date<=GETDATE()
                                              GROUP BY  TSD2.I_Student_Detail_ID
                                            ) InvAmt
                                            LEFT JOIN ( SELECT
                                                              TSD2.I_Student_Detail_ID ,
                                                              SUM(ISNULL(TIDT.N_Tax_Value,
                                                              0.0)) AS ServiceTax
                                                        FROM  dbo.T_Invoice_Parent TIP2
                                                              INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                              INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                              LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                                        WHERE TIP2.I_Status IN (
                                                              1, 3 ) 
                             --AND TICD.Dt_Installment_Date<=GETDATE()
                                                        GROUP BY TSD2.I_Student_Detail_ID
                                                      ) InvTax ON InvAmt.I_Student_Detail_ID = InvTax.I_Student_Detail_ID
                                     GROUP BY InvAmt.I_Student_Detail_ID ,
                                            InvAmt.CourseAmount ,
                                            InvTax.ServiceTax
                                   ) T2 ON T2.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  BaseAmtPaid.I_Student_Detail_ID ,
                                            BaseAmtPaid.BaseAmtPaid ,
                                            TaxAmtPaid.TaxAmtPaid ,
                                            BaseAmtPaid.LastPaymentDate ,
                                            SUM(BaseAmtPaid.BaseAmtPaid
                                                + TaxAmtPaid.TaxAmtPaid) AS Amountpaid
                                    FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                                                        SUM(ISNULL(TRCD.N_Amount_Paid,
                                                              0.0)) AS BaseAmtPaid ,
                                                        MAX(CONVERT(DATE, TRH.Dt_Receipt_Date)) AS LastPaymentDate
                                              FROM      dbo.T_Receipt_Header TRH
                                                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                        INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                        INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                              WHERE     TRH.I_Status = 1
                                                        AND TRH.I_Invoice_Header_ID IS NOT NULL
                                                        AND TIP.I_Status IN (
                                                        1, 3 )
                                                --AND TSD.I_Student_Detail_ID = 48508
                                              GROUP BY  TSD.I_Student_Detail_ID
                                            ) BaseAmtPaid
                                            LEFT JOIN ( SELECT
                                                              TSD.I_Student_Detail_ID ,
                                                              SUM(ISNULL(TRTD.N_Tax_Paid,
                                                              0.0)) AS TaxAmtPaid
                                                        FROM  dbo.T_Receipt_Header TRH
                                                              INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                              INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                                              LEFT JOIN dbo.T_Receipt_Tax_Detail TRTD ON TRCD.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                                                        WHERE TRH.I_Status = 1
                                                              AND TRH.I_Invoice_Header_ID IS NOT NULL
                                                              AND TIP.I_Status IN (
                                                              1, 3 )
                                                        --AND TSD.I_Student_Detail_ID = 48508
                                                        GROUP BY TSD.I_Student_Detail_ID
                                                      ) TaxAmtPaid ON BaseAmtPaid.I_Student_Detail_ID = TaxAmtPaid.I_Student_Detail_ID
                                    GROUP BY BaseAmtPaid.I_Student_Detail_ID ,
                                            BaseAmtPaid.BaseAmtPaid ,
                                            TaxAmtPaid.TaxAmtPaid ,
                                            BaseAmtPaid.LastPaymentDate
                                  ) T1 ON T1.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN dbo.T_Enquiry_Qualification_Details TEQD ON TERD.I_Enquiry_Regn_ID = TEQD.I_Enquiry_Regn_ID
                                                              AND TSD.I_Enquiry_Regn_ID = TEQD.I_Enquiry_Regn_ID
                        LEFT JOIN dbo.T_City_Master TCM2 ON TSD.I_Curr_City_ID = TCM2.I_City_ID
                        LEFT JOIN dbo.T_User_Sex TUS ON TERD.I_Sex_ID = TUS.I_Sex_ID
                        LEFT JOIN dbo.T_Blood_Group TBG ON TERD.I_Blood_Group_ID = TBG.I_Blood_Group_ID
                        LEFT JOIN dbo.T_User_Religion TUR ON TERD.I_Religion_ID = TUR.I_Religion_ID
                        LEFT JOIN dbo.T_Marital_Status TMS ON TERD.I_Marital_Status_ID = TMS.I_Marital_Status_ID
                        LEFT JOIN dbo.T_Caste_Master TCM3 ON TERD.I_Caste_ID = TCM3.I_Caste_ID
                        LEFT JOIN dbo.T_State_Master TSM ON TSD.I_Curr_State_ID = TSM.I_State_ID
                        LEFT JOIN T_House_Master THM2 ON TSD.I_House_ID = THM2.I_House_ID
                        LEFT JOIN ( SELECT  TTTM.I_Batch_ID ,
                                            ISNULL(COUNT(TTTM.I_TimeTable_ID),
                                                   0.0) AS TotalClassAllotted 
                                    --MAX(CONVERT(DATE, TTTM.Dt_Schedule_Date)) AS LastClassDate
                                    FROM    dbo.T_TimeTable_Master TTTM
                            --LEFT JOIN dbo.T_Student_Attendance TSA ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TTTM.I_Batch_ID
                                  ) T3 ON T3.I_Batch_ID = TSBD.I_Batch_ID
                        LEFT JOIN ( SELECT  TSA.I_Student_Detail_ID ,
                                            MAX(TTTM.Dt_Schedule_Date) AS LastClassDate
                                    FROM    dbo.T_Student_Attendance TSA
                                            INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TSA.I_Student_Detail_ID
                                  ) T5 ON T5.I_Student_Detail_ID = T1.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  TSD2.I_Student_Detail_ID ,
                                            TTTM.I_Batch_ID ,
                                            ISNULL(COUNT(DISTINCT TSA.I_TimeTable_ID),
                                                   0.0) AS TotalAttendedClasses
                                    FROM    dbo.T_Student_Attendance TSA
                                            INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                            INNER JOIN dbo.T_Student_Detail TSD2 ON TSA.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TSD2.I_Student_Detail_ID ,
                                            TTTM.I_Batch_ID
                                  ) T4 ON T4.I_Batch_ID = TSBD.I_Batch_ID
                                          AND T4.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        --LEFT JOIN ( SELECT  InvAmt.I_Student_Detail_ID ,
                        --                    InvAmt.AsOnDateCourseAmount ,
                        --                    InvTax.AsOnDateServiceTax ,
                        --                    SUM(InvAmt.AsOnDateCourseAmount
                        --                        + InvTax.AsOnDateServiceTax) AS AsOnDateTotalCourseAmount
                        --            FROM    ( SELECT    TSD2.I_Student_Detail_ID ,
                        --                                SUM(TICD.N_Amount_Due) AS AsOnDateCourseAmount
                        --                      FROM      dbo.T_Invoice_Parent TIP2
                        --                                INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        --                                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        --                                INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                        --            --LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                        --                      WHERE     TIP2.I_Status IN ( 1,
                        --                                      3 )
                        --                                AND TICD.Dt_Installment_Date <= GETDATE()
                        --                      GROUP BY  TSD2.I_Student_Detail_ID
                        --                    ) InvAmt
                        --                    LEFT JOIN ( SELECT
                        --                                      TSD2.I_Student_Detail_ID ,
                        --                                      SUM(ISNULL(TIDT.N_Tax_Value,
                        --                                      0.0)) AS AsOnDateServiceTax
                        --                                FROM  dbo.T_Invoice_Parent TIP2
                        --                                      INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        --                                      INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        --                                      INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                        --                                      LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                        --                                WHERE TIP2.I_Status IN (
                        --                                      1, 3 )
                        --                                      AND TICD.Dt_Installment_Date <= GETDATE()
                        --                                GROUP BY TSD2.I_Student_Detail_ID
                        --                              ) InvTax ON InvAmt.I_Student_Detail_ID = InvTax.I_Student_Detail_ID
                        --            GROUP BY InvAmt.I_Student_Detail_ID ,
                        --                    InvAmt.AsOnDateCourseAmount ,
                        --                    InvTax.AsOnDateServiceTax
                        --          ) T6 ON T6.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  DISTINCT
                                            TBRM.S_Route_No ,
                                            TSD.I_Student_Detail_ID ,
                                            TSD.S_Student_ID ,
                                            TTM.S_PickupPoint_Name ,
                                            TTM.N_Fees
                                    FROM    dbo.T_Student_Detail TSD
                                            INNER JOIN ( SELECT
                                                              I_Student_Detail_ID ,
                                                              I_Route_ID ,
                                                              I_PickupPoint_ID ,
                                                              Dt_Crtd_On ,
                                                              DENSE_RANK() OVER ( PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC ) AS RankID
                                                         FROM dbo.T_Student_Transport_History TSTH
                                                       ) XX ON TSD.I_Student_Detail_ID = XX.I_Student_Detail_ID
                                                              AND RankID = 1
                                            INNER JOIN dbo.T_BusRoute_Master TBRM ON XX.I_Route_ID = TBRM.I_Route_ID
                                            INNER JOIN dbo.T_Transport_Master TTM ON XX.I_PickupPoint_ID = TTM.I_PickupPoint_ID
                                                              AND TBRM.I_Brand_ID = @iBrandID
                                            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                            INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                            INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                    WHERE   TBRM.I_Status = 1
                                            AND TTM.I_Status = 1
                                            AND TFCM.S_Component_Code = 'TF' --AND TSD.I_Student_Detail_ID=55735
                                    
                                  ) T7 ON T7.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE   TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND TSD.S_Student_ID = @sStudentID
                --AND TIP.I_Status IN (1,3)
                
            END
               
        ELSE 
            BEGIN
               
                SET @InvID = ( SELECT   TIP.I_Invoice_Header_ID
                               FROM     dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Student_Course_Detail TSCD ON TICH.I_Course_ID = TSCD.I_Course_ID
                                                              AND TIP.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                               WHERE    TSD.S_Student_ID = @sStudentID
                                        AND TIP.I_Status IN ( 1, 3 )
                             )
               
               
               
                SELECT  DISTINCT
                        TSD.I_Student_Detail_ID AS iStudentDetailID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        CONVERT(DATE, TSD.Dt_Crtd_On) AS AdmDate ,
                        TSD.I_RollNo ,
                        CONVERT(DATE, TSD.Dt_Birth_Date) AS DOB ,
                        TERD.S_Father_Name ,
                        TERD.S_Mother_Name ,
                        TSD.S_Mobile_No ,
                        TSD.S_Phone_No ,
                        TSD.S_Email_ID ,
                        ISNULL(TERD.S_Second_Language_Opted, '') AS SecondLanguageOpted ,
                        TERD.S_Age ,
                        THM2.S_House_Name ,
                --TSD.S_Guardian_Mobile_No,
                        TSD.S_Guardian_Phone_No ,
                        TSD.S_Curr_Address1 ,
                        TSM.S_State_Name ,
                        TCM2.S_City_Name ,
                        TSD.S_Curr_Pincode ,
                        TCM3.S_Caste_Name ,
                        TUS.S_Sex_Name ,
                        TUR.S_Religion_Name ,
                        TBG.S_Blood_Group ,
                        TMS.S_Marital_Status ,
                        TCM.S_Course_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        T7.S_PickupPoint_Name ,
                        T7.S_Route_No ,
                --TIP.S_Invoice_No,
                        T2.CourseAmount ,
                        T2.ServiceTax ,
                        T2.TotalCourseAmount ,
                        T1.AmountPaid ,
                --ISNULL(T2.TotalCourseAmount, 0.0) - ISNULL(T1.AmountPaid, 0.0) AS AmountDue ,
                        ISNULL(T6.AsOnDateTotalCourseAmount, 0.0)
                        - ISNULL(T1.AmountPaid, 0.0) AS AmountDue ,
                        T1.LastPaymentDate ,
                        T3.TotalClassAllotted ,
                        T4.TotalAttendedClasses ,
                        CAST(( CAST(T4.TotalAttendedClasses AS DECIMAL(14, 2))
                               / CAST(T3.TotalClassAllotted AS DECIMAL(14, 2))
                               * 100 ) AS DECIMAL(14, 2)) AS OverallPercentage ,
                        CAST(( ( CAST(( T3.TotalClassAllotted
                                        - T4.TotalAttendedClasses ) AS DECIMAL(14,
                                                              2))
                                 / CAST(T3.TotalClassAllotted AS DECIMAL(14, 2)) )
                               * 100 ) AS DECIMAL(14, 2)) AS AbsentPercentage ,
                        T5.LastClassDate ,
                        TERD.S_Student_Photo ,
                        CASE WHEN ( ISNULL(T6.AsOnDateTotalCourseAmount, 0.0)
                                    - ISNULL(T1.AmountPaid, 0.0) ) > 100.00
                             THEN 'DEFAULTER'
                             WHEN DATEDIFF(d, T5.LastClassDate, GETDATE()) > 30
                             THEN 'DROPOUT'
                             WHEN TSD.I_Status = 0 THEN 'INACTIVE'
                             WHEN TSD.I_Status = 1 THEN 'ACTIVE'
                        END AS CurrentStatus
                FROM    dbo.T_Student_Detail TSD
                        INNER JOIN dbo.T_Student_Course_Detail TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_Detail_ID
                --( SELECT T1.I_Student_ID ,
                --                    T2.I_Batch_ID
                --             FROM   ( SELECT    TSBD2.I_Student_ID ,
                --                                MAX(TSBD2.I_Student_Batch_ID) AS ID
                --                      FROM      dbo.T_Student_Batch_Details TSBD2
                --                      WHERE     TSBD2.I_Status IN ( 1 )
                --                      GROUP BY  TSBD2.I_Student_ID
                --                    ) T1
                --                    INNER JOIN ( SELECT TSBD3.I_Student_ID ,
                --                                        TSBD3.I_Student_Batch_ID AS ID ,
                --                                        TSBD3.I_Batch_ID
                --                                 FROM   dbo.T_Student_Batch_Details TSBD3
                --                                 WHERE  TSBD3.I_Status IN ( 1 )
                --                               ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                --                                       AND T1.ID = T2.ID
                --           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN ( SELECT InvAmt.I_Student_Detail_ID ,
                                            InvAmt.CourseAmount ,
                                            InvTax.ServiceTax ,
                                            SUM(InvAmt.CourseAmount
                                                + InvTax.ServiceTax) AS TotalCourseAmount
                                     FROM   ( SELECT    TSD2.I_Student_Detail_ID ,
                                                        SUM(TICD.N_Amount_Due) AS CourseAmount
                                              FROM      dbo.T_Invoice_Parent TIP2
                                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                        INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                    --LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                              WHERE     TIP2.I_Status IN ( 1,
                                                              3 )
                                                        AND TIP2.I_Invoice_Header_ID = @InvID 
                             --AND TICD.Dt_Installment_Date<=GETDATE()
                                              GROUP BY  TSD2.I_Student_Detail_ID
                                            ) InvAmt
                                            LEFT JOIN ( SELECT
                                                              TSD2.I_Student_Detail_ID ,
                                                              SUM(ISNULL(TIDT.N_Tax_Value,
                                                              0.0)) AS ServiceTax
                                                        FROM  dbo.T_Invoice_Parent TIP2
                                                              INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                              INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                              LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                                        WHERE TIP2.I_Status IN (
                                                              1, 3 )
                                                              AND TIP2.I_Invoice_Header_ID = @InvID 
                             --AND TICD.Dt_Installment_Date<=GETDATE()
                                                        GROUP BY TSD2.I_Student_Detail_ID
                                                      ) InvTax ON InvAmt.I_Student_Detail_ID = InvTax.I_Student_Detail_ID
                                     GROUP BY InvAmt.I_Student_Detail_ID ,
                                            InvAmt.CourseAmount ,
                                            InvTax.ServiceTax
                                   ) T2 ON T2.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  BaseAmtPaid.I_Student_Detail_ID ,
                                            BaseAmtPaid.BaseAmtPaid ,
                                            TaxAmtPaid.TaxAmtPaid ,
                                            BaseAmtPaid.LastPaymentDate ,
                                            SUM(BaseAmtPaid.BaseAmtPaid
                                                + TaxAmtPaid.TaxAmtPaid) AS Amountpaid
                                    FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                                                        SUM(ISNULL(TRCD.N_Amount_Paid,
                                                              0.0)) AS BaseAmtPaid ,
                                                        MAX(CONVERT(DATE, TRH.Dt_Receipt_Date)) AS LastPaymentDate
                                              FROM      dbo.T_Receipt_Header TRH
                                                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                        INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                        INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                              WHERE     TRH.I_Status = 1
                                                        AND TIP.I_Invoice_Header_ID = @InvID
                                                        AND TIP.I_Status IN (
                                                        1, 3 )
                                                --AND TSD.I_Student_Detail_ID = 48508
                                              GROUP BY  TSD.I_Student_Detail_ID
                                            ) BaseAmtPaid
                                            LEFT JOIN ( SELECT
                                                              TSD.I_Student_Detail_ID ,
                                                              SUM(ISNULL(TRTD.N_Tax_Paid,
                                                              0.0)) AS TaxAmtPaid
                                                        FROM  dbo.T_Receipt_Header TRH
                                                              INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                              INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                              AND TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                                              LEFT JOIN dbo.T_Receipt_Tax_Detail TRTD ON TRCD.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                                                        WHERE TRH.I_Status = 1
                                                              AND TIP.I_Invoice_Header_ID = @InvID
                                                              AND TIP.I_Status IN (
                                                              1, 3 )
                                                        --AND TSD.I_Student_Detail_ID = 48508
                                                        GROUP BY TSD.I_Student_Detail_ID
                                                      ) TaxAmtPaid ON BaseAmtPaid.I_Student_Detail_ID = TaxAmtPaid.I_Student_Detail_ID
                                    GROUP BY BaseAmtPaid.I_Student_Detail_ID ,
                                            BaseAmtPaid.BaseAmtPaid ,
                                            TaxAmtPaid.TaxAmtPaid ,
                                            BaseAmtPaid.LastPaymentDate
                                  ) T1 ON T1.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN dbo.T_Enquiry_Qualification_Details TEQD ON TERD.I_Enquiry_Regn_ID = TEQD.I_Enquiry_Regn_ID
                                                              AND TSD.I_Enquiry_Regn_ID = TEQD.I_Enquiry_Regn_ID
                        LEFT JOIN dbo.T_City_Master TCM2 ON TSD.I_Curr_City_ID = TCM2.I_City_ID
                        LEFT JOIN dbo.T_User_Sex TUS ON TERD.I_Sex_ID = TUS.I_Sex_ID
                        LEFT JOIN dbo.T_Blood_Group TBG ON TERD.I_Blood_Group_ID = TBG.I_Blood_Group_ID
                        LEFT JOIN dbo.T_User_Religion TUR ON TERD.I_Religion_ID = TUR.I_Religion_ID
                        LEFT JOIN dbo.T_Marital_Status TMS ON TERD.I_Marital_Status_ID = TMS.I_Marital_Status_ID
                        LEFT JOIN dbo.T_Caste_Master TCM3 ON TERD.I_Caste_ID = TCM3.I_Caste_ID
                        LEFT JOIN dbo.T_State_Master TSM ON TSD.I_Curr_State_ID = TSM.I_State_ID
                        LEFT JOIN T_House_Master THM2 ON TSD.I_House_ID = THM2.I_House_ID
                        LEFT JOIN ( SELECT  TTTM.I_Batch_ID ,
                                            ISNULL(COUNT(TTTM.I_TimeTable_ID),
                                                   0.0) AS TotalClassAllotted 
                                    --MAX(CONVERT(DATE, TTTM.Dt_Schedule_Date)) AS LastClassDate
                                    FROM    dbo.T_TimeTable_Master TTTM
                            --LEFT JOIN dbo.T_Student_Attendance TSA ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TTTM.I_Batch_ID
                                  ) T3 ON T3.I_Batch_ID = TSBD.I_Batch_ID
                        LEFT JOIN ( SELECT  TSA.I_Student_Detail_ID ,
                                            MAX(TTTM.Dt_Schedule_Date) AS LastClassDate
                                    FROM    dbo.T_Student_Attendance TSA
                                            INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TSA.I_Student_Detail_ID
                                  ) T5 ON T5.I_Student_Detail_ID = T1.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  TSD2.I_Student_Detail_ID ,
                                            TTTM.I_Batch_ID ,
                                            ISNULL(COUNT(DISTINCT TSA.I_TimeTable_ID),
                                                   0.0) AS TotalAttendedClasses
                                    FROM    dbo.T_Student_Attendance TSA
                                            INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                            INNER JOIN dbo.T_Student_Detail TSD2 ON TSA.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                    WHERE   TTTM.I_Status = 1
                                    GROUP BY TSD2.I_Student_Detail_ID ,
                                            TTTM.I_Batch_ID
                                  ) T4 ON T4.I_Batch_ID = TSBD.I_Batch_ID
                                          AND T4.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  InvAmt.I_Student_Detail_ID ,
                                            InvAmt.AsOnDateCourseAmount ,
                                            InvTax.AsOnDateServiceTax ,
                                            SUM(InvAmt.AsOnDateCourseAmount
                                                + InvTax.AsOnDateServiceTax) AS AsOnDateTotalCourseAmount
                                    FROM    ( SELECT    TSD2.I_Student_Detail_ID ,
                                                        SUM(TICD.N_Amount_Due) AS AsOnDateCourseAmount
                                              FROM      dbo.T_Invoice_Parent TIP2
                                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                        INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                    --LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                              WHERE     TIP2.I_Status IN ( 1,
                                                              3 )
                                                        AND TIP2.I_Invoice_Header_ID = @InvID
                                                        AND TICD.Dt_Installment_Date <= GETDATE()
                                              GROUP BY  TSD2.I_Student_Detail_ID
                                            ) InvAmt
                                            LEFT JOIN ( SELECT
                                                              TSD2.I_Student_Detail_ID ,
                                                              SUM(ISNULL(TIDT.N_Tax_Value,
                                                              0.0)) AS AsOnDateServiceTax
                                                        FROM  dbo.T_Invoice_Parent TIP2
                                                              INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP2.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                              INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                              LEFT JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                                        WHERE TIP2.I_Status IN (
                                                              1, 3 )
                                                              AND TIP2.I_Invoice_Header_ID = @InvID
                                                              AND TICD.Dt_Installment_Date <= GETDATE()
                                                        GROUP BY TSD2.I_Student_Detail_ID
                                                      ) InvTax ON InvAmt.I_Student_Detail_ID = InvTax.I_Student_Detail_ID
                                    GROUP BY InvAmt.I_Student_Detail_ID ,
                                            InvAmt.AsOnDateCourseAmount ,
                                            InvTax.AsOnDateServiceTax
                                  ) T6 ON T6.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  DISTINCT
                                            TBRM.S_Route_No ,
                                            TSD.I_Student_Detail_ID ,
                                            TSD.S_Student_ID ,
                                            TTM.S_PickupPoint_Name ,
                                            TTM.N_Fees
                                    FROM    dbo.T_Student_Detail TSD
                                            INNER JOIN ( SELECT
                                                              I_Student_Detail_ID ,
                                                              I_Route_ID ,
                                                              I_PickupPoint_ID ,
                                                              Dt_Crtd_On ,
                                                              DENSE_RANK() OVER ( PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC ) AS RankID
                                                         FROM dbo.T_Student_Transport_History TSTH
                                                       ) XX ON TSD.I_Student_Detail_ID = XX.I_Student_Detail_ID
                                                              AND RankID = 1
                                            INNER JOIN dbo.T_BusRoute_Master TBRM ON XX.I_Route_ID = TBRM.I_Route_ID
                                            INNER JOIN dbo.T_Transport_Master TTM ON XX.I_PickupPoint_ID = TTM.I_PickupPoint_ID
                                                              AND TBRM.I_Brand_ID = @iBrandID
                                            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                            INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                            INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                    WHERE   TBRM.I_Status = 1
                                            AND TTM.I_Status = 1
                                            AND TFCM.S_Component_Code = 'TF' --AND TSD.I_Student_Detail_ID=55735
                                    
                                  ) T7 ON T7.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE   TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND TSD.S_Student_ID = @sStudentID
                --AND TIP.I_Status IN (1,3)
            END
                
                
                
                   
    END
