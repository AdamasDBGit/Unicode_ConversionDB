CREATE PROCEDURE [dbo].[uspUpdateBookingDetails]
AS 
    BEGIN


-----------Mark New Booking Start----------

        INSERT  INTO dbo.T_Booking_Record
                ( I_Student_Detail_ID ,
                  Dt_Booking_Date
                )
                SELECT  T2.I_Student_Detail_ID ,
                        GETDATE()
                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                    T1.I_Invoice_Header_ID ,
                                    SUM(T1.BaseAmtDiff) AS TotalDiff
                          FROM      ( SELECT    InvoiceDue.I_Student_Detail_ID ,
                                                InvoiceDue.I_Invoice_Header_ID ,
                                                InvoiceDue.I_Invoice_Detail_ID ,
                                                InvoiceDue.I_Installment_No ,
                                                InvoiceDue.Dt_Installment_Date ,
                                                InvoiceDue.S_Component_Name ,
                                                InvoiceDue.N_Amount_Due ,
                                                ReceiptAmt.ReceiptCompAmount ,
                                                InvoiceTax.TotalTax ,
                                                ReceiptTax.ReceiptCompTax ,
                                                ( InvoiceDue.N_Amount_Due
                                                  - ISNULL(ReceiptAmt.ReceiptCompAmount,
                                                           0.0) ) AS BaseAmtDiff ,
                                                ( ISNULL(InvoiceTax.TotalTax,
                                                         0.0)
                                                  - ISNULL(ReceiptTax.ReceiptCompTax,
                                                           0.0) ) AS TaxDiff
                                      FROM      ( SELECT    TSD.I_Student_Detail_ID ,
                                                            TIP.I_Invoice_Header_ID ,
                                                            TICD.I_Invoice_Detail_ID ,
                                                            TICD.I_Installment_No ,
                                                            TICD.Dt_Installment_Date ,
                                                            TFCM.S_Component_Name ,
                                                            TICD.N_Amount_Due
                                                  FROM      dbo.T_Invoice_Parent TIP
                                                            INNER JOIN ( SELECT
                                                              TIP.I_Student_Detail_ID ,
                                                              MIN(TIP.I_Invoice_Header_ID) AS AdmInvoice
                                                              FROM
                                                              dbo.T_Invoice_Parent TIP
                                                              INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                                                              WHERE
                                                              TCHND.I_Brand_ID IN (
                                                              109, 111 )
                                                              GROUP BY TIP.I_Student_Detail_ID
                                                              ) TT ON TIP.I_Student_Detail_ID = TT.I_Student_Detail_ID
                                                              AND TIP.I_Invoice_Header_ID = TT.AdmInvoice
                                                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                            INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                            INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                            INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                  WHERE     TICD.I_Installment_No = 1 
          --TSD.S_Student_ID = @StudentId
                                                            AND TIP.I_Status IN (
                                                            1 )
                                                            AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, GETDATE())
                                                            AND TSD.B_IsBooking <> 1
--ORDER BY TSD.S_Student_ID,TIP.I_Invoice_Header_ID,TICD.Dt_Installment_Date,TICD.I_Installment_No,TFCM.S_Component_Name
                                                  
                                                ) InvoiceDue
                                                LEFT JOIN ( SELECT
                                                              I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(ISNULL(N_Tax_Value,
                                                              0.0)), 0.0) AS TotalTax
                                                            FROM
                                                              dbo.T_Invoice_Detail_Tax TIDT
                                                            GROUP BY I_Invoice_Detail_ID
                                                          ) InvoiceTax ON InvoiceDue.I_Invoice_Detail_ID = InvoiceTax.I_Invoice_Detail_ID
                                                LEFT JOIN ( SELECT
                                                              TRCD.I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(TRCD.N_Amount_Paid),
                                                              0.0) AS ReceiptCompAmount
                                                            FROM
                                                              dbo.T_Receipt_Component_Detail TRCD
                                                              INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                                            WHERE
                                                              TRH.I_Status = 1
                                                            GROUP BY TRCD.I_Invoice_Detail_ID
                                                          ) ReceiptAmt ON InvoiceDue.I_Invoice_Detail_ID = ReceiptAmt.I_Invoice_Detail_ID
                                                LEFT JOIN ( SELECT
                                                              TRTD.I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid,
                                                              0.0)), 0.0) AS ReceiptCompTax
                                                            FROM
                                                              dbo.T_Receipt_Tax_Detail TRTD
                                                              INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                                            WHERE
                                                              TRH.I_Status = 1
                                                            GROUP BY TRTD.I_Invoice_Detail_ID
                                                          ) ReceiptTax ON InvoiceDue.I_Invoice_Detail_ID = ReceiptTax.I_Invoice_Detail_ID
--ORDER BY InvoiceDue.S_Student_ID ,
--        InvoiceDue.I_Invoice_Header_ID ,
--        InvoiceDue.I_Installment_No ,
--        InvoiceDue.Dt_Installment_Date ,
--        InvoiceDue.S_Component_Name 
                                      
                                    ) T1
                          GROUP BY  T1.I_Student_Detail_ID ,
                                    T1.I_Invoice_Header_ID
                        ) T2
                WHERE   T2.TotalDiff >= 1

        UPDATE  dbo.T_Student_Detail
        SET     B_IsBooking = 1
        WHERE   I_Student_Detail_ID IN (
                SELECT  TBR.I_Student_Detail_ID
                FROM    dbo.T_Booking_Record TBR
                WHERE   CONVERT(DATE, TBR.Dt_Booking_Date) = CONVERT(DATE, GETDATE()) )
                AND B_IsBooking <> 1

-----------Mark New Booking End----------


-----------Update Old Booking Details Start------------


        UPDATE dbo.T_Booking_Record SET Dt_Reg_Conversion_Date=GETDATE()
        WHERE
        I_Student_Detail_ID IN
        (
                SELECT  T2.I_Student_Detail_ID
                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                    T1.I_Invoice_Header_ID ,
                                    SUM(T1.BaseAmtDiff) AS TotalDiff
                          FROM      ( SELECT    InvoiceDue.I_Student_Detail_ID ,
                                                InvoiceDue.I_Invoice_Header_ID ,
                                                InvoiceDue.I_Invoice_Detail_ID ,
                                                InvoiceDue.I_Installment_No ,
                                                InvoiceDue.Dt_Installment_Date ,
                                                InvoiceDue.S_Component_Name ,
                                                InvoiceDue.N_Amount_Due ,
                                                ReceiptAmt.ReceiptCompAmount ,
                                                InvoiceTax.TotalTax ,
                                                ReceiptTax.ReceiptCompTax ,
                                                ( InvoiceDue.N_Amount_Due
                                                  - ISNULL(ReceiptAmt.ReceiptCompAmount,
                                                           0.0) ) AS BaseAmtDiff ,
                                                ( ISNULL(InvoiceTax.TotalTax,
                                                         0.0)
                                                  - ISNULL(ReceiptTax.ReceiptCompTax,
                                                           0.0) ) AS TaxDiff
                                      FROM      ( SELECT    TSD.I_Student_Detail_ID ,
                                                            TIP.I_Invoice_Header_ID ,
                                                            TICD.I_Invoice_Detail_ID ,
                                                            TICD.I_Installment_No ,
                                                            TICD.Dt_Installment_Date ,
                                                            TFCM.S_Component_Name ,
                                                            TICD.N_Amount_Due
                                                  FROM      dbo.T_Invoice_Parent TIP
                                                            INNER JOIN ( SELECT
                                                              TIP.I_Student_Detail_ID ,
                                                              MIN(TIP.I_Invoice_Header_ID) AS AdmInvoice
                                                              FROM
                                                              dbo.T_Invoice_Parent TIP
                                                              INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                                                              WHERE
                                                              TCHND.I_Brand_ID IN (
                                                              109, 111 )
                                                              GROUP BY TIP.I_Student_Detail_ID
                                                              ) TT ON TIP.I_Student_Detail_ID = TT.I_Student_Detail_ID
                                                              AND TIP.I_Invoice_Header_ID = TT.AdmInvoice
                                                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                            INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                            INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                            INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                  WHERE     TICD.I_Installment_No = 1 
          --TSD.S_Student_ID = @StudentId
                                                            AND TIP.I_Status IN (
                                                            1 )
                                                            AND TSD.B_IsBooking = 1
                                            --AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, GETDATE())
--ORDER BY TSD.S_Student_ID,TIP.I_Invoice_Header_ID,TICD.Dt_Installment_Date,TICD.I_Installment_No,TFCM.S_Component_Name
                                                  
                                                ) InvoiceDue
                                                LEFT JOIN ( SELECT
                                                              I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(ISNULL(N_Tax_Value,
                                                              0.0)), 0.0) AS TotalTax
                                                            FROM
                                                              dbo.T_Invoice_Detail_Tax TIDT
                                                            GROUP BY I_Invoice_Detail_ID
                                                          ) InvoiceTax ON InvoiceDue.I_Invoice_Detail_ID = InvoiceTax.I_Invoice_Detail_ID
                                                LEFT JOIN ( SELECT
                                                              TRCD.I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(TRCD.N_Amount_Paid),
                                                              0.0) AS ReceiptCompAmount
                                                            FROM
                                                              dbo.T_Receipt_Component_Detail TRCD
                                                              INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                                            WHERE
                                                              TRH.I_Status = 1
                                                            GROUP BY TRCD.I_Invoice_Detail_ID
                                                          ) ReceiptAmt ON InvoiceDue.I_Invoice_Detail_ID = ReceiptAmt.I_Invoice_Detail_ID
                                                LEFT JOIN ( SELECT
                                                              TRTD.I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid,
                                                              0.0)), 0.0) AS ReceiptCompTax
                                                            FROM
                                                              dbo.T_Receipt_Tax_Detail TRTD
                                                              INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                                            WHERE
                                                              TRH.I_Status = 1
                                                            GROUP BY TRTD.I_Invoice_Detail_ID
                                                          ) ReceiptTax ON InvoiceDue.I_Invoice_Detail_ID = ReceiptTax.I_Invoice_Detail_ID
--ORDER BY InvoiceDue.S_Student_ID ,
--        InvoiceDue.I_Invoice_Header_ID ,
--        InvoiceDue.I_Installment_No ,
--        InvoiceDue.Dt_Installment_Date ,
--        InvoiceDue.S_Component_Name 
                                      
                                    ) T1
                          GROUP BY  T1.I_Student_Detail_ID ,
                                    T1.I_Invoice_Header_ID
                        ) T2
                WHERE   T2.TotalDiff < 1 )
                
                
                
                UPDATE dbo.T_Student_Detail SET B_IsBooking=0 WHERE I_Student_Detail_ID IN
                (
                SELECT TBR.I_Student_Detail_ID FROM dbo.T_Booking_Record TBR WHERE CONVERT(DATE,TBR.Dt_Reg_Conversion_Date)=CONVERT(DATE,GETDATE())
                )
                AND B_IsBooking=1

-----------Update Old Booking Details End------------


    END
