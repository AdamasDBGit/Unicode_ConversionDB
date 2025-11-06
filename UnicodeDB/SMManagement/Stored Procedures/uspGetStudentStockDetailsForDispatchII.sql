CREATE PROCEDURE [SMManagement].[uspGetStudentStockDetailsForDispatchII]
    (
      @StockDispatchHeaderID INT
    )
AS
    BEGIN
    
        CREATE TABLE #STDISDETAILS
            (
              StockDispatchHeaderID INT ,
              StockDispatchStudentHeaderID INT ,
              I_Student_Detail_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              StdName VARCHAR(MAX) ,
              StockDispatchStudentDetailID INT ,
              EligibilityHeaderID INT ,
              EligibilityDetailID INT ,
              I_Delivery INT ,
              ItemType INT ,
              ItemTypeName VARCHAR(MAX) ,
              BarcodePrefix VARCHAR(MAX) ,
              CenterID INT ,
              S_Center_Name VARCHAR(MAX) ,
              CourseID INT ,
              S_Course_Name VARCHAR(MAX) ,
              IsScheduled BIT ,
              StockID INT ,
              ItemCode VARCHAR(MAX) ,
              ItemDesc VARCHAR(MAX) ,
              Barcode VARCHAR(MAX) ,
              TrackingID VARCHAR(MAX)
            )	
		
        BEGIN TRY
            --BEGIN TRANSACTION
		
            INSERT  INTO #STDISDETAILS
                    ( StockDispatchHeaderID ,
                      StockDispatchStudentHeaderID ,
                      I_Student_Detail_ID ,
                      S_Student_ID ,
                      StdName ,
                      StockDispatchStudentDetailID ,
                      EligibilityHeaderID ,
                      EligibilityDetailID ,
                      I_Delivery ,
                      ItemType ,
                      ItemTypeName ,
                      BarcodePrefix ,
                      CenterID ,
                      S_Center_Name ,
                      CourseID ,
                      S_Course_Name ,
                      StockID ,
                      ItemCode ,
                      ItemDesc ,
                      Barcode ,
                      TrackingID ,
                      IsScheduled 
		            )
                    SELECT  TSDH.StockDispatchHeaderID ,
                            TSDSH.StockDispatchStudentHeaderID ,
                            TSD.I_Student_Detail_ID ,
                            TSD.S_Student_ID ,
                            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,
                                                            '') + ' '
                            + TSD.S_Last_Name AS StdName ,
                            TSDSD.StockDispatchStudentDetailID ,
                            TSEP.EligibilityHeaderID ,
                            TSED.EligibilityDetailID ,
                            TSED.I_Delivery ,
                            TSED.ItemType ,
                            TITM.Name AS ItemTypeName ,
                            TSED.BarcodePrefix ,
                            TSEP.CenterID ,
                            TCHND.S_Center_Name ,
                            TSEP.CourseID ,
                            TCM.S_Course_Name ,
                            TSDSD.StockID ,
                            TSM.ItemCode ,
                            TSM.ItemDescription ,
                            TSDSD.Barcode ,
                            TSDSH.TrackingID ,
                            TSEP.IsScheduled
                    FROM    SMManagement.T_Stock_Dispatch_Header AS TSDH
                            INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                            AS TSDSH ON TSDSH.StockDispatchHeaderID = TSDH.StockDispatchHeaderID
                            INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details
                            AS TSDSD ON TSDSD.StockDispatchStudentHeaderID = TSDSH.StockDispatchStudentHeaderID
                            INNER JOIN SMManagement.T_Student_Eligibity_Details
                            AS TSED ON TSED.EligibilityDetailID = TSDSD.EligibilityDetailID
                                       AND TSED.EligibilityHeaderID = TSDSD.EligibilityHeaderID
                            INNER JOIN SMManagement.T_Student_Eligibity_Parent
                            AS TSEP ON TSEP.EligibilityHeaderID = TSED.EligibilityHeaderID
                                       AND TSEP.EligibilityHeaderID = TSDSD.EligibilityHeaderID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSEP.CenterID
                            INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSEP.CourseID
                            INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSEP.StudentDetailID
                                                              AND TSDSH.StudentDetailID = TSD.I_Student_Detail_ID
                            INNER JOIN SMManagement.T_ItemType_Master AS TITM ON TSED.ItemType = TITM.ID
                            INNER JOIN SMManagement.T_Stock_Master AS TSM ON TSM.StockID = TSDSD.StockID
                    WHERE   TSDH.StatusID = 1
                            AND ISNULL(TSDH.IsDispatched, 0) = 1
                            AND TSDSH.StatusID = 1
                            AND ISNULL(TSDSH.IsDispatched, 0) = 1
                            --AND TSEP.StatusID = 1
                            AND ISNULL(TSED.IsApproved, 0) = 1
                            AND ISNULL(TSED.IsDelivered, 0) = 0
                            AND ISNULL(TSDSH.IsDelivered, 0) = 0
                            AND TSDH.StockDispatchHeaderID = @StockDispatchHeaderID
            /*    
            DECLARE @sdsdID INT
            DECLARE @ehID INT
            DECLARE @edID INT
            DECLARE @itype INT
            DECLARE @bprefix VARCHAR(10)
            DECLARE @courseID INT
            DECLARE @isScheduled BIT
                
            DECLARE AssignStock CURSOR
            FOR
                SELECT  S.StockDispatchStudentDetailID ,
                        S.EligibilityHeaderID ,
                        S.EligibilityDetailID ,
                        S.ItemType ,
                        S.BarcodePrefix ,
                        S.CourseID ,
                        S.IsScheduled
                FROM    #STDISDETAILS AS S WHERE S.Barcode IS NULL
                
            OPEN AssignStock
            FETCH NEXT FROM AssignStock INTO @sdsdID, @ehID, @edID, @itype,
                @bprefix, @courseID, @isScheduled
                
                
            WHILE @@FETCH_STATUS = 0
                BEGIN
                
                    UPDATE  T1
                    SET     T1.StockID = T2.StockID ,
                            T1.ItemCode = T2.ItemCode ,
                            T1.ItemDesc = T2.ItemDescription ,
                            T1.Barcode = T2.Barcode
                    FROM    #STDISDETAILS AS T1
                            INNER JOIN ( SELECT TOP 1
                                                @sdsdID AS StockDispatchID ,
                                                @ehID AS EligibilityHeaderID ,
                                                @edID AS EligibilityDetailID ,
                                                TSM.StockID ,
                                                TSM.ItemCode ,
                                                TSM.ItemDescription ,
                                                TSM.Barcode
                                         FROM   SMManagement.T_Stock_Master AS TSM
                                                INNER JOIN SMManagement.T_ItemType_Master
                                                AS TITM ON TSM.ItemType = TITM.ID
                                                INNER JOIN SMManagement.T_Item_Course_Mapping
                                                AS TICM ON TICM.ItemCode = TSM.ItemCode
                                         WHERE  TSM.ItemType = @itype
                                                AND TSM.BarcodePrefix = @bprefix COLLATE Latin1_General_CI_AI
                                                AND TICM.CourseID = @courseID --COLLATE Latin1_General_CI_AI
                                                AND TSM.StatusID = 1
                                                AND TITM.StatusID = 1
                                                AND TICM.StatusID = 1
                                                AND TSM.IsScheduled = @isScheduled --COLLATE Latin1_General_CI_AI
                                                AND TSM.LocationID = -1
                                                AND TSM.Barcode NOT IN (
                                                SELECT  ISNULL(S.Barcode, '') COLLATE Latin1_General_CI_AI
                                                FROM    #STDISDETAILS AS S )
                                       ) T2 ON T2.EligibilityHeaderID = T1.EligibilityHeaderID
                                               AND T2.EligibilityDetailID = T1.EligibilityDetailID
                                               AND T1.StockDispatchStudentDetailID = T2.StockDispatchID
                
                
                    FETCH NEXT FROM AssignStock INTO @sdsdID, @ehID, @edID,
                        @itype, @bprefix, @courseID, @isScheduled
                
                END
                
           */
           
            --SELECT  *
            --FROM    #STDISDETAILS AS S
            UPDATE  #STDISDETAILS
            SET     StockID = -1 ,
                    ItemCode = '' ,
                    ItemDesc = '' ,
                    Barcode = ''
            WHERE   StockID IS NULL    
            --COMMIT TRANSACTION
            
            SELECT  *
            FROM    #STDISDETAILS AS S
            ORDER BY S.S_Student_ID
            --WHERE   S.Barcode != ''
            
            
            SELECT  TSD.I_Student_Detail_ID ,
                    TSD.S_Student_ID ,
                    TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                    + ' ' + TSD.S_Last_Name AS StudentName ,
                    --CASE WHEN ISNULL(TPL.Pincode,'')!='' THEN TSD.S_Curr_Address1 ELSE '' END AS S_Curr_Address1 , --modified on 12.9.2020
					TSD.S_Curr_Address1, --added on 12.9.2020
                    ISNULL(TSM.S_State_Name, '') AS StateName ,
                    ISNULL(TCM.S_City_Name, '') AS City ,
                    TSD.S_Curr_Pincode ,
                    TSD.S_Mobile_No ,
                    ISNULL(T1.TrackingID,'') AS TrackingID ,
                    T3.S_Batch_Name ,
                    TCM2.S_Center_Name,
                    TCA.S_Center_Address1+', Contact No.: '+TCA.S_Telephone_No AS CentreAddress,
                    ISNULL(T3.I_RollNo,TSD.I_RollNo) AS RollNo
            FROM    dbo.T_Student_Detail AS TSD
                    INNER JOIN ( SELECT DISTINCT
                                        S.I_Student_Detail_ID ,
                                        S.TrackingID
                                 FROM   #STDISDETAILS AS S
                                 WHERE  S.Barcode != ''
                               ) AS T1 ON T1.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                    LEFT JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              AND TSCD.I_Student_Detail_ID = T1.I_Student_Detail_ID
                                                              AND TSCD.I_Status = 1
                    LEFT JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TSCD.I_Centre_Id
                    LEFT JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = TSCD.I_Centre_Id
                    LEFT JOIN ( SELECT  TSBD2.I_Student_ID ,
                                        TSBM2.S_Batch_Name,
                                        TSBD2.I_RollNo
                                FROM    dbo.T_Student_Batch_Master AS TSBM2
                                        INNER JOIN dbo.T_Student_Batch_Details
                                        AS TSBD2 ON TSBD2.I_Batch_ID = TSBM2.I_Batch_ID
                                        INNER JOIN ( SELECT TSBD.I_Student_ID ,
                                                            MAX(TSBD.I_Student_Batch_ID) AS MaxID
                                                     FROM   dbo.T_Student_Batch_Details
                                                            AS TSBD
                                                            INNER JOIN dbo.T_Student_Batch_Master
                                                            AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                                                            INNER JOIN ( SELECT DISTINCT
                                                              TCDSM.CourseID
                                                              FROM
                                                              SMManagement.T_Centre_Dispatch_Scheme_Map
                                                              AS TCDSM
                                                              WHERE
                                                              TCDSM.StatusID = 1
                                                              ) TX ON TX.CourseID = TSBM.I_Course_ID
                                                     WHERE  TSBD.I_Status = 1
                                                     GROUP BY TSBD.I_Student_ID
                                                   ) T2 ON TSBD2.I_Student_Batch_ID = T2.MaxID
                                                           AND T2.I_Student_ID = TSBD2.I_Student_ID
                              ) T3 ON T1.I_Student_Detail_ID = T3.I_Student_ID
                    LEFT JOIN dbo.T_State_Master AS TSM ON TSD.I_Curr_State_ID = TSM.I_State_ID
                    LEFT JOIN dbo.T_City_Master AS TCM ON TCM.I_City_ID = TSD.I_Curr_City_ID
                    LEFT JOIN SMManagement.T_PincodeList AS TPL ON TSD.S_Curr_Pincode=TPL.Pincode AND TPL.StatusID=1

            ORDER BY TSD.S_Student_ID
            
        END TRY
                
        BEGIN CATCH
    

	--Error occurred:  
            ROLLBACK TRANSACTION
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT
            SELECT  @ErrMsg = ERROR_MESSAGE() ,
                    @ErrSeverity = ERROR_SEVERITY()

            RAISERROR(@ErrMsg, @ErrSeverity, 1)
        END CATCH
                

    END
