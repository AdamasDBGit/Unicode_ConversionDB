--EXEC [REPORT].[uspGetEnquiryEnrollmentHierarchyBatchReportDetails]  '127',109,NULL,'06-01-2013','09-01-2013','12',null

CREATE PROCEDURE [REPORT].[uspGetEnquiryEnrollmentHierarchyBatchReportDetails]
    (
      @sHierarchyID VARCHAR(MAX) ,
      @sBrandID VARCHAR(20) ,
      @sCenterIDs VARCHAR(MAX) = NULL ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @sCourseIDs VARCHAR(MAX) = NULL ,
      @sBatchIDs VARCHAR(MAX) = NULL  
    )
AS 
    BEGIN  
   
        DECLARE @EEBCINITIAL TABLE
            (
              I_CENTRE_ID INT ,
              CENTERCODE VARCHAR(20) ,
              CENTERNAME VARCHAR(100) ,
              S_CURRENCY_CODE VARCHAR(20)
            )  
  
        DECLARE @EEBCANALYSIS TABLE
            (
              I_CENTRE_ID INT ,
              CENTERCODE VARCHAR(20) ,
              S_CURRENCY_CODE VARCHAR(20) ,
              S_COURSE_FAMILY VARCHAR(50) ,
              I_COURSE_ID INT ,
              S_COURSE VARCHAR(250) ,
              I_BATCH_ID INT ,
              S_BATCH_CODE VARCHAR(50) ,
              S_BATCH_NAME VARCHAR(250) ,
              I_Status VARCHAR(20) ,
              TOTAL_ENQ INT ,
              OPEN_REG INT ,
              CLOSE_REG INT ,
              TOTAL_REGISTRATION INT ,
              TOTAL_ENROLL INT ,
              INVOICE_AMOUNT NUMERIC(18, 2) ,
              COLLECTION_AMOUNT NUMERIC(18, 2) ,
              INVOICE_TAX_AMOUNT NUMERIC(18, 2) ,
              COLLECTION_TAX_AMOUNT NUMERIC(18, 2)
            )  
   
        DECLARE @EEBCANALYSIS1 TABLE
            (
              I_CENTRE_ID INT ,
              CENTERCODE VARCHAR(20) ,
              S_CURRENCY_CODE VARCHAR(20) ,
              S_COURSE_FAMILY VARCHAR(50) ,
              I_COURSE_ID INT ,
              S_COURSE VARCHAR(250)
            )  
  
        DECLARE @index INT ,
            @rowCount INT ,
            @iTempCenterID INT  
        DECLARE @tblCenter TABLE ( CenterId INT )    
        DECLARE @tblCourse TABLE ( CourseID INT )  
        DECLARE @tblBatch TABLE ( BatchID INT ) 
 
        DECLARE @S_Instance_Chain VARCHAR(500)
	
        SELECT TOP 1
                @S_Instance_Chain = FN2.instanceChain
        FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyID,
                                                         @sBrandID) FN2
        WHERE   FN2.HierarchyDetailID IN (
                SELECT  HierarchyDetailID
                FROM    [fnGetCentersForReports](@sHierarchyID, @sBrandID) ) 
   
   
        INSERT  INTO @tblCenter
                SELECT  CAST([Val] AS INT)
                FROM    [dbo].[fnString2Rows](@sCenterIDs, ',') AS FSR  
   
        IF ( ( SELECT   COUNT([CenterId])
               FROM     @tblCenter
             ) = 0 ) 
            BEGIN  
                INSERT  INTO @tblCenter
                        SELECT  centerID
                        FROM    [dbo].fnGetCentersForReports(@sHierarchyID,
                                                             CAST(@sBrandID AS INT))
                                AS FGCIFH  
            END  
   
        INSERT  INTO @tblCourse
                SELECT  CAST([Val] AS INT)
                FROM    [dbo].[fnString2Rows](@sCourseIDs, ',') AS FSR  
   
        IF ( ( SELECT   COUNT([CourseID])
               FROM     @tblCourse
             ) = 0 ) 
            BEGIN  
                INSERT  INTO @tblCourse
                        SELECT  I_Course_ID
                        FROM    [dbo].T_Course_Master AS FGCIFH  
            END  
  
        INSERT  INTO @tblBatch
                SELECT  CAST([Val] AS INT)
                FROM    [dbo].[fnString2Rows](@sBatchIDs, ',') AS FSR  
   
        IF ( ( SELECT   COUNT([BatchID])
               FROM     @tblBatch
             ) = 0 ) 
            BEGIN  
                INSERT  INTO @tblBatch
                        SELECT DISTINCT
                                I_Batch_ID
                        FROM    [dbo].T_Center_Batch_Details AS FGCIFH
                        WHERE   FGCIFH.I_Centre_Id IN ( SELECT
                                                              [CenterId]
                                                        FROM  @tblCenter )  
            END  
   
        INSERT  INTO @EEBCINITIAL
                SELECT DISTINCT
                        FN1.CENTERID ,
                        TCM.[S_Center_Code] AS CENTERCODE ,
                        TCM.[S_Center_Name] AS CENTERNAME ,
                        CUM.S_CURRENCY_CODE
                FROM    @tblCenter FN1
                        INNER JOIN [dbo].[T_Centre_Master] AS TCM WITH ( NOLOCK ) ON [FN1].[CenterId] = [TCM].[I_Centre_Id]
                        INNER JOIN DBO.T_COUNTRY_MASTER COM WITH ( NOLOCK ) ON TCM.[I_Country_ID] = COM.I_COUNTRY_ID
                        INNER JOIN DBO.T_CURRENCY_MASTER CUM WITH ( NOLOCK ) ON COM.I_CURRENCY_ID = CUM.I_CURRENCY_ID
                ORDER BY CENTERID  
   
        INSERT  INTO @EEBCANALYSIS1
                ( I_CENTRE_ID ,
                  CENTERCODE ,
                  S_CURRENCY_CODE ,
                  I_COURSE_ID ,
                  S_COURSE ,
                  S_COURSE_FAMILY
                )
                ( SELECT    A.I_CENTRE_ID ,
                            A.CENTERCODE ,
                            A.S_CURRENCY_CODE ,
                            TC.CourseID ,
                            TCM.S_Course_Name ,
                            TCFM.S_CourseFamily_Name
                  FROM      DBO.T_ENQUIRY_REGN_DETAIL C WITH ( NOLOCK )
                            INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID = C.I_CENTRE_ID
                            INNER JOIN [dbo].[T_Enquiry_Course] AS TEC WITH ( NOLOCK ) ON [C].[I_Enquiry_Regn_ID] = [TEC].[I_Enquiry_Regn_ID]
                            INNER JOIN @tblCourse TC ON TC.CourseID = [TEC].[I_Course_ID]
                            INNER JOIN [dbo].[T_Course_Master] AS TCM WITH ( NOLOCK ) ON [TEC].[I_Course_ID] = [TCM].[I_Course_ID]
                            INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM
                            WITH ( NOLOCK ) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]
                  WHERE     C.I_ENQUIRY_STATUS_CODE <> 0
                            AND ( DATEDIFF(DD, [C].[Dt_Crtd_On], @dtStartDate) <= 0
                                  AND DATEDIFF(DD, @dtEndDate,
                                               [C].[Dt_Crtd_On]) <= 0
                                )
                            AND ( DATEDIFF(DD, [C].[Dt_Crtd_On], @dtStartDate) <= 0
                                  AND DATEDIFF(DD, @dtEndDate,
                                               [C].[Dt_Crtd_On]) <= 0
                                )
                )  
 
        INSERT  INTO @EEBCANALYSIS
                ( I_CENTRE_ID ,
                  CENTERCODE ,
                  S_CURRENCY_CODE ,
                  S_COURSE_FAMILY ,
                  I_COURSE_ID ,
                  S_COURSE ,
                  I_BATCH_ID ,
                  S_BATCH_CODE ,
                  S_BATCH_NAME ,
                  I_Status  
                )
                SELECT DISTINCT
                        E.* ,
                        CBD.I_Batch_ID ,
                        SBM.S_Batch_Code ,
                        SBM.S_Batch_Name ,
                        CASE WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 6
                             THEN 'Enrollment Full'
                             WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 5
                             THEN 'Completed'
                             WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 4
                             THEN 'Can Enroll'
                             WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 3
                             THEN 'Rejected'
                             WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 2
                             THEN 'Approved'
                             WHEN ISNULL(CBD.I_Status, SBM.I_Status) = 1
                             THEN 'Created'
                             ELSE 'Inactive'
                        END
                FROM    @EEBCANALYSIS1 E
                        INNER JOIN dbo.T_Center_Batch_Details CBD ON E.I_CENTRE_ID = CBD.I_Centre_Id
                        INNER JOIN T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID
                                                              AND CBD.I_Batch_ID = SBM.I_Batch_ID
                WHERE   CBD.I_Centre_Id IN ( SELECT *
                                             FROM   @tblCenter )
                        AND SBM.I_Course_ID IN ( SELECT *
                                                 FROM   @tblCourse )
                        AND CBD.I_Batch_ID IN ( SELECT  *
                                                FROM    @tblBatch )   
    
  
  ----SELECT DISTINCT E.*,CBD.I_Batch_ID,SBM.S_Batch_Code,SBM.S_Batch_Name   
  ----FROM @EEBCANALYSIS1 E  
  ----INNER JOIN @tblCourse C ON E.I_COURSE_ID=C.CourseID  
  ----INNER JOIN dbo.T_Center_Batch_Details CBD ON E.I_CENTRE_ID=CBD.I_Centre_Id  
  ----INNER JOIN @tblCenter CN ON CBD.I_Centre_Id=CN.CenterId  
  ----INNER JOIN @tblBatch B ON CBD.I_Batch_ID=B.BatchID  
  ----INNER JOIN T_Student_Batch_Master SBM ON B.BatchID=SBM.I_Batch_ID  
  ----AND CBD.I_Batch_ID = SBM.I_Batch_ID  
   
 --UPDATE @EEBCANALYSIS SET TOTAL_ENQ = ISNULL(Z.TOT_ENQ,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(  
 -- SELECT A.I_CENTRE_ID CID,TC.CourseID,TB.BatchID,COUNT(DISTINCT ERD.I_Enquiry_Regn_ID) TOT_ENQ  
 -- FROM @EEBCINITIAL A  
 -- INNER JOIN DBO.T_Student_Registration_Details SRD WITH(NOLOCK)  
 -- ON SRD.I_DESTINATION_CENTER_ID=A.I_CENTRE_ID  
 -- INNER JOIN DBO.T_Enquiry_Regn_Detail ERD ON SRD.I_Enquiry_Regn_ID=SRD.I_Enquiry_Regn_ID  
 -- INNER JOIN DBO.T_Enquiry_Course EC ON SRD.I_Enquiry_Regn_ID = EC.I_Enquiry_Regn_ID  
 -- INNER JOIN @tblCourse TC ON TC.CourseID = EC.[I_Course_ID]  
 -- INNER JOIN @tblBatch TB ON SRD.I_Batch_ID=TB.BatchID  
 -- INNER JOIN dbo.T_Student_Batch_Master SBM ON tb.BatchID=sbm.I_Batch_ID  
 -- INNER JOIN  
 -- (   
 -- SELECT EC.I_Course_ID,min(SBM.Dt_BatchStartDate) StartDate  
 -- FROM dbo.T_Enquiry_Regn_Detail ERD  
 -- INNER JOIN DBO.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID = EC.I_Enquiry_Regn_ID  
 -- INNER JOIN dbo.T_Student_Registration_Details SRD ON ERD.I_Enquiry_Regn_ID=SRD.I_Enquiry_Regn_ID   
 -- INNER JOIN DBO.T_Student_Batch_Master SBM ON SRD.I_Batch_ID = SBM.I_Batch_ID  
 -- WHERE (DATEDIFF(DD,ERD.Dt_Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,ERD.Dt_Crtd_On) <= 0)  
 -- GROUP BY EC.I_Course_ID  
 -- )  
 -- AS LATEST ON SBM.I_Course_ID = LATEST.I_Course_ID  
 -- AND SBM.Dt_BatchStartDate=LATEST.StartDate  
 -- WHERE (DATEDIFF(DD,ERD.Dt_Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,ERD.Dt_Crtd_On) <= 0)  
 -- GROUP BY A.I_CENTRE_ID, TC.CourseID,TB.BatchID  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.I_BATCH_ID=Z.BatchID  
    
  
 --UPDATE @EEBCANALYSIS SET OPEN_REG = ISNULL(Z.CNT,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(  
 --SELECT A.I_CENTRE_ID CID,TC.CourseID,TB.BatchID,COUNT(DISTINCT SRD.I_ENQUIRY_REGN_ID) CNT  
 --FROM @EEBCINITIAL A  
 --INNER JOIN DBO.T_Student_Registration_Details SRD WITH(NOLOCK)  
 --ON SRD.I_DESTINATION_CENTER_ID=A.I_CENTRE_ID  
 --INNER JOIN [dbo].[T_Student_Batch_Master] TSBM ON TSBM.I_Batch_ID = SRD.I_Batch_ID  
 --INNER JOIN @tblCourse TC ON TC.CourseID = [TSBM].[I_Course_ID]  
 --INNER JOIN @tblBatch TB ON SRD.I_Batch_ID=TB.BatchID  
 ----WHERE SRD.[I_Enquiry_Regn_ID] NOT IN (  
 ---- SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD WITH(NOLOCK)  
 ---- INNER JOIN [dbo].[T_Student_Detail] AS TSD WITH(NOLOCK)  
 ---- ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]  
 ---- WHERE [TSD].[I_Student_Detail_ID] IN   
 ---- (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK)))  
 --WHERE (DATEDIFF(DD,SRD.[Crtd_On],@dtStartDate) <= 0   
 --AND DATEDIFF(DD,@dtEndDate,SRD.[Crtd_On]) <= 0)  
 --AND SRD.I_Status=1  
 --GROUP BY A.I_CENTRE_ID, TC.CourseID,TB.BatchID  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.I_BATCH_ID=Z.BatchID  
  
 --UPDATE @EEBCANALYSIS SET CLOSE_REG = ISNULL(Z.CNT,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(  
 --SELECT A.I_CENTRE_ID CID,TC.CourseID,TB.BatchID,COUNT(DISTINCT SRD.I_ENQUIRY_REGN_ID) CNT  
 --FROM @EEBCINITIAL A  
 --INNER JOIN DBO.T_Student_Registration_Details SRD WITH(NOLOCK)  
 --ON SRD.I_DESTINATION_CENTER_ID=A.I_CENTRE_ID  
 --INNER JOIN [dbo].[T_Student_Batch_Master] TSBM ON TSBM.I_Batch_ID = SRD.I_Batch_ID  
 --INNER JOIN DBO.T_Student_Detail SD ON SRD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID  
 --INNER JOIN @tblCourse TC ON TC.CourseID = [TSBM].[I_Course_ID]  
 --INNER JOIN @tblBatch TB ON SRD.I_Batch_ID=TB.BatchID  
 ----WHERE SRD.[I_Enquiry_Regn_ID] NOT IN (  
 ---- SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD WITH(NOLOCK)  
 ---- INNER JOIN [dbo].[T_Student_Detail] AS TSD WITH(NOLOCK)  
 ---- ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]  
 ---- WHERE [TSD].[I_Student_Detail_ID] IN   
 ---- (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK)))  
 --WHERE (DATEDIFF(DD,SRD.[Crtd_On],@dtStartDate) <= 0   
 --AND DATEDIFF(DD,@dtEndDate,SRD.[Crtd_On]) <= 0)  
 --AND SRD.I_Status=0  
 --GROUP BY A.I_CENTRE_ID, TC.CourseID,TB.BatchID  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.I_BATCH_ID=Z.BatchID  
  
    
 --UPDATE @EEBCANALYSIS SET TOTAL_REGISTRATION = ISNULL(Z.CNT,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(  
 --SELECT A.I_CENTRE_ID CID,TC.CourseID,TB.BatchID,COUNT(DISTINCT SRD.I_ENQUIRY_REGN_ID) CNT  
 --FROM @EEBCINITIAL A  
 --INNER JOIN DBO.T_Student_Registration_Details SRD WITH(NOLOCK)  
 --ON SRD.I_DESTINATION_CENTER_ID=A.I_CENTRE_ID  
 --INNER JOIN [dbo].[T_Student_Batch_Master] TSBM ON TSBM.I_Batch_ID = SRD.I_Batch_ID  
 --INNER JOIN @tblCourse TC ON TC.CourseID = [TSBM].[I_Course_ID]  
 --INNER JOIN @tblBatch TB ON SRD.I_Batch_ID=TB.BatchID  
 ----WHERE SRD.[I_Enquiry_Regn_ID] NOT IN (  
 ---- SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD WITH(NOLOCK)  
 ---- INNER JOIN [dbo].[T_Student_Detail] AS TSD WITH(NOLOCK)  
 ---- ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]  
 ---- WHERE [TSD].[I_Student_Detail_ID] IN   
 ---- (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK)))  
 --WHERE (DATEDIFF(DD,SRD.[Crtd_On],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,SRD.[Crtd_On]) <= 0)  
 --GROUP BY A.I_CENTRE_ID, TC.CourseID,TB.BatchID  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.I_BATCH_ID=Z.BatchID  
   
        UPDATE  @EEBCANALYSIS
        SET     TOTAL_ENROLL = ISNULL(Z.CNT, 0)
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID ,
                                    COUNT(DISTINCT IP.I_STUDENT_DETAIL_ID) CNT
                             FROM   @EEBCINITIAL A
                                    INNER JOIN DBO.T_INVOICE_PARENT IP WITH ( NOLOCK ) ON IP.[I_Centre_Id] = A.I_CENTRE_ID
                                    INNER JOIN [dbo].[T_Invoice_Child_Header]
                                    AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]
                                    INNER JOIN @tblCourse TC ON TC.CourseID = [TICH].[I_Course_ID]
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON IP.I_Student_Detail_ID = SBD.I_Student_ID
                             WHERE  IP.[I_Student_Detail_ID] NOT IN (
                                    SELECT  [TCSIM].[I_Student_Detail_ID]
                                    FROM    [dbo].[T_Corp_Student_Invoice_Map]
                                            AS TCSIM WITH ( NOLOCK ) )
                                    AND ( DATEDIFF(DD, IP.[Dt_Invoice_Date],
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       IP.[Dt_Invoice_Date]) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
   
        UPDATE  @EEBCANALYSIS
        SET     INVOICE_AMOUNT = ISNULL(Z.SUM1, 0) ,
                INVOICE_TAX_AMOUNT = ISNULL(Z.SUM2, 0)
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID ,
                                    SUM(ISNULL([TICH].[N_Amount], 0)) SUM1 ,
                                    SUM(ISNULL([TICH].[N_Tax_Amount], 0)) SUM2
                             FROM   @EEBCINITIAL A
                                    INNER JOIN DBO.T_INVOICE_PARENT IP WITH ( NOLOCK ) ON A.I_CENTRE_ID = IP.I_CENTRE_ID --AND IP.I_STATUS = 1  
                                    INNER JOIN [dbo].[T_Invoice_Child_Header]
                                    AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]
                                    INNER JOIN @tblCourse TC ON TC.CourseID = [TICH].[I_Course_ID]
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON IP.I_Student_Detail_ID = SBD.I_Student_ID
                             WHERE  IP.[I_Student_Detail_ID] NOT IN (
                                    SELECT  [TCSIM].[I_Student_Detail_ID]
                                    FROM    [dbo].[T_Corp_Student_Invoice_Map]
                                            AS TCSIM WITH ( NOLOCK ) )
                                    AND ( DATEDIFF(DD, IP.[Dt_Invoice_Date],
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       IP.[Dt_Invoice_Date]) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
  
        UPDATE  @EEBCANALYSIS
        SET     COLLECTION_AMOUNT = Z.SUM1 ,
                COLLECTION_TAX_AMOUNT = Z.SUM2
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID ,
                                    SUM(ISNULL(TRCD.[N_Amount_Paid], 0.00)) SUM1 ,
                                    SUM(ISNULL(Tax.N_Tax_Paid, 0.00)) SUM2
                             FROM   DBO.T_RECEIPT_HEADER RH WITH ( NOLOCK )
                                    INNER JOIN @EEBCINITIAL A ON RH.I_CENTRE_ID = A.I_CENTRE_ID   
 --AND [RH].[I_Status] = 1  
                                    INNER JOIN [dbo].[T_Receipt_Component_Detail]
                                    AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]
                                    INNER JOIN ( SELECT trtd.I_Receipt_Comp_Detail_ID ,
                                                        SUM(trtd.N_Tax_Paid) AS N_Tax_Paid
                                                 FROM   dbo.T_Receipt_Tax_Detail
                                                        AS trtd
                                                 GROUP BY trtd.I_Receipt_Comp_Detail_ID
                                               ) AS Tax ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID
                                    INNER JOIN [dbo].[T_Invoice_Child_Detail]
                                    AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]
                                    INNER JOIN [dbo].[T_Invoice_Child_Header]
                                    AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]
                                    INNER JOIN @tblCourse TC ON TC.CourseID = TICH.[I_Course_ID]
                                    INNER JOIN dbo.T_Invoice_Parent IP ON TICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON IP.I_Student_Detail_ID = SBD.I_Student_ID
                             WHERE  RH.[I_Student_Detail_ID] IS NOT NULL
                                    AND RH.[I_Student_Detail_ID] NOT IN (
                                    SELECT  [TCSIM].[I_Student_Detail_ID]
                                    FROM    [dbo].[T_Corp_Student_Invoice_Map]
                                            AS TCSIM WITH ( NOLOCK ) )
                                    AND ( DATEDIFF(DD, RH.DT_RECEIPT_DATE,
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       RH.DT_RECEIPT_DATE) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
   
   
        UPDATE  @EEBCANALYSIS
        SET     COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT, 0) + Z.SUM1 ,
                COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT, 0)
                + Z.SUM2
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    TSRD.I_Batch_ID ,
                                    SUM(ISNULL(RH.N_RECEIPT_AMOUNT, 0.00)) SUM1 ,
                                    SUM(ISNULL(RH.N_Tax_Amount, 0.00)) SUM2
                             FROM   DBO.T_RECEIPT_HEADER RH WITH ( NOLOCK )
                                    INNER JOIN @EEBCINITIAL A ON RH.I_CENTRE_ID = A.I_CENTRE_ID  
 --AND [RH].[I_Status] = 1  
                                    INNER JOIN [dbo].T_Student_Registration_Details
                                    AS TSRD WITH ( NOLOCK ) ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID
                                                              AND [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
                                    INNER JOIN T_Student_Batch_Master AS TSBM
                                    WITH ( NOLOCK ) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID
                                    INNER JOIN @tblCourse TC ON TC.CourseID = TSBM.[I_Course_ID]
                             WHERE  RH.[I_Student_Detail_ID] IS NULL
                                    AND ( DATEDIFF(DD, RH.DT_RECEIPT_DATE,
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       RH.DT_RECEIPT_DATE) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    TSRD.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
   
        UPDATE  @EEBCANALYSIS
        SET     COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT, 0) - Z.SUM1 ,
                COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT, 0)
                - Z.SUM2
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID ,
                                    SUM(ISNULL(TRCD.[N_Amount_Paid], 0.00)) SUM1 ,
                                    SUM(ISNULL(Tax.N_Tax_Paid, 0.00)) SUM2
                             FROM   DBO.T_RECEIPT_HEADER RH WITH ( NOLOCK )
                                    INNER JOIN @EEBCINITIAL A ON RH.I_CENTRE_ID = A.I_CENTRE_ID
                                                              AND [RH].[I_Status] = 0
                                    INNER JOIN [dbo].[T_Receipt_Component_Detail]
                                    AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]
                                    INNER JOIN ( SELECT trtd.I_Receipt_Comp_Detail_ID ,
                                                        SUM(trtd.N_Tax_Paid) AS N_Tax_Paid
                                                 FROM   dbo.T_Receipt_Tax_Detail
                                                        AS trtd
                                                 GROUP BY trtd.I_Receipt_Comp_Detail_ID
                                               ) AS Tax ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID
                                    INNER JOIN [dbo].[T_Invoice_Child_Detail]
                                    AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]
                                    INNER JOIN [dbo].[T_Invoice_Child_Header]
                                    AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]
                                    INNER JOIN @tblCourse TC ON TC.CourseID = TICH.[I_Course_ID]
                                    INNER JOIN dbo.T_Invoice_Parent IP ON TICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON IP.I_Student_Detail_ID = SBD.I_Student_ID
                             WHERE  RH.[I_Student_Detail_ID] IS NOT NULL
                                    AND RH.[I_Student_Detail_ID] NOT IN (
                                    SELECT  [TCSIM].[I_Student_Detail_ID]
                                    FROM    [dbo].[T_Corp_Student_Invoice_Map]
                                            AS TCSIM WITH ( NOLOCK ) )
                                    AND ( DATEDIFF(DD, RH.DT_UPD_ON,
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       RH.DT_UPD_ON) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    SBD.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
   
        UPDATE  @EEBCANALYSIS
        SET     COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT, 0) - Z.SUM1 ,
                COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT, 0)
                - Z.SUM2
        FROM    @EEBCANALYSIS P
                INNER JOIN ( SELECT A.I_CENTRE_ID CID ,
                                    TC.CourseID ,
                                    TSBM.I_Batch_ID ,
                                    SUM(ISNULL(RH.N_RECEIPT_AMOUNT, 0.00)) SUM1 ,
                                    SUM(ISNULL(RH.N_Tax_Amount, 0.00)) SUM2
                             FROM   DBO.T_RECEIPT_HEADER RH WITH ( NOLOCK )
                                    INNER JOIN @EEBCINITIAL A ON RH.I_CENTRE_ID = A.I_CENTRE_ID
                                                              AND [RH].[I_Status] = 0
                                    INNER JOIN [dbo].T_Student_Registration_Details
                                    AS TSRD WITH ( NOLOCK ) ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID
                                                              AND [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
                                    INNER JOIN T_Student_Batch_Master AS TSBM
                                    WITH ( NOLOCK ) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID
                                    INNER JOIN @tblCourse TC ON TC.CourseID = TSBM.[I_Course_ID]
                             WHERE  RH.[I_Student_Detail_ID] IS NULL
                                    AND ( DATEDIFF(DD, RH.DT_UPD_ON,
                                                   @dtStartDate) <= 0
                                          AND DATEDIFF(DD, @dtEndDate,
                                                       RH.DT_UPD_ON) <= 0
                                        )
                             GROUP BY A.I_CENTRE_ID ,
                                    TC.CourseID ,
                                    TSBM.I_Batch_ID
                           ) AS Z ON P.I_CENTRE_ID = Z.CID
                                     AND P.I_Course_ID = [Z].CourseID
                                     AND P.I_BATCH_ID = Z.I_Batch_ID  
   
        SELECT  [B].[I_Center_ID] AS CenterID ,
                [B].[S_Center_Name] AS CenterName ,
                [B].[I_Brand_ID] AS BrandID ,
                [B].[S_Brand_Name] AS BrandName ,
                [B].[I_Region_ID] AS RegionID ,
                [B].[S_Region_Name] AS RegionName ,
                [B].[I_Territory_ID] AS TerritoryID ,
                [B].[S_Territiry_Name] AS TerritiryName ,
                [B].[I_City_ID] AS CityID ,
                [B].[S_City_Name] AS CityName ,
                A.*, @S_Instance_Chain AS S_Instance_Chain
        FROM    @EEBCANALYSIS A
                INNER JOIN [dbo].[T_Center_Hierarchy_Name_Details] AS B WITH ( NOLOCK ) ON B.[I_Center_ID] = A.I_Centre_ID
        WHERE   A.INVOICE_AMOUNT > 0
                OR A.COLLECTION_AMOUNT > 0
                OR A.TOTAL_ENROLL > 0
                OR A.TOTAL_REGISTRATION > 0
        ORDER BY A.I_BATCH_ID  
    END
