CREATE PROCEDURE [REPORT].[uspGetAdmissionAnalysisReport]
(
@iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @FromDate DATE ,
      @ToDate DATE
)
AS
BEGIN

        CREATE TABLE #CenterList ( CenterID INT )

        INSERT  INTO #CenterList
                ( CenterID 
                )
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR


	SELECT  TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        --'Admission' AS RowCategory ,
                        --'TY' AS ColumnCategory ,
                        TCM.I_Course_ID,
                        TCM.S_Course_Name,
                        COUNT(DISTINCT TSD.I_Student_Detail_ID) AS Total
                FROM    dbo.T_Student_Detail TSD
                        INNER JOIN dbo.T_Student_Center_Detail TSCD ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN
                        (
                        SELECT T2.I_Student_ID,T3.I_Batch_ID FROM
                        (
                        SELECT TSBD.I_Student_ID,MIN(TSBD.I_Student_Batch_ID) AS MinBatch FROM dbo.T_Student_Batch_Details TSBD
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
                        WHERE
                        TCBD.I_Centre_Id IN ( SELECT   CL.CenterID
                                               FROM     #CenterList CL )
                                               GROUP BY TSBD.I_Student_ID
                                               ) T2
                                               INNER JOIN 
                                               (
                                               SELECT TSBD.I_Student_ID,TSBD.I_Student_Batch_ID,TSBD.I_Batch_ID FROM dbo.T_Student_Batch_Details TSBD
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
                        WHERE
                        TCBD.I_Centre_Id IN ( SELECT   CL.CenterID
                                               FROM     #CenterList CL )
                                               --GROUP BY TSBD.I_Student_ID
                                               ) T3 ON T2.I_Student_ID = T3.I_Student_ID AND T2.MinBatch=T3.I_Student_Batch_ID
                        ) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON T1.I_Batch_ID=TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                WHERE   TCHND.I_Center_ID IN ( SELECT   CL.CenterID
                                               FROM     #CenterList CL )
                        AND ( TSD.Dt_Crtd_On >= @FromDate
                              AND TSD.Dt_Crtd_On < DATEADD(d,1,@ToDate)
                            )
                            AND TCM.I_Status=1
                GROUP BY TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR),
                        TCM.I_Course_ID,
                        TCM.S_Course_Name
END
