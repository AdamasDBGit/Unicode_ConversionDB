  
    CREATE PROCEDURE [REPORT].[uspGetAttendanceData]  
        (
          @sHierarchyList VARCHAR(MAX) ,
          @sBrandID VARCHAR(MAX) ,
          @sBatchIDs VARCHAR(MAX) = NULL ,
          @dtStartDate DATETIME ,
          @dtEndDate DATETIME      
        )
    AS 
        BEGIN    
  
            DECLARE @iBrandID INT  
  
            SET @iBrandID = CAST(@sBrandID AS INT)  
    
            IF OBJECT_ID('tempdb..#StudentTable') IS NOT NULL 
                BEGIN  
                    DROP TABLE #StudentTable  
                END    
   
            IF OBJECT_ID('tempdb..#StdAtdScheduled') IS NOT NULL 
                BEGIN  
                    DROP TABLE #StdAtdScheduled  
                END   
   
            IF OBJECT_ID('tempdb..#StdAtd') IS NOT NULL 
                BEGIN  
                    DROP TABLE #StdAtd  
                END  
  
          
      
    --DECLARE @BatchScheduled TABLE (I_Batch_ID INT,SCHEDULED INT)      
    --INSERT INTO @BatchScheduled(I_Batch_ID, SCHEDULED)  
      
            DECLARE @BatchIDs TABLE ( I_Batch_ID INT )  
            INSERT  INTO @BatchIDs
                    ( I_Batch_ID  
                    )
                    SELECT  Val
                    FROM    dbo.fnString2Rows(@sBatchIDs, ',')  
         
            DECLARE @CenterIDs TABLE ( I_Center_ID INT ) --chck this @rtnTable1 has same data  
            INSERT  INTO @CenterIDs
                    ( I_Center_ID  
                    )
                    SELECT  CenterList.centerID
                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                       CAST(@sBrandID AS INT)) CenterList  
                                                 
            DECLARE @rtnTable1 TABLE
                (
                  brandID INT ,
                  hierarchyDetailID INT ,
                  centerID INT ,
                  centerCode VARCHAR(20) ,
                  centerName VARCHAR(100)
                )  
            INSERT  INTO @rtnTable1
                    ( hierarchyDetailID ,
                      centerID ,
                      centerCode ,
                      centerName  
                    )
                    SELECT  hierarchyDetailID ,
                            centerID ,
                            centerCode ,
                            centerName
                    FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                           @iBrandID)  
                                                 
            DECLARE @rtnTable2 TABLE
                (
                  hierarchyDetailID INT ,
                  instanceChain VARCHAR(5000)
                )  
            INSERT  INTO @rtnTable2
                    ( hierarchyDetailID ,
                      instanceChain  
                    )
                    SELECT  hierarchyDetailID ,
                            instanceChain
                    FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID)  
                                                                
                                                                
            CREATE TABLE #StudentTable
                (
                  instanceChain VARCHAR(5000) ,
                  S_Center_Name VARCHAR(100) ,
                  S_Batch_Name VARCHAR(100) ,
				  S_Batch_Code VARCHAR(MAX),
				  Dt_BatchStartDate DATETIME,
                  S_Course_Name VARCHAR(250) ,
                  I_Student_Detail_ID INT ,
                  S_Student_ID VARCHAR(500) ,
                  I_RollNo INT ,
                  S_First_Name VARCHAR(50) ,
                  S_Middle_Name VARCHAR(50) ,
                  S_Last_Name VARCHAR(50) ,
                  SCHEDULED INT ,
                  ATTENDED INT ,
                  S_Mobile_No VARCHAR(500) ,
                  PercentageAttended DECIMAL(18, 2) ,
                  S_Guardian_Phone_No VARCHAR(20) ,
                  I_Batch_ID INT
                )                                                           
  
            INSERT  INTO #StudentTable
                    SELECT DISTINCT       ---Gets the No Of Classes Scheduled for the batch   
                            FN2.instanceChain ,
                            F.S_Center_Name ,
                            C.S_Batch_Name ,
							C.S_Batch_Code,
							C.Dt_BatchStartDate,
                            H.S_Course_Name ,
                            A.I_Student_Detail_ID ,
                            A.S_Student_ID ,
                            ISNULL(B.I_RollNo,A.I_RollNo) AS I_RollNo ,
                            A.S_First_Name ,
                            ISNULL(A.S_Middle_Name, '') AS "S_Middle_Name" ,
                            A.S_Last_Name ,
                            NULL AS SCHEDULED ,
                            0 AS ATTENDED ,
                            A.S_Mobile_No ,
                            0 AS PercentageAttended ,
                            ISNULL(ISNULL(A.S_Guardian_Phone_No,
                                          A.S_Guardian_Mobile_No), '') AS S_Guardian_Phone_No ,
                            B.I_Batch_ID
                    FROM    T_Student_Detail A
                            INNER JOIN T_Student_Batch_Details B WITH ( NOLOCK ) ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              --AND B.I_Status = 1
                            INNER JOIN T_Student_Batch_Master C WITH ( NOLOCK ) ON C.I_Batch_ID = B.I_Batch_ID
                            INNER JOIN T_Center_Batch_Details E WITH ( NOLOCK ) ON E.I_Batch_ID = C.I_Batch_ID
                            INNER JOIN T_Center_Hierarchy_Name_Details F WITH ( NOLOCK ) ON F.I_Center_ID = E.I_Centre_Id
                            INNER JOIN @rtnTable1 FN1 ON F.I_Center_Id = FN1.CenterID
                            INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                            INNER JOIN T_Course_Center_Detail G WITH ( NOLOCK ) ON G.I_Centre_Id = F.I_Center_ID
                            INNER JOIN T_Course_Master H WITH ( NOLOCK ) ON C.I_Course_ID = H.I_Course_ID
                            INNER JOIN @CenterIDs ON [@CenterIDs].I_Center_ID = F.I_Center_ID
                    WHERE   ( @sBatchIDs IS NULL
                              OR B.I_Batch_ID IN ( SELECT   I_Batch_ID
                                                   FROM     @BatchIDs )
                            )
                            AND B.I_Status in (1,0,2) and (B.Dt_Valid_From<=@dtEndDate and ISNULL(B.Dt_Valid_To,GETDATE())>=ISNULL(@dtEndDate,GETDATE()))
                    GROUP BY A.I_Student_Detail_ID ,
                            A.S_Student_ID ,
                            A.S_First_Name ,
                            A.S_Middle_Name ,
                            ISNULL(B.I_RollNo,A.I_RollNo) ,
                            A.S_Last_Name ,
                            C.S_Batch_Name ,
							C.S_Batch_Code,
							C.Dt_BatchStartDate,
                            F.S_Center_Name ,
                            H.S_Course_Name ,
                            A.S_Mobile_No ,
                            A.S_Guardian_Phone_No ,
                            a.S_Guardian_Mobile_No ,
                            FN2.instanceChain ,
                            B.I_Batch_ID  
     
      
      
    --CREATE INDEX IDX_Student_ID_1 ON #StudentTable(I_Student_Detail_ID)  
      
    --CREATE INDEX IDX_Batch_ID_1 ON #StudentTable(I_Batch_ID)  
      
            CREATE TABLE #StdAtdScheduled
                (
                  I_Student_Detail_ID INT ,
                  I_Batch_ID INT ,
                  SCHEDULED INT
                )  
      
            CREATE TABLE #StdAtd
                (
                  I_Batch_ID INT ,
                  I_Student_Detail_ID INT ,
                  S_Student_ID VARCHAR(500) ,
                  ATTENDED INT
                )  
      
      
      
      
            INSERT  INTO #StdAtdScheduled
                    SELECT  IT.I_Student_Detail_ID ,
                            B.I_Batch_ID ,
                            ( SELECT    COUNT(Dt_Schedule_Date)
                              FROM      T_TimeTable_Master TTM
                              WHERE     TTM.I_Batch_ID = B.I_Batch_ID
                                        AND DATEDIFF(dd, Dt_Schedule_Date,
                                                     @dtStartDate) <= 0
                                        AND DATEDIFF(dd, Dt_Schedule_Date,
                                                     @dtEndDate) >= 0
										AND TTM.I_Status=1
                            )
                    FROM    #StudentTable IT
                            INNER JOIN T_Student_Batch_Details B WITH ( NOLOCK ) ON B.I_Student_ID = IT.I_Student_Detail_ID
                    WHERE   B.I_Status in (1,0,2) and (B.Dt_Valid_From<=@dtEndDate and ISNULL(B.Dt_Valid_To,GETDATE())>=ISNULL(@dtEndDate,GETDATE()))  
    
    --CREATE INDEX IDX_Student_ID_2 ON #StdAtdScheduled(I_Student_Detail_ID)  
      
    --CREATE INDEX IDX_Batch_ID_2 ON #StdAtdScheduled(I_Batch_ID)  
   
            UPDATE  T
            SET     T.SCHEDULED = NULLIF(M.SCHEDULED, 0)
            FROM    #StudentTable T
                    INNER JOIN #StdAtdScheduled M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
                                                     AND T.I_Batch_ID = M.I_Batch_ID  
      
     
            INSERT  INTO #StdAtd
                    SELECT  C.I_Batch_ID ,
                            A.I_Student_Detail_ID ,
                            A.S_Student_ID ,
                            COUNT(DISTINCT E.I_TimeTable_ID)
                    FROM    #StudentTable A
                            INNER JOIN T_Student_Batch_Details B WITH ( NOLOCK ) ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              AND B.I_Status in (1,0,2) and (B.Dt_Valid_From<=@dtEndDate and ISNULL(B.Dt_Valid_To,GETDATE())>=ISNULL(@dtEndDate,GETDATE()))
                            INNER JOIN T_Center_Batch_Details C WITH ( NOLOCK ) ON C.I_Batch_ID = B.I_Batch_ID  
                        --INNER JOIN T_Center_Hierarchy_Name_Details D WITH (NOLOCK) ON D.I_Center_ID = C.I_Centre_Id  
                            INNER JOIN T_Student_Attendance E  ON B.I_Student_ID = E.I_Student_Detail_ID
                            INNER JOIN dbo.T_TimeTable_Master TTTM WITH ( NOLOCK ) ON E.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                                              AND TTTM.I_Status = 1
                    WHERE   DATEDIFF(dd, Dt_Schedule_Date, @dtStartDate) <= 0
                            AND DATEDIFF(dd, Dt_Schedule_Date, @dtEndDate) >= 0  
                        --AND D.I_Center_ID IN (  
                        --SELECT  CenterList.centerID  
                        --FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
                        --                                   CAST(@sBrandID AS INT)) CenterList )  
                    GROUP BY S_Student_ID ,
                            A.I_Student_Detail_ID ,
                            C.I_Batch_ID  
                 
           
    --CREATE INDEX IDX_Student_ID_3 ON #StdAtd(I_Student_Detail_ID)  
     
            UPDATE  T
            SET     T.ATTENDED = M.ATTENDED ,
                    T.PercentageAttended = ( ISNULL(ROUND(( CONVERT(DECIMAL, M.ATTENDED)
                                                            / CONVERT(DECIMAL, T.SCHEDULED) )
                                                          * 100, 2), 0) )
            FROM    #StudentTable T
                    INNER JOIN #StdAtd M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID  
      
     
      
            SELECT  instanceChain ,
                    S_Center_Name ,
                    S_Batch_Name ,
					S_Batch_Code,
					Dt_BatchStartDate,
                    S_Course_Name ,
                    I_Student_Detail_ID ,
                    S_Student_ID ,
                    I_RollNo ,
                    S_First_Name ,
                    S_Middle_Name ,
                    S_Last_Name ,
                    SCHEDULED ,
                    ATTENDED ,
                    S_Mobile_No ,
                    PercentageAttended ,
                    S_Guardian_Phone_No ,
                    S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                    + ISNULL(S_Last_Name, '') AS Student_Name
            FROM    #StudentTable

            ORDER BY S_Center_Name ,
                    I_RollNo      
      
            DROP TABLE #StudentTable  
      
            DROP TABLE #StdAtdScheduled  
      
            DROP TABLE #StdAtd  
    
        END
