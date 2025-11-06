CREATE PROCEDURE [REPORT].[uspGetStudentBookingDetails]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS
    BEGIN
    
    CREATE TABLE #BD
    (
    I_Student_Detail_ID INT,
    Dt_Booking_Date DATE,
    Dt_Reg_Conversion_Date DATE
    )
    
    
    INSERT INTO #BD
            ( I_Student_Detail_ID,Dt_Booking_Date,Dt_Reg_Conversion_Date )
    
    SELECT TBR.I_Student_Detail_ID,TBR.Dt_Booking_Date,TBR.Dt_Reg_Conversion_Date FROM dbo.T_Booking_Record AS TBR WHERE  TBR.Dt_Booking_Date >= @dtStartDate
                                                      AND TBR.Dt_Booking_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                    

        SELECT  TCHND.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TCM.S_Course_Name ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TSD.I_RollNo,
                TSD.S_Mobile_No ,
                CONVERT(DATE, TBR.Dt_Booking_Date) AS BookingDate ,
                TBR.Dt_Reg_Conversion_Date AS ConvertionDate ,
                T3.InstDate AS InstalmentDate ,
                T3.PendingAmount ,
                CONVERT(DATE, T4.LastAttnDate) AS LastAttnDate ,
                CASE WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'NO'
                     WHEN TCM2.S_Center_Code NOT LIKE 'FR-%' THEN 'YES'
                END IsOwnCentre
        FROM    #BD AS TBR
                INNER JOIN ( SELECT TIP2.I_Student_Detail_ID ,
                                    MIN(TIP2.I_Invoice_Header_ID) AS InvHeader
                             FROM   dbo.T_Invoice_Parent TIP2 WITH (NOLOCK)
                             WHERE  TIP2.I_Status = 1
                             GROUP BY TIP2.I_Student_Detail_ID
                           ) TIP ON TBR.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Parent TIP3 WITH (NOLOCK) ON TIP.InvHeader = TIP3.I_Invoice_Header_ID
                INNER JOIN dbo.T_Student_Detail TSD WITH (NOLOCK) ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                       AND TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TBR.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM WITH (NOLOCK) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD WITH (NOLOCK) ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Centre_Master TCM2 WITH (NOLOCK) ON TCHND.I_Center_ID = TCM2.I_Centre_Id
                INNER JOIN dbo.T_Course_Master TCM WITH (NOLOCK) ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN ( SELECT T1.I_Invoice_Header_ID ,
                                    T1.InstDate ,
                                    CASE WHEN ISNULL(T1.InvAmt,0) - ISNULL(T2.AmtPaid,0) <= 0
                                         THEN 0
                                         WHEN ISNULL(T1.InvAmt,0) - ISNULL(T2.AmtPaid,0) > 0
                                         THEN ISNULL(T1.InvAmt,0) - ISNULL(T2.AmtPaid,0)
                                    END AS PendingAmount
                             FROM   ( SELECT    TIP4.I_Invoice_Header_ID ,
                                                CONVERT(DATE, TICD.Dt_Installment_Date) AS InstDate ,
                                                SUM(TICD.N_Amount_Due) AS InvAmt
                                      FROM      dbo.T_Invoice_Parent TIP4
                                                INNER JOIN dbo.T_Invoice_Child_Header TICH WITH (NOLOCK) ON TIP4.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 WITH (NOLOCK) ON TIP4.I_Centre_Id = TCHND2.I_Center_ID
                                                INNER JOIN #BD AS B1 ON B1.I_Student_Detail_ID = TIP4.I_Student_Detail_ID
                                                --INNER JOIN dbo.T_Booking_Record
                                                --AS TBR3 ON TBR3.I_Student_Detail_ID = TIP4.I_Student_Detail_ID
                                      WHERE     TICD.I_Installment_No = 1
                                                AND TCHND2.I_Center_ID IN (
                                                SELECT  FGCFR.centerID
                                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                --AND ( TBR3.Dt_Booking_Date >= @dtStartDate
                                                --      AND TBR3.Dt_Booking_Date < DATEADD(d,
                                                --              1, @dtEndDate)
                                                --    )
                                                AND TIP4.I_Status = 1
                                      GROUP BY  TIP4.I_Invoice_Header_ID ,
                                                CONVERT(DATE, TICD.Dt_Installment_Date)
                                    ) T1
                                    LEFT JOIN ( SELECT  TRH.I_Invoice_Header_ID ,
                                                        SUM(TRCD.N_Amount_Paid) AS AmtPaid
                                                FROM    dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND3 WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND3.I_Center_ID
                                                        INNER JOIN #BD AS B2 ON B2.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                                                        --INNER JOIN dbo.T_Booking_Record
                                                        --AS TBR2 ON TBR2.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                                                WHERE   TRH.I_Status = 1
                                                        AND TCHND3.I_Center_ID IN (
                                                        SELECT
                                                              FGCFR.centerID
                                                        FROM  dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                        --AND ( TBR2.Dt_Booking_Date >= @dtStartDate
                                                        --      AND TBR2.Dt_Booking_Date < DATEADD(d,
                                                        --      1, @dtEndDate)
                                                        --    )
                                                GROUP BY TRH.I_Invoice_Header_ID
                                              ) T2 ON T1.I_Invoice_Header_ID = T2.I_Invoice_Header_ID
                           ) T3 ON TIP3.I_Invoice_Header_ID = T3.I_Invoice_Header_ID
                                   AND TIP.InvHeader = T3.I_Invoice_Header_ID
                LEFT JOIN ( SELECT  TSD.S_Student_ID ,
                                    MAX(TTTM.Dt_Schedule_Date) AS LastAttnDate
                            FROM    dbo.T_Student_Attendance AS TSA WITH (NOLOCK)
                                    INNER JOIN dbo.T_Student_Detail AS TSD WITH (NOLOCK) ON TSD.I_Student_Detail_ID = TSA.I_Student_Detail_ID
                                    INNER JOIN #BD AS TBR2 ON TBR2.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              AND TBR2.I_Student_Detail_ID = TSA.I_Student_Detail_ID
                                    INNER JOIN dbo.T_TimeTable_Master AS TTTM WITH (NOLOCK) ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                            WHERE   TTTM.I_Status = 1
                                    --AND ( TBR2.Dt_Booking_Date >= @dtStartDate
                                    --      AND TBR2.Dt_Booking_Date < DATEADD(d,
                                    --                          1, @dtEndDate)
                                    --    )
                            GROUP BY TSD.S_Student_ID
                          ) T4 ON T4.S_Student_ID = TSD.S_Student_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSBD.I_Status IN ( 1, 3 )
                AND TIP3.I_Status = 1
                --AND ( TBR.Dt_Booking_Date >= @dtStartDate
                --      AND TBR.Dt_Booking_Date < DATEADD(d, 1, @dtEndDate)
                    --)
        ORDER BY TCHND.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TCM.S_Course_Name ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID
        
    END
