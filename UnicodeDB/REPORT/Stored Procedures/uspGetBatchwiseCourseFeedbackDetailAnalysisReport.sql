CREATE PROCEDURE [REPORT].[uspGetBatchwiseCourseFeedbackDetailAnalysisReport]
    (
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @sBatchID VARCHAR(MAX) = NULL ,
      @iBrandID INT ,
      @sHierarchyIDList VARCHAR(MAX)
    )
   
AS
--SET NOCOUNT ON;
--IF 1 = 2
-- BEGIN
--  SELECT
--   CAST(NULL AS INT) AS I_Center_ID,
--   CAST(NULL AS VARCHAR(MAX)) AS S_Center_Name,
--   CAST(NULL AS INT) AS I_Batch_ID,
--   CAST(NULL AS VARCHAR(MAX)) AS S_Batch_Name,
--   CAST(NULL AS INT) AS TotalResponse
--   CAST(NULL AS INT) AS TotalResponse
--   CAST(NULL AS INT) AS TotalResponse
-- END 
    BEGIN
    
    DECLARE @iFeedbackMasterID INT = NULL 

        IF ( @sBatchID IS NULL ) 
            BEGIN
            
				SELECT T3.I_Employee_ID,T3.FacultyName,T3.I_Center_ID,T3.S_Center_Name,T3.I_Batch_ID ,
                        T3.S_Batch_Name ,
                        T3.TotalResponse ,
                        T3.I_Feedback_Master_ID ,
                        T3.I_Feedback_Option_Master_ID ,
                        T3.S_Feedback_Option_Name ,
                        T3.Weightage ,
                        T3.StdCount ,
                        T3.Point,
                        T3.Score,
                        T4.I_Feedback_Type_ID,
                        T4.TypeDesc,T4.I_Feedback_Group_ID,T4.S_Description,T4.S_Feedback_Question FROM
				(
                SELECT  T1.I_Employee_ID,T1.FacultyName,T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.I_Batch_ID ,
                        T1.S_Batch_Name ,
                        T2.TotalResponse ,
                        T1.I_Feedback_Master_ID ,
                        T1.I_Feedback_Option_Master_ID ,
                        T1.S_Feedback_Option_Name ,
                        T1.Weightage ,
                        T1.StdCount ,
                        T1.Point,
                        T1.Score
                FROM    ( SELECT    TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name AS FacultyName,TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    TFOM.I_Feedback_Master_ID ,
                                    TFOM.I_Feedback_Option_Master_ID ,
                                    TFOM.S_Feedback_Option_Name ,
                                    TFOM.I_Value AS Weightage ,
                                    COUNT(DISTINCT TSF.I_Student_ID) AS StdCount ,
                                    ( TFOM.I_Value
                                      * COUNT(DISTINCT TSF.I_Student_ID) ) AS Point,
                                    (( TFOM.I_Value
                                      * COUNT(DISTINCT TSF.I_Student_ID) )/COUNT(DISTINCT TSF.I_Student_ID)) AS Score  
                          FROM      ACADEMICS.T_Feedback_Option_Master TFOM
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details TSFD ON TFOM.I_Feedback_Option_Master_ID = TSFD.I_Feedback_Option_Master_ID
                                                              AND TFOM.I_Feedback_Master_ID = TSFD.I_Feedback_Master_ID
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback TSF ON TSFD.I_Student_Feedback_ID = TSF.I_Student_Feedback_ID
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSF.I_Student_ID = TSBD.I_Student_ID
                                                              AND TSBD.I_Status = 1
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                    LEFT JOIN dbo.T_Employee_Dtls TED ON TED.I_Employee_ID=TSF.I_Employee_ID
                          WHERE     TFOM.I_Feedback_Master_ID = ISNULL(@iFeedbackMasterID,
                                                              TFOM.I_Feedback_Master_ID)
                                    AND TSF.Dt_Crtd_On BETWEEN @dtStartDate
                                                       AND    DATEADD(d, 1,
                                                              @dtEndDate)
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )                          
                    --AND TSBD.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchID,',') FSR)
                          GROUP BY  TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name,TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    TFOM.I_Feedback_Master_ID ,
                                    TFOM.I_Feedback_Option_Master_ID ,
                                    TFOM.S_Feedback_Option_Name ,
                                    TFOM.I_Value
                        ) T1
                        INNER JOIN ( SELECT TSBD.I_Batch_ID ,
											TED2.I_Employee_ID,
                                            COUNT(DISTINCT TSF.I_Student_ID) AS TotalResponse
                                     FROM   STUDENTFEATURES.T_Student_Feedback TSF
                                            INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSF.I_Student_ID = TSBD.I_Student_ID
                                            LEFT JOIN dbo.T_Employee_Dtls TED2 ON TSF.I_Employee_ID=TED2.I_Employee_ID
                                     WHERE  TSBD.I_Status = 1
                                            AND TSF.Dt_Crtd_On BETWEEN @dtStartDate
                                                              AND
                                                              DATEADD(d, 1,
                                                              @dtEndDate)
                                     GROUP BY TSBD.I_Batch_ID,TED2.I_Employee_ID
                                   ) T2 ON T1.I_Batch_ID = T2.I_Batch_ID AND T1.I_Employee_ID=T2.I_Employee_ID
                --ORDER BY T1.I_Batch_ID ,
                --        T1.S_Batch_Name ,
                --        T2.TotalResponse ,
                --        T1.I_Feedback_Master_ID ,
                --        T1.I_Feedback_Option_Master_ID
                        ) T3
                        INNER JOIN
                        (
                        SELECT TFTM.I_Feedback_Type_ID,TFTM.S_Description AS TypeDesc,TFG.I_Feedback_Group_ID,TFG.S_Description,TFM.I_Feedback_Master_ID,TFM.S_Feedback_Question FROM ACADEMICS.T_Feedback_Group TFG
INNER JOIN ACADEMICS.T_Feedback_Master TFM ON TFG.I_Feedback_Group_ID = TFM.I_Feedback_Group_ID
INNER JOIN ACADEMICS.T_Feedback_Type_Master TFTM ON TFM.I_Feedback_Type_ID = TFTM.I_Feedback_Type_ID
WHERE
TFM.I_Status=1 AND TFTM.I_Feedback_Type_ID IN (1,3) AND TFM.I_Brand_ID IN (109,111)
) T4 ON T3.I_Feedback_Master_ID=T4.I_Feedback_Master_ID 
--GROUP BY T1.I_Batch_ID,T1.S_Batch_Name,T2.TotalResponse,T1.I_Feedback_Master_ID    

--SELECT  *
--FROM    STUDENTFEATURES.T_Student_Feedback TSF
--SELECT  *
--FROM    STUDENTFEATURES.T_Student_Feedback_Details TSFD
            END

        ELSE 
            IF @sBatchID IS NOT NULL 
                BEGIN
                    SELECT T3.I_Employee_ID,T3.FacultyName,T3.I_Center_ID,T3.S_Center_Name,T3.I_Batch_ID ,
                        T3.S_Batch_Name ,
                        T3.TotalResponse ,
                        T3.I_Feedback_Master_ID ,
                        T3.I_Feedback_Option_Master_ID ,
                        T3.S_Feedback_Option_Name ,
                        T3.Weightage ,
                        T3.StdCount ,
                        T3.Point,
                        T3.Score,
                        T4.I_Feedback_Type_ID,
                        T4.TypeDesc,T4.I_Feedback_Group_ID,T4.S_Description,T4.S_Feedback_Question FROM
				(
                SELECT  T1.I_Employee_ID,T1.FacultyName,T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.I_Batch_ID ,
                        T1.S_Batch_Name ,
                        T2.TotalResponse ,
                        T1.I_Feedback_Master_ID ,
                        T1.I_Feedback_Option_Master_ID ,
                        T1.S_Feedback_Option_Name ,
                        T1.Weightage ,
                        T1.StdCount ,
                        T1.Point,
                        T1.Score
                FROM    ( SELECT    TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name AS FacultyName,TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    TFOM.I_Feedback_Master_ID ,
                                    TFOM.I_Feedback_Option_Master_ID ,
                                    TFOM.S_Feedback_Option_Name ,
                                    TFOM.I_Value AS Weightage ,
                                    COUNT(DISTINCT TSF.I_Student_ID) AS StdCount ,
                                    ( TFOM.I_Value
                                      * COUNT(DISTINCT TSF.I_Student_ID) ) AS Point,
                                      (( TFOM.I_Value
                                      * COUNT(DISTINCT TSF.I_Student_ID) )/COUNT(DISTINCT TSF.I_Student_ID)) AS Score
                          FROM      ACADEMICS.T_Feedback_Option_Master TFOM
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details TSFD ON TFOM.I_Feedback_Option_Master_ID = TSFD.I_Feedback_Option_Master_ID
                                                              AND TFOM.I_Feedback_Master_ID = TSFD.I_Feedback_Master_ID
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback TSF ON TSFD.I_Student_Feedback_ID = TSF.I_Student_Feedback_ID
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSF.I_Student_ID = TSBD.I_Student_ID
                                                              AND TSBD.I_Status = 1
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                    LEFT JOIN dbo.T_Employee_Dtls TED ON TED.I_Employee_ID=TSF.I_Employee_ID
                          WHERE     TFOM.I_Feedback_Master_ID = ISNULL(@iFeedbackMasterID,
                                                              TFOM.I_Feedback_Master_ID)
                                    AND TSF.Dt_Crtd_On BETWEEN @dtStartDate
                                                       AND    DATEADD(d, 1,
                                                              @dtEndDate)
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                                              --AND TED.I_Employee_ID=ISNULL()
                                    AND TSBD.I_Batch_ID IN (
                                        SELECT  CAST(FSR.Val AS INT)
                                        FROM    dbo.fnString2Rows(@sBatchID,
                                                              ',') FSR )                                                    
                    --AND TSBD.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchID,',') FSR)
                          GROUP BY  TED.I_Employee_ID,TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name,TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    TFOM.I_Feedback_Master_ID ,
                                    TFOM.I_Feedback_Option_Master_ID ,
                                    TFOM.S_Feedback_Option_Name ,
                                    TFOM.I_Value
                        ) T1
                        INNER JOIN ( SELECT TSBD.I_Batch_ID ,
											TED.I_Employee_ID,
                                            COUNT(DISTINCT TSF.I_Student_ID) AS TotalResponse
                                     FROM   STUDENTFEATURES.T_Student_Feedback TSF
                                            INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSF.I_Student_ID = TSBD.I_Student_ID
                                            LEFT JOIN dbo.T_Employee_Dtls TED ON TSF.I_Employee_ID=TED.I_Employee_ID
                                     WHERE  TSBD.I_Status = 1
                                            AND TSF.Dt_Crtd_On BETWEEN @dtStartDate
                                                              AND
                                                              DATEADD(d, 1,
                                                              @dtEndDate)
                                     GROUP BY TSBD.I_Batch_ID,TED.I_Employee_ID
                                   ) T2 ON T1.I_Batch_ID = T2.I_Batch_ID AND T1.I_Employee_ID=T2.I_Employee_ID
                --ORDER BY T1.I_Batch_ID ,
                --        T1.S_Batch_Name ,
                --        T2.TotalResponse ,
                --        T1.I_Feedback_Master_ID ,
                --        T1.I_Feedback_Option_Master_ID
                        ) T3
                        INNER JOIN
                        (
                        SELECT TFTM.I_Feedback_Type_ID,TFTM.S_Description AS TypeDesc,TFG.I_Feedback_Group_ID,TFG.S_Description,TFM.I_Feedback_Master_ID,TFM.S_Feedback_Question FROM ACADEMICS.T_Feedback_Group TFG
INNER JOIN ACADEMICS.T_Feedback_Master TFM ON TFG.I_Feedback_Group_ID = TFM.I_Feedback_Group_ID
INNER JOIN ACADEMICS.T_Feedback_Type_Master TFTM ON TFM.I_Feedback_Type_ID = TFTM.I_Feedback_Type_ID
WHERE
TFM.I_Status=1 AND TFTM.I_Feedback_Type_ID IN (1,3) AND TFM.I_Brand_ID IN (109,111)
) T4 ON T3.I_Feedback_Master_ID=T4.I_Feedback_Master_ID
                END



    END
