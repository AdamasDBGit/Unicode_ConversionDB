CREATE PROCEDURE [REPORT].[uspGetRepeaterStudentList]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @sBatchID VARCHAR(MAX) = NULL
    )
AS 
    BEGIN
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                DATENAME(MONTH, TSBD.Dt_Valid_From) + ' '
                + CAST(DATEPART(YYYY, TSBD.Dt_Valid_From) AS VARCHAR) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                COUNT(DISTINCT TSD.S_Student_ID) AS CountofStudents
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
        WHERE   TSBD.I_Status = 1
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSBD.I_Batch_ID IN (
                SELECT  CAST(FSR.Val AS INT)
                FROM    dbo.fnString2Rows(@sBatchID, ',') FSR )
                AND DATEPART(YEAR, TSBM.Dt_BatchStartDate) != DATEPART(YEAR,
                                                              TSD.Dt_Crtd_On)
                AND TSBD.Dt_Valid_From BETWEEN @dtStartDate
                                       AND     @dtEndDate
                                       
                                       GROUP BY 
                                       TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                DATENAME(MONTH, TSBD.Dt_Valid_From) + ' '
                + CAST(DATEPART(YYYY, TSBD.Dt_Valid_From) AS VARCHAR) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name 
    END
