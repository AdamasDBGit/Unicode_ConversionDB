CREATE PROCEDURE [REPORT].[uspGetEnquiryAnalysisReport]
(
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATE,
@dtEndDate DATE
)

AS
BEGIN

SELECT  TCHND.S_Center_Name,TERD.I_Enquiry_Regn_ID ,
        TERD.S_First_Name + ' ' + ISNULL(TERD.S_Middle_Name, '') + ' '
        + TERD.S_Last_Name AS CandidateName ,
        TERD.S_Mobile_No AS ContactNo,
        CASE WHEN TERD.I_Enquiry_Status_Code IS NULL THEN 'Pre-Enquiry'
        WHEN TERD.I_Enquiry_Status_Code=1 THEN 'Enquiry'
        WHEN TERD.I_Enquiry_Status_Code=3 AND TSD.S_Student_ID IS NOT NULL THEN 'Admitted'
        END AS EnquiryStatus ,
        TISM.S_Info_Source_Name,
        TECS.S_Education_CurrentStatus_Description,
        TERD.S_Curr_Pincode,
        CASE WHEN TERD.S_Curr_Pincode!='' AND TERD.S_Curr_Pincode IN (SELECT T1.S_Pincode FROM dbo.T_Pincode_Details T1) THEN TPD.S_Pincode_Location
        WHEN TERD.S_Curr_Pincode!='' AND TERD.S_Curr_Pincode NOT IN (SELECT T1.S_Pincode FROM dbo.T_Pincode_Details T1) THEN TCM.S_City_Name
        WHEN TERD.S_Curr_Pincode='' THEN TCM.S_City_Name
        END AS EnquiryArea,
        TERD.S_Form_No,
        ISNULL(CONVERT(DATE,TERD.Enquiry_Date),CONVERT(DATE,TERD.Dt_Crtd_On)) AS EnquiryDate,
        CONVERT(DATE,TSD.Dt_Crtd_On) AS AdmissionDate,
        TSD.S_Student_ID
FROM    dbo.T_Enquiry_Regn_Detail TERD
        LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
        LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus TEECS ON TERD.I_Enquiry_Regn_ID = TEECS.I_Enquiry_Regn_ID
        LEFT JOIN dbo.T_Education_CurrentStatus TECS ON TEECS.I_Education_CurrentStatus_ID = TECS.I_Education_CurrentStatus_ID
        LEFT JOIN dbo.T_Student_Detail TSD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        LEFT JOIN dbo.T_Pincode_Details TPD ON TERD.S_Curr_Pincode=TPD.S_Pincode
        LEFT JOIN dbo.T_City_Master TCM ON TERD.I_Curr_City_ID=TCM.I_City_ID
WHERE   TERD.I_Centre_Id IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) FGCFR)
        AND (ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On) >= @dtStartDate AND ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)<DATEADD(d,1,@dtEndDate))
        AND (TERD.I_Enquiry_Status_Code IS NULL OR TERD.I_Enquiry_Status_Code=1)
        
UNION ALL

SELECT  TCHND.S_Center_Name,TERD.I_Enquiry_Regn_ID ,
        TERD.S_First_Name + ' ' + ISNULL(TERD.S_Middle_Name, '') + ' '
        + TERD.S_Last_Name AS CandidateName ,
        TERD.S_Mobile_No AS ContactNo,
        CASE 
        WHEN TERD.I_Enquiry_Status_Code=3 AND TSD.S_Student_ID IS NOT NULL THEN 'Admitted'
        END AS EnquiryStatus ,
        TISM.S_Info_Source_Name,
        TECS.S_Education_CurrentStatus_Description,
        TERD.S_Curr_Pincode,
        CASE WHEN TERD.S_Curr_Pincode!='' AND TERD.S_Curr_Pincode IN (SELECT T1.S_Pincode FROM dbo.T_Pincode_Details T1) THEN TPD.S_Pincode_Location
        WHEN TERD.S_Curr_Pincode!='' AND TERD.S_Curr_Pincode NOT IN (SELECT T1.S_Pincode FROM dbo.T_Pincode_Details T1) THEN TCM.S_City_Name
        WHEN TERD.S_Curr_Pincode='' THEN TCM.S_City_Name
        END AS EnquiryArea,
        TERD.S_Form_No,
        ISNULL(CONVERT(DATE,TERD.Enquiry_Date),CONVERT(DATE,TERD.Dt_Crtd_On)) AS EnquiryDate,
        CONVERT(DATE,TSD.Dt_Crtd_On) AS AdmissionDate,
        TSD.S_Student_ID
FROM    dbo.T_Enquiry_Regn_Detail TERD
        LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
        LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus TEECS ON TERD.I_Enquiry_Regn_ID = TEECS.I_Enquiry_Regn_ID
        LEFT JOIN dbo.T_Education_CurrentStatus TECS ON TEECS.I_Education_CurrentStatus_ID = TECS.I_Education_CurrentStatus_ID
        LEFT JOIN dbo.T_Student_Detail TSD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        LEFT JOIN dbo.T_Pincode_Details TPD ON TERD.S_Curr_Pincode=TPD.S_Pincode
        LEFT JOIN dbo.T_City_Master TCM ON TERD.I_Curr_City_ID=TCM.I_City_ID
WHERE   TERD.I_Centre_Id IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) FGCFR)
        AND (TSD.Dt_Crtd_On >= @dtStartDate AND TSD.Dt_Crtd_On<DATEADD(d,1,@dtEndDate)) AND TERD.I_Enquiry_Status_Code=3      

END
