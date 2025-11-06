CREATE PROCEDURE [REPORT].[uspGetSMDispatchDetails_New]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @iFlag INT
      --@sStudentID VARCHAR(MAX)=NULL
    )
AS
    BEGIN

	IF OBJECT_ID('tempdb.dbo.#temp', 'U') IS NOT NULL
	DROP TABLE #temp;
    
        CREATE TABLE #temp
            (
              EligibilityDetailID INT ,
              DispatchHeaderID INT
            )

	IF OBJECT_ID('tempdb.dbo.#FINAL', 'U') IS NOT NULL
    DROP TABLE #FINAL;
            
        CREATE TABLE #FINAL
            (
              S_Center_Name VARCHAR(MAX) ,
              S_Course_Name VARCHAR(MAX) ,
              S_Batch_Name VARCHAR(MAX) ,
              S_Student_ID VARCHAR(MAX) ,
              StdName VARCHAR(MAX) ,
              S_Mobile_No VARCHAR(MAX) ,
              I_Delivery INT ,
              Name VARCHAR(MAX) ,
              EligibilityDate DATETIME ,
              BarcodePrefix VARCHAR(MAX) ,
              AssignedBarcode VARCHAR(MAX) ,
              TrackingID VARCHAR(MAX) ,
              IsApproved INT ,
              IsDispatched INT ,
              IsDelivered INT ,
              StockDispatchHeaderName VARCHAR(MAX) ,
              UniqueID VARCHAR(MAX) ,
              StdAddress VARCHAR(MAX) ,
              ApprovedDate DATETIME ,
              DispatchDate DATETIME ,
              DeliveryDate DATETIME
            )     

        IF ( @iFlag = 0 )
            BEGIN
            
                INSERT  INTO #temp
                        ( EligibilityDetailID
                        )
                        SELECT  TSED.EligibilityDetailID
                        FROM    SMManagement.T_Student_Eligibity_Details AS TSED
                        WHERE   TSED.EligibilityDate >= @dtStartDate
                                AND TSED.EligibilityDate < DATEADD(d, 1,
                                                              @dtEndDate)
				INSERT INTO #FINAL
                SELECT  TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StdName ,
                        TSD.S_Mobile_No ,
                        TSED.I_Delivery ,
                        TITM.Name ,
                        TSED.EligibilityDate ,
                        TSED.BarcodePrefix ,
                        TSDSD.Barcode AS AssignedBarcode ,
                        ISNULL(TSDSH.TrackingID, '') AS TrackingID ,
                        TSED.IsApproved ,
                        ISNULL(TSED.IsDispatched, 0) AS IsDispatched ,
                        TSED.IsDelivered ,
                        TSDH.StockDispatchHeaderName ,
                        SUBSTRING(TSDSH.DispatchDocument, 0, 17) AS UniqueID ,
                        TSD.S_Curr_Address1 + ' ' + ISNULL(TCM2.S_City_Name,
                                                           '') + ' '
                        + ISNULL(TSM.S_State_Name, '') + ' '
                        + ISNULL(TSD.S_Curr_Pincode, '') AS StdAddress ,
                        TSED.ApprovedDate ,
                        TSDSH.DispatchDate ,
                        TSDSH.DeliveryDate
                FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
                        INNER JOIN SMManagement.T_Student_Eligibity_Details AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                        INNER JOIN SMManagement.T_ItemType_Master AS TITM ON TITM.ID = TSED.ItemType
						INNER JOIN #temp AS T1 on T1.DispatchHeaderID=TSED.EligibilityDetailID
						INNER JOIN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR ) as T2 on T2.centerID=TCHND.I_Center_ID
                        LEFT JOIN SMManagement.T_Stock_Dispatch_Student_Details
                        AS TSDSD ON TSDSD.EligibilityDetailID = TSED.EligibilityDetailID
                                    AND TSDSD.EligibilityHeaderID = TSED.EligibilityHeaderID
                        LEFT JOIN SMManagement.T_Stock_Dispatch_Student_Header
                        AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                                    AND TSDSH.StudentDetailID = TSEP.StudentDetailID
                        LEFT JOIN SMManagement.T_Stock_Dispatch_Header AS TSDH ON TSDH.StockDispatchHeaderID = TSDSH.StockDispatchHeaderID
                        LEFT JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TSD.I_Curr_State_ID
                        LEFT JOIN dbo.T_City_Master AS TCM2 ON TCM2.I_City_ID = TSD.I_Curr_City_ID
                WHERE   TSEP.StatusID = 1 --AND (TSED.EligibilityDate>='2019-03-01' AND TSED.EligibilityDate<'2019-05-01') AND TCHND.I_Center_ID=2
                        --AND TSED.EligibilityDate >= @dtStartDate
                        --AND TSED.EligibilityDate < DATEADD(d, 1, @dtEndDate)
                        --AND TSD.S_Student_ID = (ISNULL(@sStudentID,TSD.S_Student_ID))
                        --AND TSED.EligibilityDetailID IN (
                        --SELECT  T.EligibilityDetailID
                        --FROM    #temp AS T )
                        --AND TCHND.I_Center_ID IN (
                        --SELECT  FGCFR.centerID
                        --FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                        --                                   @iBrandID) AS FGCFR )
                --ORDER BY TCHND.S_Center_Name ,
                --        TCM.S_Course_Name ,
                --        TSBM.S_Batch_Name ,
                --        TSD.S_Student_ID

            END

        ELSE
            IF ( @iFlag = 1 )
                BEGIN
                
                    INSERT  INTO #temp
                            ( EligibilityDetailID
                            )
                            SELECT  TSED.EligibilityDetailID
                            FROM    SMManagement.T_Student_Eligibity_Details
                                    AS TSED
                            WHERE   ( TSED.IsApproved = 1
                                      AND TSED.ApprovedDate >= @dtStartDate
                                      AND TSED.ApprovedDate < DATEADD(d, 1,
                                                              @dtEndDate)
                                    )
					INSERT INTO #FINAL
                    SELECT  TCHND.S_Center_Name ,
                            TCM.S_Course_Name ,
                            TSBM.S_Batch_Name ,
                            TSD.S_Student_ID ,
                            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,
                                                            '') + ' '
                            + TSD.S_Last_Name AS StdName ,
                            TSD.S_Mobile_No ,
                            TSED.I_Delivery ,
                            TITM.Name ,
                            TSED.EligibilityDate ,
                            TSED.BarcodePrefix ,
                            TSDSD.Barcode AS AssignedBarcode ,
                            ISNULL(TSDSH.TrackingID, '') AS TrackingID ,
                            TSED.IsApproved ,
                            ISNULL(TSED.IsDispatched, 0) AS IsDispatched ,
                            TSED.IsDelivered ,
                            TSDH.StockDispatchHeaderName ,
                            SUBSTRING(TSDSH.DispatchDocument, 0, 17) AS UniqueID ,
                            TSD.S_Curr_Address1 + ' '
                            + ISNULL(TCM2.S_City_Name, '') + ' '
                            + ISNULL(TSM.S_State_Name, '') + ' '
                            + ISNULL(TSD.S_Curr_Pincode, '') AS StdAddress ,
                            TSED.ApprovedDate ,
                            TSDSH.DispatchDate ,
                            TSDSH.DeliveryDate
                    FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
                            INNER JOIN SMManagement.T_Student_Eligibity_Details
                            AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                            INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                            INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                            INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                            INNER JOIN SMManagement.T_ItemType_Master AS TITM ON TITM.ID = TSED.ItemType
							INNER JOIN
							(
								SELECT  FGCFR.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR 
							) as t1
							on t1.centerID=TCHND.I_Center_ID
							inner join #temp as t2
							on t2.EligibilityDetailID = TSED.EligibilityDetailID
                            LEFT JOIN SMManagement.T_Stock_Dispatch_Student_Details
                            AS TSDSD ON TSDSD.EligibilityDetailID = TSED.EligibilityDetailID
                                        AND TSDSD.EligibilityHeaderID = TSED.EligibilityHeaderID
                            LEFT JOIN SMManagement.T_Stock_Dispatch_Student_Header
                            AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                                        AND TSDSH.StudentDetailID = TSEP.StudentDetailID
                            LEFT JOIN SMManagement.T_Stock_Dispatch_Header AS TSDH ON TSDH.StockDispatchHeaderID = TSDSH.StockDispatchHeaderID
                            LEFT JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TSD.I_Curr_State_ID
                            LEFT JOIN dbo.T_City_Master AS TCM2 ON TCM2.I_City_ID = TSD.I_Curr_City_ID
                    WHERE   TSEP.StatusID IN ( 1, 0 )
                            --AND TSED.IsApproved = 1 --AND (TSED.EligibilityDate>='2019-03-01' AND TSED.EligibilityDate<'2019-05-01') AND TCHND.I_Center_ID=2
                            --AND TSED.ApprovedDate >= @dtStartDate
                            --AND TSED.ApprovedDate < DATEADD(d, 1, @dtEndDate)
                            --AND TSED.EligibilityDetailID IN (
                            --SELECT  T.EligibilityDetailID
                            --FROM    #temp AS T )
                            --AND TCHND.I_Center_ID IN (
                            --SELECT  FGCFR.centerID
                            --FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                             -- @iBrandID) AS FGCFR )
                    --ORDER BY TCHND.S_Center_Name ,
                    --        TCM.S_Course_Name ,
                    --        TSBM.S_Batch_Name ,
                    --        TSD.S_Student_ID

                END

            ELSE
                IF ( @iFlag = 2 )
                    BEGIN
						
                        INSERT  INTO #temp
                                ( DispatchHeaderID
						        )
                                SELECT  TSDSH.StockDispatchHeaderID
                                FROM    SMManagement.T_Stock_Dispatch_Header
                                        AS TSDSH
                                WHERE   TSDSH.IsDispatched = 1
                                        AND TSDSH.StatusID = 1
                                        AND ( TSDSH.DispatchDate >= @dtStartDate
                                              AND TSDSH.DispatchDate < DATEADD(d,
                                                              1, @dtEndDate)
                                            )
						INSERT INTO #FINAL
                        SELECT  TCHND.S_Center_Name ,
                                TCM.S_Course_Name ,
                                TSBM.S_Batch_Name ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' '
                                + ISNULL(TSD.S_Middle_Name, '') + ' '
                                + TSD.S_Last_Name AS StdName ,
                                TSD.S_Mobile_No ,
                                TSED.I_Delivery ,
                                TITM.Name ,
                                TSED.EligibilityDate ,
                                TSED.BarcodePrefix ,
                                TSDSD.Barcode AS AssignedBarcode ,
                                ISNULL(TSDSH.TrackingID, '') AS TrackingID ,
                                TSED.IsApproved ,
                                ISNULL(TSED.IsDispatched, 0) AS IsDispatched ,
                                TSED.IsDelivered ,
                                TSDH.StockDispatchHeaderName ,
                                SUBSTRING(TSDSH.DispatchDocument, 0, 17) AS UniqueID ,
                                TSD.S_Curr_Address1 + ' '
                                + ISNULL(TCM2.S_City_Name, '') + ' '
                                + ISNULL(TSM.S_State_Name, '') + ' '
                                + ISNULL(TSD.S_Curr_Pincode, '') AS StdAddress ,
                                TSED.ApprovedDate ,
                                TSDSH.DispatchDate ,
                                TSDSH.DeliveryDate
                        FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
                                INNER JOIN SMManagement.T_Student_Eligibity_Details
                                AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                                INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                                INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                                INNER JOIN SMManagement.T_ItemType_Master AS TITM ON TITM.ID = TSED.ItemType
                                INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details
                                AS TSDSD ON TSDSD.EligibilityDetailID = TSED.EligibilityDetailID
                                            AND TSDSD.EligibilityHeaderID = TSED.EligibilityHeaderID
                                INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                                AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                                            AND TSDSH.StudentDetailID = TSEP.StudentDetailID
                                INNER JOIN SMManagement.T_Stock_Dispatch_Header
                                AS TSDH ON TSDH.StockDispatchHeaderID = TSDSH.StockDispatchHeaderID
								INNER JOIN  #temp AS T1 on T1.DispatchHeaderID=TSDH.StockDispatchHeaderID
								INNER JOIN (
								SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR) as t2 on t2.centerID=TCHND.I_Center_ID
                                LEFT JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TSD.I_Curr_State_ID
                                LEFT JOIN dbo.T_City_Master AS TCM2 ON TCM2.I_City_ID = TSD.I_Curr_City_ID
                        WHERE   TSEP.StatusID IN ( 1, 0 )
                                AND TSED.IsDispatched = 1 --AND (TSED.EligibilityDate>='2019-03-01' AND TSED.EligibilityDate<'2019-05-01') AND TCHND.I_Center_ID=2
----AND TSED.EligibilityDate>=@dtStartDate AND TSED.EligibilityDate<DATEADD(d,1,@dtEndDate)
--                                AND ( TSDH.DispatchDate >= @dtStartDate
--                                      AND TSDH.DispatchDate <= DATEADD(d, 1,
--                                                              @dtEndDate)
--                                    )
        --                        AND TSDH.StockDispatchHeaderID 
								--IN (
        --                        SELECT  T.DispatchHeaderID
        --                        FROM    #temp AS T )
        --                        AND TCHND.I_Center_ID IN (
        --                        SELECT  FGCFR.centerID
        --                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) AS FGCFR )
                        --ORDER BY TCHND.S_Center_Name ,
                        --        TCM.S_Course_Name ,
                        --        TSBM.S_Batch_Name ,
                        --        TSD.S_Student_ID
                        --OPTION  ( RECOMPILE );

                    END
                
                ELSE
                    IF ( @iFlag = 3 )
                        BEGIN
                        
                            INSERT  INTO #temp
                                    ( DispatchHeaderID
						            )
                                    SELECT  TSDSH.StockDispatchStudentHeaderID
                                    FROM    SMManagement.T_Stock_Dispatch_Student_Header
                                            AS TSDSH
                                    WHERE   TSDSH.IsDelivered = 1
                                            AND TSDSH.StatusID = 1
                                            AND ( TSDSH.DeliveryDate >= @dtStartDate
                                                  AND TSDSH.DeliveryDate < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
							INSERT INTO #FINAL
                            SELECT  TCHND.S_Center_Name ,
                                    TCM.S_Course_Name ,
                                    TSBM.S_Batch_Name ,
                                    TSD.S_Student_ID ,
                                    TSD.S_First_Name + ' '
                                    + ISNULL(TSD.S_Middle_Name, '') + ' '
                                    + TSD.S_Last_Name AS StdName ,
                                    TSD.S_Mobile_No ,
                                    TSED.I_Delivery ,
                                    TITM.Name ,
                                    TSED.EligibilityDate ,
                                    TSED.BarcodePrefix ,
                                    TSDSD.Barcode AS AssignedBarcode ,
                                    ISNULL(TSDSH.TrackingID, '') AS TrackingID ,
                                    TSED.IsApproved ,
                                    ISNULL(TSED.IsDispatched, 0) AS IsDispatched ,
                                    TSED.IsDelivered ,
                                    TSDH.StockDispatchHeaderName ,
                                    SUBSTRING(TSDSH.DispatchDocument, 0, 17) AS UniqueID ,
                                    TSD.S_Curr_Address1 + ' '
                                    + ISNULL(TCM2.S_City_Name, '') + ' '
                                    + ISNULL(TSM.S_State_Name, '') + ' '
                                    + ISNULL(TSD.S_Curr_Pincode, '') AS StdAddress ,
                                    TSED.ApprovedDate ,
                                    TSDSH.DispatchDate ,
                                    TSDSH.DeliveryDate
                            FROM    SMManagement.T_Student_Eligibity_Parent AS TSEP
                                    INNER JOIN SMManagement.T_Student_Eligibity_Details
                                    AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                                    INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                                    INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                    AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                                    INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                                    INNER JOIN SMManagement.T_ItemType_Master
                                    AS TITM ON TITM.ID = TSED.ItemType
                                    INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details
                                    AS TSDSD ON TSDSD.EligibilityDetailID = TSED.EligibilityDetailID
                                                AND TSDSD.EligibilityHeaderID = TSED.EligibilityHeaderID
                                    INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                                    AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                                                AND TSDSH.StudentDetailID = TSEP.StudentDetailID
                                    INNER JOIN SMManagement.T_Stock_Dispatch_Header
                                    AS TSDH ON TSDH.StockDispatchHeaderID = TSDSH.StockDispatchHeaderID
									INNER JOIN #temp AS T1 on T1.DispatchHeaderID=TSDSH.StockDispatchStudentHeaderID
									INNER JOIN (SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR ) as T2 on T2.centerID=TCHND.I_Center_ID
                                    LEFT JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TSD.I_Curr_State_ID
                                    LEFT JOIN dbo.T_City_Master AS TCM2 ON TCM2.I_City_ID = TSD.I_Curr_City_ID
                            WHERE   TSEP.StatusID IN ( 1, 0 )
                                    AND TSED.IsDelivered = 1 --AND (TSED.EligibilityDate>='2019-03-01' AND TSED.EligibilityDate<'2019-05-01') AND TCHND.I_Center_ID=2
----AND TSED.EligibilityDate>=@dtStartDate AND TSED.EligibilityDate<DATEADD(d,1,@dtEndDate)
--                                    AND ( TSDSH.DeliveryDate >= @dtStartDate
--                                          AND TSDSH.DeliveryDate <= DATEADD(d,
--                                                              1, @dtEndDate)
--                                        )
                                    --AND TSDSH.StockDispatchStudentHeaderID IN (
                                    --SELECT  T.DispatchHeaderID
                                    --FROM    #temp AS T )
                                    --AND TCHND.I_Center_ID IN (
                                    --SELECT  FGCFR.centerID
                                    --FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                    --                          @iBrandID) AS FGCFR )
                            --ORDER BY TCHND.S_Center_Name ,
                            --        TCM.S_Course_Name ,
                            --        TSBM.S_Batch_Name ,
                            --        TSD.S_Student_ID

                        END
                        
                    ELSE
                        IF ( @iFlag = 4 )
                            BEGIN
                        
                                INSERT  INTO #temp
                                        ( DispatchHeaderID
						                )
                                        SELECT  TSDSH.StockDispatchStudentHeaderID
                                        FROM    SMManagement.T_Stock_Dispatch_Student_Header
                                                AS TSDSH
                                        WHERE   TSDSH.IsReturned = 1
                                                AND TSDSH.StatusID = 1
                                                AND ( TSDSH.ReturnDate >= @dtStartDate
                                                      AND TSDSH.ReturnDate < DATEADD(d,
                                                              1, @dtEndDate)
                                                    )
								INSERT INTO #FINAL
                                SELECT  TCHND.S_Center_Name ,
                                        TCM.S_Course_Name ,
                                        TSBM.S_Batch_Name ,
                                        TSD.S_Student_ID ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS StdName ,
                                        TSD.S_Mobile_No ,
                                        TSED.I_Delivery ,
                                        TITM.Name ,
                                        TSED.EligibilityDate ,
                                        TSED.BarcodePrefix ,
                                        TSDSD.Barcode AS AssignedBarcode ,
                                        ISNULL(TSDSH.TrackingID, '') AS TrackingID ,
                                        TSED.IsApproved ,
                                        ISNULL(TSED.IsDispatched, 0) AS IsDispatched ,
                                        TSED.IsDelivered ,
                                        TSDH.StockDispatchHeaderName ,
                                        SUBSTRING(TSDSH.DispatchDocument, 0,
                                                  17) AS UniqueID ,
                                        TSD.S_Curr_Address1 + ' '
                                        + ISNULL(TCM2.S_City_Name, '') + ' '
                                        + ISNULL(TSM.S_State_Name, '') + ' '
                                        + ISNULL(TSD.S_Curr_Pincode, '') AS StdAddress ,
                                        TSED.ApprovedDate ,
                                        TSDSH.DispatchDate ,
                                        TSDSH.DeliveryDate
                                FROM    SMManagement.T_Student_Eligibity_Parent
                                        AS TSEP
                                        INNER JOIN SMManagement.T_Student_Eligibity_Details
                                        AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                                        INNER JOIN dbo.T_Student_Batch_Master
                                        AS TSBM ON TSBM.I_Batch_ID = TSEP.BatchID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                        AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                                        INNER JOIN SMManagement.T_ItemType_Master
                                        AS TITM ON TITM.ID = TSED.ItemType
                                        INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details
                                        AS TSDSD ON TSDSD.EligibilityDetailID = TSED.EligibilityDetailID
                                                    AND TSDSD.EligibilityHeaderID = TSED.EligibilityHeaderID
                                        INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                                        AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                                                    AND TSDSH.StudentDetailID = TSEP.StudentDetailID
                                        INNER JOIN SMManagement.T_Stock_Dispatch_Header
                                        AS TSDH ON TSDH.StockDispatchHeaderID = TSDSH.StockDispatchHeaderID
										INNER JOIN #temp AS T1 on T1.DispatchHeaderID=TSDSH.StockDispatchStudentHeaderID
										INNER JOIN (
                                        SELECT  FGCFR.centerID
                                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR ) as T2 on T2.centerID=TCHND.I_Center_ID
                                        LEFT JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TSD.I_Curr_State_ID
                                        LEFT JOIN dbo.T_City_Master AS TCM2 ON TCM2.I_City_ID = TSD.I_Curr_City_ID
                                WHERE   TSEP.StatusID IN ( 1, 0 )
                                        AND TSED.IsReturned = 1 
--                                        )
                                        --AND TSDSH.StockDispatchStudentHeaderID IN (
                                        --SELECT  T.DispatchHeaderID
                                        --FROM    #temp AS T )
                                        --AND TCHND.I_Center_ID IN (
                                        --SELECT  FGCFR.centerID
                                        --FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                        --                      @iBrandID) AS FGCFR )
                                --ORDER BY TCHND.S_Center_Name ,
                                --        TCM.S_Course_Name ,
                                --        TSBM.S_Batch_Name ,
                                --        TSD.S_Student_ID

                            END
                            
                            SELECT * FROM #FINAL AS F ORDER BY F.S_Center_Name,F.S_Course_Name,F.S_Batch_Name,F.S_Student_ID
                            
                            OPTION(RECOMPILE);
                            

    END
