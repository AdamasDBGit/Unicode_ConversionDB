CREATE PROCEDURE [SMManagement].[uspGetStudentDetailsForDeliveryTracking]
    (
      @BrandID INT ,
      @HierarchyID VARCHAR(MAX) ,
      @CourseID INT
    )
AS
    BEGIN

        SELECT  TSDSH.StockDispatchHeaderID ,
                TSDSH.StockDispatchStudentHeaderID ,
                TSDSH.StudentDetailID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSBM.I_Course_ID ,
                TCM.S_Course_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TSDSH.ItemCount ,
                TSDSH.DispatchDocument ,
                ISNULL(TSDSH.TrackingID,'') AS TrackingID ,
                '' AS StatusDesc
        FROM    SMManagement.T_Stock_Dispatch_Student_Header AS TSDSH
                INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSDSH.StudentDetailID = TSCD.I_Student_Detail_ID
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSDSH.StudentDetailID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSDSH.StudentDetailID
                --LEFT JOIN ( SELECT  T1.*
                --            FROM    SMManagement.T_Material_Tracking_Details
                --                    AS T1
                --                    INNER JOIN ( SELECT TM.DispatchHeaderID ,
                --                                        TM.StudentDispatchHeaderID ,
                --                                        TM.StudentDetailID ,
                --                                        MAX(ID) AS LatestStatus
                --                                 FROM   SMManagement.T_Material_Tracking_Details
                --                                        AS TM
                --                                 GROUP BY TM.DispatchHeaderID ,
                --                                        TM.StudentDispatchHeaderID ,
                --                                        TM.StudentDetailID
                --                               ) T2 ON T2.DispatchHeaderID = T1.DispatchHeaderID
                --                                       AND T2.StudentDetailID = T1.StudentDetailID
                --                                       AND T2.StudentDispatchHeaderID = T1.StudentDispatchHeaderID
                --                                       AND T1.ID = T2.LatestStatus
                --          ) AS TMTD ON TMTD.StudentDetailID = TSDSH.StudentDetailID
                --                       AND TMTD.DispatchHeaderID = TSDSH.StockDispatchHeaderID
                --                       AND TMTD.StudentDispatchHeaderID = TSDSH.StockDispatchStudentHeaderID
        WHERE   TSDSH.StatusID = 1
                AND TSDSH.IsDispatched = 1 AND ISNULL(TSDSH.IsReturned,0)=0
                AND (ISNULL(TSDSH.IsDelivered, 0) = 0 OR ISNULL(TSDSH.DeliveryDate,'2011-01-01')>DATEADD(d,-30,GETDATE()))
                AND TSDSH.TrackingID!=''
                --AND ISNULL(TSDSH.DispatchDate,GETDATE())<DATEADD(d,-4,GETDATE())
                AND TSCD.I_Centre_Id IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@HierarchyID, @BrandID) AS FGCFR )
                AND TSBD.I_Status = 1
                AND TSBM.I_Course_ID = @CourseID


    END
