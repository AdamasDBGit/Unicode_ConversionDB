CREATE PROCEDURE [REPORT].[uspGetIDTConversionReport]
(
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATE,
@dtEndDate DATE,
@sBatchID VARCHAR(MAX)
)
AS
BEGIN


SELECT  T2.OriginalCourseID ,
        T2.OriginalCourseName ,
        T2.OriginalBatchID ,
        T2.OriginalBatchName ,
        T2.OriginalBatchStartDate,
        T2.I_Student_Detail_ID ,
        T2.S_Student_ID ,
        T2.StudentName ,
        T2.ContactNo ,
        T2.ConvertedCourseID ,
        T2.ConvertedCourseName ,
        T2.ConvertedBatchID ,
        T2.ConvertedBatch ,
        CASE WHEN T2.I_Status = 0
             THEN 'Transferred But Currently Not In This Batch'
             WHEN T2.I_Status = 1 THEN 'Present In This Batch'
             WHEN T2.I_Status = 3 THEN 'Promoted But Approval Pending'
        END AS StudentStatus,
        CONVERT(DATE,T2.ConvertedDate)AS ConvertionDate
FROM    ( SELECT    T1.I_Course_ID AS OriginalCourseID ,
                    T1.S_Course_Name AS OriginalCourseName ,
                    T1.I_Batch_ID AS OriginalBatchID ,
                    T1.S_Batch_Name AS OriginalBatchName ,
                    T1.BatchStartDate AS OriginalBatchStartDate,
                    T1.I_Student_Detail_ID ,
                    T1.S_Student_ID ,
                    T1.StudentName ,
                    T1.ContactNo ,
                    TSBM2.I_Batch_ID ConvertedBatchID ,
                    TSBM2.S_Batch_Name AS ConvertedBatch ,
                    --CONVERT(DATE,TSBM2.Dt_BatchStartDate) AS ConvertedBatchStartDate,
                    TSBD2.I_Status ,
                    TSBD2.Dt_Valid_From AS ConvertedDate ,
                    TCM2.I_Course_ID AS ConvertedCourseID ,
                    TCM2.S_Course_Name AS ConvertedCourseName,
                    DENSE_RANK() OVER (PARTITION BY T1.S_Student_ID ORDER BY ISNULL(TSBD2.Dt_Valid_From,'2111-01-01') DESC) AS Sequence
          FROM      ( SELECT    TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TSBM.I_Batch_ID ,
                                TSBM.S_Batch_Name ,
                                CONVERT(DATE,TSBM.Dt_BatchStartDate) AS BatchStartDate,
                                TSD.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' '
                                + ISNULL(TSD.S_Middle_Name, '') + ' '
                                + TSD.S_Last_Name AS StudentName ,
                                COALESCE(TSD.S_Guardian_Phone_No,
                                         TSD.S_Guardian_Mobile_No,
                                         TSD.S_Mobile_No) AS ContactNo ,
                                TSBD.Dt_Valid_From
                      FROM      dbo.T_Student_Batch_Details TSBD
                                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Student_Detail TSD ON TSBD.I_Student_ID = TSD.I_Student_Detail_ID
                                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                      WHERE     TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) FGCFR)
                                AND TSBD.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchID,',') FSR)
                                AND TSBD.I_Status = 2
                    ) T1
                    LEFT JOIN dbo.T_Student_Batch_Details TSBD2 ON T1.I_Student_Detail_ID = TSBD2.I_Student_ID
                    LEFT JOIN dbo.T_Student_Batch_Master TSBM2 ON TSBD2.I_Batch_ID = TSBM2.I_Batch_ID
                    LEFT JOIN dbo.T_Course_Master TCM2 ON TSBM2.I_Course_ID = TCM2.I_Course_ID
--WHERE   TSBD2.I_Status IN ( 0, 1 )
--        AND TSBD2.Dt_Valid_From BETWEEN '2016-04-01'
--                             AND     '2016-06-30'
        ) T2
WHERE   ( ( T2.ConvertedDate BETWEEN @dtStartDate
                             AND     DATEADD(d,1,@dtEndDate) )
          OR T2.ConvertedDate IS NULL
        )
        AND T2.OriginalCourseID != T2.ConvertedCourseID
        AND NOT ( T2.I_Status = 0
                  AND T2.ConvertedDate IS NULL
                )
                AND T2.Sequence=1

--4830

END
