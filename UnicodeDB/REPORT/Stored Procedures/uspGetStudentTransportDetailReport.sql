CREATE PROCEDURE [REPORT].[uspGetStudentTransportDetailReport]
(
@iBrandID INT,
@dtBatchStartDate DATE
)
AS
BEGIN

SELECT  TBRM.S_Route_No ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS NAME ,
        TSD.S_Mobile_No ,
        TSD.S_Phone_No,
        TSD.S_Curr_Address1,
        TSBM.S_Batch_Name ,
        TTM.S_PickupPoint_Name,
        TTM.N_Fees
FROM    dbo.T_Student_Detail TSD
        INNER JOIN ( SELECT I_Student_Detail_ID ,
                            I_Route_ID ,
                            I_PickupPoint_ID ,
                            Dt_Crtd_On ,
                            DENSE_RANK() OVER ( PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC ) AS RankID
                     FROM   dbo.T_Student_Transport_History TSTH
                   ) XX ON TSD.I_Student_Detail_ID = XX.I_Student_Detail_ID
                           AND RankID = 1
        INNER JOIN dbo.T_BusRoute_Master TBRM ON XX.I_Route_ID = TBRM.I_Route_ID
        INNER JOIN dbo.T_Transport_Master TTM ON XX.I_PickupPoint_ID = TTM.I_PickupPoint_ID
                                                 AND TBRM.I_Brand_ID = @iBrandID
        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
WHERE   TCHND.I_Brand_ID = @iBrandID
        AND TSBD.I_Status IN (1,3)
        AND TBRM.I_Status = 1
        AND TTM.I_Status = 1
        AND TSBM.Dt_BatchStartDate>=@dtBatchStartDate
ORDER BY TBRM.S_Route_No,TSBM.S_Batch_Name

END
