CREATE PROC [dbo].[uspViewFTSAPReport]
(
@iBrandID INT,
@dtFTDate DATETIME
)
AS
BEGIN

SET NOCOUNT ON;

CREATE TABLE #REPORT
(
Brand INT NULL,
BrandName VARCHAR(50) NULL,
Centre INT NULL,
CentreName VARCHAR(50) NULL,
Comment VARCHAR(100) NULL,
Date DATETIME NULL,
[Status] VARCHAR(50) NULL
)

    INSERT INTO #REPORT(Brand,Centre,Comment,Date,[Status])
    SELECT I_Brand_ID,I_Centre_ID,S_Comments,Dt_Run_Date,'FAILURE' FROM dbo.T_SAP_Batch_Log WITH (NOLOCK)
    WHERE ((s_comments LIKE 'FT SAP REPORT CAN NOT RUN%')
    OR (s_comments LIKE 'ABORTED OPERATION%'))
    AND i_brand_id=@iBrandID
    AND CAST(CAST(dt_run_date AS VARCHAR(11)) AS DATETIME) = CAST(@dtFTDate AS DATETIME)


    INSERT INTO #REPORT(Brand,Centre,Comment,Date,[Status])
    SELECT I_Brand_ID,I_Centre_ID,S_Comments,Dt_Run_Date,'SUCCESS' FROM dbo.T_SAP_Batch_Log WITH (NOLOCK)
    WHERE i_brand_id=@iBrandID
    AND CAST(CAST(dt_run_date AS VARCHAR(11)) AS DATETIME) = CAST(@dtFTDate AS DATETIME)
    EXCEPT
    SELECT I_Brand_ID,I_Centre_ID,S_Comments,Dt_Run_Date,'SUCCESS' FROM dbo.T_SAP_Batch_Log WITH (NOLOCK)
    WHERE ((s_comments LIKE 'FT SAP REPORT CAN NOT RUN%')
    OR (s_comments LIKE 'ABORTED OPERATION%'))
    AND i_brand_id=@iBrandID
    AND CAST(CAST(dt_run_date AS VARCHAR(11)) AS DATETIME) = CAST(@dtFTDate AS DATETIME)

UPDATE #REPORT
SET BrandName= ISNULL((SELECT S_Brand_Name FROM T_Brand_Master WHERE I_Brand_ID=#REPORT.Brand AND I_Status <> 0),'')

UPDATE #REPORT
SET CentreName= ISNULL((SELECT S_Center_Name FROM T_Centre_Master WHERE I_Centre_Id=#REPORT.Centre),'')

    SELECT * FROM #REPORT
    DROP TABLE #REPORT

END
