CREATE PROCEDURE [SMManagement].[uspGetBatchList](@BrandID INT, @HierarchyID VARCHAR(MAX),@CourseID INT=NULL)
AS

BEGIN

SELECT TSBM.I_Batch_ID,TSBM.S_Batch_Name+' ('+TCM.S_Course_Name+')('+TCHND.S_Center_Name+')' AS S_Batch_Name FROM dbo.T_Center_Batch_Details AS TCBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCBD.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
WHERE
TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyID,@BrandID) AS FGCFR) AND TCBD.I_Center_Dispatch_Scheme_ID IS NOT NULL
AND TSBM.Dt_Course_Expected_End_Date>DATEADD(d,-90,GETDATE())
--AND TSBM.I_Course_ID=@CourseID
ORDER BY TCHND.S_Center_Name,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name


END
