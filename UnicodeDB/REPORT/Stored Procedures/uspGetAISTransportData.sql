CREATE PROCEDURE [REPORT].[uspGetAISTransportData]
AS
BEGIN
SELECT  TSD2.S_Student_ID ,
        TSD2.S_First_Name + ' ' + ISNULL(TSD2.S_Middle_Name, '') + ' '
        + TSD2.S_Last_Name AS StudentName ,
        TSD2.S_Mobile_No ,
        TSD2.S_Curr_Address1,
        TCM2.S_Course_Name ,
        TSBM2.S_Batch_Name ,
        CASE WHEN TSBM2.S_Batch_Name LIKE '%DB%' THEN 'DB'
        WHEN TSBM2.S_Batch_Name LIKE '%DS%' THEN 'DS'
        END AS Scholar,
        TTM.S_PickupPoint_Name ,
        TBRM.S_Route_No ,
        TTM.N_Fees
FROM    ( SELECT    TIP2.I_Student_Detail_ID ,
                    MAX(TIP2.I_Invoice_Header_ID) AS InvoiceHeaderID
          FROM      dbo.T_Invoice_Parent TIP2
                    INNER JOIN ( SELECT TSD.I_Student_Detail_ID ,
                                        TIP.I_Invoice_Header_ID ,
                                        TIP.Dt_Crtd_On ,
                                        TIBM.I_Batch_ID
                                 FROM   dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                 WHERE  TIP.I_Centre_Id = 1
                                        AND ( TSBM.Dt_BatchStartDate >= '2016-04-01'
                                              AND TSBM.Dt_BatchStartDate < '2017-04-01'
                                            )
                               ) T1 ON TIP2.I_Invoice_Header_ID = T1.I_Invoice_Header_ID
                                       AND TIP2.I_Student_Detail_ID = T1.I_Student_Detail_ID
                    INNER JOIN dbo.T_Invoice_Child_Header TICH2 ON T1.I_Invoice_Header_ID = TICH2.I_Invoice_Header_ID
                    INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH2.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                    INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
          WHERE     TFCM.S_Component_Code = 'TF'
          GROUP BY  TIP2.I_Student_Detail_ID
        ) T2
        INNER JOIN dbo.T_Invoice_Parent TIP3 ON T2.I_Student_Detail_ID = TIP3.I_Student_Detail_ID
                                                AND T2.InvoiceHeaderID = TIP3.I_Invoice_Header_ID
        INNER JOIN dbo.T_Student_Transport_History TSTH ON TIP3.I_Student_Detail_ID = TSTH.I_Student_Detail_ID
                                                           AND CONVERT(DATE, TSTH.Dt_Crtd_On) = CONVERT(DATE, TIP3.Dt_Crtd_On)
        INNER JOIN dbo.T_BusRoute_Master TBRM ON TSTH.I_Route_ID = TBRM.I_Route_ID
        INNER JOIN dbo.T_Transport_Master TTM ON TSTH.I_PickupPoint_ID = TTM.I_PickupPoint_ID
        INNER JOIN dbo.T_Invoice_Child_Header TICH3 ON TIP3.I_Invoice_Header_ID = TICH3.I_Invoice_Header_ID
        INNER JOIN dbo.T_Invoice_Batch_Map TIBM2 ON TICH3.I_Invoice_Child_Header_ID = TIBM2.I_Invoice_Child_Header_ID
        INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TIBM2.I_Batch_ID = TSBM2.I_Batch_ID
        INNER JOIN dbo.T_Student_Detail TSD2 ON TIP3.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
        INNER JOIN dbo.T_Course_Master TCM2 ON TSBM2.I_Course_ID = TCM2.I_Course_ID
        
        
        END
