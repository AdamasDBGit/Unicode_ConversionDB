/**************************************************************************************************************
Created by : Swagata De
Date : 01.05.2007
Description : This SP will retrieve all the list of examinations for the valid centers pertaining to a selected brand and hierarchy id
Parameters :Brand Id,HierarchyDtl Id,From Dt,To Dt
Returns : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EXAMINATION].[uspGetExamCenterList]
(
@iBrandID INT,
@iHierarchyDetailID INT,
@dtFromDate DATETIME = NULL,
@dtToDate DATETIME = NULL
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @tblCenterIds TABLE
(
I_Center_Id int

)

DECLARE @sSearchCriteria varchar(20)
--Select the hierarchy chain corresponding to the selected hierarchy id
SELECT @sSearchCriteria= S_Hierarchy_Chain from dbo.T_Hierarchy_Mapping_Details where I_Hierarchy_Detail_ID = @iHierarchyDetailID
--Get the list of centers corresponding to the hierarchy chain filtered by brand id
IF @iBrandID =0
BEGIN
INSERT INTO @tblCenterIds
SELECT DISTINCT TCHD.I_Center_Id
FROM T_CENTER_HIERARCHY_DETAILS TCHD
WHERE TCHD.I_Hierarchy_Detail_ID IN
(SELECT I_HIERARCHY_DETAIL_ID
FROM T_Hierarchy_Mapping_Details
WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%')
END
ELSE
BEGIN
INSERT INTO @tblCenterIds
SELECT DISTINCT TCHD.I_Center_Id
FROM T_CENTER_HIERARCHY_DETAILS TCHD, T_BRAND_CENTER_DETAILS TBCD
WHERE TCHD.I_Hierarchy_Detail_ID IN
(SELECT I_HIERARCHY_DETAIL_ID
FROM T_Hierarchy_Mapping_Details
WHERE S_Hierarchy_Chain
LIKE @sSearchCriteria + '%')
AND TBCD.I_Brand_ID = @iBrandID
AND TBCD.I_Centre_Id = TCHD.I_Center_Id

END

--Get the list of exams for the selected centers

SELECT DISTINCT TED.I_Exam_ID,
TED.I_Exam_Component_ID,
TED.I_Centre_Id,
TCEM.S_Center_Name,
TCEM.S_Center_Code,
TED.Dt_Exam_Date,
TED.Dt_Exam_Start_Time,
TED.Dt_Exam_End_Time,
EXAMINATION.fnGetNoOfStudents(TED.I_Exam_ID)AS I_No_Of_Students,
TED.I_Course_ID,
TCRM.S_Course_Code,
TCRM.S_Course_Name,
TED.I_Term_ID,
TTM.S_Term_Code,
TTM.S_Term_Name,
ISNULL(TED.I_Module_ID,0) AS I_Module_ID ,
ISNULL(TMM.S_Module_Code,'NA')AS S_Module_Code,
ISNULL(TMM.S_Module_Name,'NA') AS S_Module_Name,
TED.S_Exam_Venue,
TED.Dt_Registration_Date,
TED.S_Registration_No,
TED.I_Agency_ID,
TED.S_Invigilator_Name,
TED.S_Identification_Doc_Type,
ISNULL(TED.S_Reason,'NA') AS S_Reason,
TED.I_Status_ID,
TED.Dt_Crtd_On,
TED.S_Crtd_By,
TED.Dt_Upd_On,
TED.S_Upd_By
FROM EXAMINATION.T_Examination_Detail TED
LEFT OUTER JOIN EXAMINATION.T_Eligibility_List TEL
ON TED.I_Exam_ID=TEL.I_Exam_ID
INNER JOIN dbo.T_Centre_Master TCEM
ON TED.I_Centre_Id=TCEM.I_Centre_Id
INNER JOIN dbo.T_Course_Master TCRM
ON TED.I_Course_ID=TCRM.I_Course_ID
INNER JOIN dbo.T_Term_Master TTM
ON TED.I_Term_ID=TTM.I_Term_ID
LEFT OUTER JOIN dbo.T_Module_Master TMM
ON TED.I_Module_ID=TMM.I_Module_ID
WHERE TED.I_Centre_Id IN (SELECT I_Center_Id FROM @tblCenterIds)
AND DATEDIFF(dd, ISNULL(@dtFromDate,TED.Dt_Exam_Date), TED.Dt_Exam_Date) >= 0
AND DATEDIFF(dd, ISNULL(@dtToDate,TED.Dt_Exam_Date), TED.Dt_Exam_Date) <= 0
AND TED.I_Status_ID=1--Active Status
END
