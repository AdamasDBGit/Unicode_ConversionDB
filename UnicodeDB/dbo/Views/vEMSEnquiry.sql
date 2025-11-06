CREATE VIEW vEMSEnquiry
AS
SELECT TERD.I_Enquiry_Regn_ID,TERD.S_First_Name,TERD.S_Middle_Name,TERD.S_Last_Name,TERD.S_Mobile_No,YEAR(TERD.PreEnquiryDate) AS YearofEnquiry 
FROM dbo.T_Enquiry_Regn_Detail AS TERD
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TERD.I_Centre_Id=TCHND.I_Center_ID
WHERE TCHND.I_Brand_ID=109 AND (TERD.I_Enquiry_Status_Code IS NULL OR TERD.I_Enquiry_Status_Code=1)
AND CONVERT(DATE,TERD.PreEnquiryDate)='2020-02-01'--CONVERT(DATE,GETDATE())