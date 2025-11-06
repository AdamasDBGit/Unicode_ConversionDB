CREATE PROCEDURE [dbo].[uspGetStudentExamMasterDataForAPI](@BrandID INT,@AcademicSession NVARCHAR(MAX)=NULL)
AS
BEGIN

DECLARE @AcSes VARCHAR(10)=NULL

IF (@AcademicSession IS NOT NULL)
	SET @AcSes=SUBSTRING(@AcademicSession,0,5)

PRINT @AcSes

IF (@AcSes IS NULL)
BEGIN

SELECT TSD.I_Student_Detail_ID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,
TSD.S_Mobile_No,TERD.S_Student_Photo,
--,CAST(YEAR(TSBM.Dt_BatchStartDate) AS VARCHAR)+'-'+CAST(CAST(SUBSTRING(CAST(YEAR(TSBM.Dt_BatchStartDate) AS VARCHAR),3,2) AS INT)+1  AS VARCHAR) AS AcademicSession,
TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCHND.S_Center_Name
FROM dbo.T_Student_Detail AS TSD
INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TSCD.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
WHERE
TCHND.I_Brand_ID IN (@BrandID) AND TSCD.I_Status=1 --AND TSD.I_Student_Detail_ID=5868
AND (GETDATE()>=T1.Dt_BatchStartDate AND GETDATE()<=T1.Dt_Course_Expected_End_Date)

SELECT DISTINCT TSD.I_Student_Detail_ID,TCM.I_Course_ID,TCM.S_Course_Name,T1.I_Batch_ID,T1.S_Batch_Name
FROM dbo.T_Student_Detail AS TSD
--INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
--INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
WHERE TCM.I_Brand_ID=@BrandID --AND TSBD.I_Status=1 --
--AND TSD.I_Student_Detail_ID=94505
AND (GETDATE()>=T1.Dt_BatchStartDate AND GETDATE()<=T1.Dt_Course_Expected_End_Date)

--SELECT TSBD.I_Student_ID,TB1.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate FROM dbo.T_Student_Batch_Details AS TSBD
--INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
--INNER JOIN
--(
--SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID FROM dbo.T_Student_Batch_Details AS TSBD
--INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
--WHERE TSBD.I_Status IN (0,1,2)
--) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID AND TB1.I_Course_ID = TSBM.I_Course_ID



SELECT DISTINCT TSD.I_Student_Detail_ID,TCM.I_Course_ID,TTM.I_Term_ID,TTM.S_Term_Name
FROM dbo.T_Student_Detail AS TSD
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
INNER JOIN dbo.T_Term_Course_Map AS TTCM ON TTCM.I_Course_ID = TCM.I_Course_ID
INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TTCM.I_Term_ID
WHERE TCM.I_Brand_ID=@BrandID AND TTCM.I_Status=1 --AND TSBD.I_Status=1 --AND TSD.I_Student_Detail_ID=94505
AND (GETDATE()>=T1.Dt_BatchStartDate AND GETDATE()<=T1.Dt_Course_Expected_End_Date)

END

ELSE

BEGIN

SELECT TSD.I_Student_Detail_ID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,
TSD.S_Mobile_No,TERD.S_Student_Photo,
--,CAST(YEAR(TSBM.Dt_BatchStartDate) AS VARCHAR)+'-'+CAST(CAST(SUBSTRING(CAST(YEAR(TSBM.Dt_BatchStartDate) AS VARCHAR),3,2) AS INT)+1  AS VARCHAR) AS AcademicSession,
TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCHND.S_Center_Name
FROM dbo.T_Student_Detail AS TSD
INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TSCD.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
WHERE
TCHND.I_Brand_ID IN (@BrandID) AND TSCD.I_Status=1 --AND TSD.I_Student_Detail_ID=5868
AND TCM.S_Course_Name LIKE '%'+@AcSes+'%'
--AND (GETDATE()>=TSBM.Dt_BatchStartDate AND GETDATE()<=TSBM.Dt_Course_Expected_End_Date)

SELECT DISTINCT TSD.I_Student_Detail_ID,TCM.I_Course_ID,TCM.S_Course_Name,T1.I_Batch_ID,T1.S_Batch_Name
FROM dbo.T_Student_Detail AS TSD
--INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
--INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
WHERE TCM.I_Brand_ID=@BrandID --AND TSBD.I_Status=1 --AND TSM.I_Student_Detail_ID=5868
AND TCM.S_Course_Name LIKE '%'+@AcSes+'%'
--AND (GETDATE()>=TSBM.Dt_BatchStartDate AND GETDATE()<=TSBM.Dt_Course_Expected_End_Date)


SELECT DISTINCT TSD.I_Student_Detail_ID,TCM.I_Course_ID,TTM.I_Term_ID,TTM.S_Term_Name
FROM dbo.T_Student_Detail AS TSD
INNER JOIN
(
SELECT TSBD.I_Student_ID,TSBM.I_Course_ID,TSBD.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSBm.Dt_Course_Expected_End_Date FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN
(
SELECT TSBD.I_Student_ID,TCM2.I_CourseFamily_ID,MAX(TSBD.I_Student_Batch_ID) AS StdBatchID 
FROM dbo.T_Student_Batch_Details AS TSBD
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TSBM.I_Course_ID
WHERE TSBD.I_Status IN (0,1,2)
GROUP BY TSBD.I_Student_ID,TCM2.I_CourseFamily_ID
) TB1 ON TB1.I_Student_ID = TSBD.I_Student_ID AND TSBD.I_Student_Batch_ID=TB1.StdBatchID --AND TB1.I_Course_ID = TSBM.I_Course_ID
) T1 ON T1.I_Student_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = T1.I_Course_ID
INNER JOIN dbo.T_Term_Course_Map AS TTCM ON TTCM.I_Course_ID = TCM.I_Course_ID
INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TTCM.I_Term_ID
WHERE TCM.I_Brand_ID=@BrandID AND TTCM.I_Status=1 --AND TSBD.I_Status=1 --AND TSM.I_Student_Detail_ID=5868
AND TCM.S_Course_Name LIKE '%'+@AcSes+'%'
--AND (GETDATE()>=TSBM.Dt_BatchStartDate AND GETDATE()<=TSBM.Dt_Course_Expected_End_Date)

END



END

