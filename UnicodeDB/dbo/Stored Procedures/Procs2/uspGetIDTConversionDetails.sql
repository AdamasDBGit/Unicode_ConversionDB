CREATE PROCEDURE [dbo].[uspGetIDTConversionDetails]
(
@iBrandID INT,
@sHierarchyListID Nnvarchar(max),
@dtStartDate DATETIME,
@dtEndDate DATETIME
)

AS

BEGIN


SELECT  TCBD.I_Centre_Id ,
		TCHND.S_Center_Name,
        TSBM.S_Batch_Name ,
        TSBM.Dt_BatchStartDate ,
        TSD.S_Student_ID,
        TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name AS StudentName,
        TSD.S_Mobile_No,
        ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS RollNo
FROM    dbo.T_Student_Batch_Master AS TSBM
        INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
        INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCBD.I_Centre_Id=TCHND.I_Center_ID
--INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
WHERE   TCBD.I_Centre_Id IN ( 18, 19 )
        AND TSBM.S_Batch_Name LIKE 'IDT%'
        AND ( DATEADD(d, 45, TSBM.Dt_BatchStartDate) >= @dtStartDate
              AND DATEADD(d, 45, TSBM.Dt_BatchStartDate) < DATEADD(d,1,@dtEndDate)
            )
        AND TSBD.I_Status IN ( 2 )
        AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) AS FGCFR)
--ORDER BY TCBD.I_Centre_Id,TSBM.Dt_BatchStartDate
        AND TSD.S_Student_ID IN (
        SELECT  TSD.S_Student_ID
        FROM    dbo.T_Student_Detail AS TSD
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
        WHERE   TSBM.I_Course_ID IN ( 519, 520 )
                AND TSBD.I_Status = 3 )
                
UNION ALL

SELECT  TCBD.I_Centre_Id ,
		TCHND.S_Center_Name,
        TSBM.S_Batch_Name ,
        TSBM.Dt_BatchStartDate ,
        TSD.S_Student_ID,
        TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name AS StudentName,
        TSD.S_Mobile_No,
        ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS RollNo
FROM    dbo.T_Student_Batch_Master AS TSBM
        INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
        INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCBD.I_Centre_Id=TCHND.I_Center_ID
--INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
WHERE   TCBD.I_Centre_Id IN ( 18, 19 )
        AND TSBM.S_Batch_Name LIKE 'IDT%'
        AND ( DATEADD(d, 45, TSBM.Dt_BatchStartDate) >= @dtStartDate
              AND DATEADD(d, 45, TSBM.Dt_BatchStartDate) < DATEADD(d,1,@dtEndDate)
            )
        AND TSBD.I_Status IN ( 1 )
        AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) AS FGCFR)
--ORDER BY TCBD.I_Centre_Id,TSBM.Dt_BatchStartDate
        --AND TSD.S_Student_ID IN (
        --SELECT  TSD.S_Student_ID
        --FROM    dbo.T_Student_Detail AS TSD
        --        INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
        --        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
        --        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
        --WHERE   TSBM.I_Course_ID IN ( 519, 520 )
        --        AND TSBD.I_Status = 3 )                


END

