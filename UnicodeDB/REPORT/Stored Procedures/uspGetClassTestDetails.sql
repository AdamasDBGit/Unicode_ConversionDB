CREATE PROCEDURE [REPORT].[uspGetClassTestDetails]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @sBatchList VARCHAR(MAX) = NULL
    )
AS
    BEGIN

        IF ( @sBatchList IS NULL )
            BEGIN

                SELECT  TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.I_RollNo ,
                        TSD.S_Mobile_No ,
                        TCTM.S_ClassTest_Name ,
                        CONVERT(DATE,TCTM.Dt_Submission_Date) AS  Dt_Submission_Date,
                        TCTM.N_Total_Marks ,
                        TCTS.N_Marks
                FROM    EXAMINATION.T_ClassTest_Master AS TCTM
                        INNER JOIN EXAMINATION.T_ClassTest_Submission AS TCTS ON TCTS.I_ClassTest_ID = TCTM.I_ClassTest_ID
                        INNER JOIN dbo.T_TimeTable_Master AS TTTM ON TTTM.I_TimeTable_ID = TCTM.I_TimeTable_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TCTM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TCTM.I_Center_ID
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TCTS.I_Student_Detail_ID
                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                WHERE   TCTM.Dt_Submission_Date >= @dtStartDate
                        AND TCTM.Dt_Submission_Date < DATEADD(d, 1, @dtEndDate)
                        AND TCTM.I_Status=1 AND TCTS.I_Status=1
                        AND TTTM.I_Status=1
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                ORDER BY TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TCTM.Dt_Submission_Date ,
                        TSD.S_Student_ID
        
            END

        ELSE
            BEGIN

                SELECT  TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.I_RollNo ,
                        TSD.S_Mobile_No ,
                        TCTM.S_ClassTest_Name ,
                        CONVERT(DATE,TCTM.Dt_Submission_Date) AS  Dt_Submission_Date ,
                        TCTM.N_Total_Marks ,
                        TCTS.N_Marks
                FROM    EXAMINATION.T_ClassTest_Master AS TCTM
                        INNER JOIN EXAMINATION.T_ClassTest_Submission AS TCTS ON TCTS.I_ClassTest_ID = TCTM.I_ClassTest_ID
                        INNER JOIN dbo.T_TimeTable_Master AS TTTM ON TTTM.I_TimeTable_ID = TCTM.I_TimeTable_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TCTM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TCTM.I_Center_ID
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TCTS.I_Student_Detail_ID
                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                WHERE   TCTM.Dt_Submission_Date >= @dtStartDate
                        AND TCTM.Dt_Submission_Date < DATEADD(d, 1, @dtEndDate)
                        AND TCTM.I_Status=1 AND TCTS.I_Status=1
                        AND TTTM.I_Status=1
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                        AND TSBM.I_Batch_ID IN (
                        SELECT  CAST(FSR.Val AS INT)
                        FROM    dbo.fnString2Rows(@sBatchList, ',') AS FSR )
                ORDER BY TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TCTM.Dt_Submission_Date ,
                        TSD.S_Student_ID

            END

    END
