CREATE PROCEDURE [dbo].[uspGetEnquiryFollowupRelevence]
(
@iHierarchyDetailID VARCHAR(MAX),
@dtFromDate DATETIME,
@dtToDate DATETIME,
@iBrandID INT,
@iStatusID INT,
@iFlag INT
)

AS
BEGIN



IF(@iStatusID=0)
BEGIN
SELECT  A.I_Enquiry_Regn_ID ,
        CONVERT(DATE, A.Dt_Crtd_On) AS Dt_Crtd_On ,
        ISNULL(A.S_First_Name, '') AS S_First_Name,ISNULL(A.S_Middle_Name, '') AS S_Middle_Name,
        + ISNULL(A.S_Last_Name, '') AS S_Last_Name ,
        A.I_Enquiry_Status_Code ,
        A.S_Form_No,
        A.S_Mobile_No ,
        A.S_Phone_No,
        TUM.S_First_Name+' '+ISNULL(TUM.S_Middle_Name,'')+' '+ISNULL(TUM.S_Last_Name,'') AS Councillor
FROM    T_Enquiry_Regn_Detail A
INNER JOIN dbo.T_User_Master TUM ON A.S_Crtd_By = TUM.S_Login_ID
WHERE   A.S_Form_No IS NULL
        AND A.I_Centre_ID IN (SELECT centerID FROM dbo.fnGetCentersForReports(@iHierarchyDetailID,@iBrandID) FGCFR)
        AND ( A.I_Enquiry_Status_Code IS NULL
              OR A.I_Enquiry_Status_Code = 1
            )
        AND A.Dt_Crtd_On BETWEEN @dtFromDate AND @dtToDate
        AND A.I_Relevence_ID=@iFlag
        AND A.I_Enquiry_Regn_ID NOT IN (SELECT TSD.I_Enquiry_Regn_ID FROM dbo.T_Student_Detail TSD)
        END

ELSE IF (@iStatusID=1)
BEGIN
SELECT  A.I_Enquiry_Regn_ID ,
        CONVERT(DATE, A.Dt_Crtd_On) AS Dt_Crtd_On ,
        ISNULL(A.S_First_Name, '') AS S_First_Name,ISNULL(A.S_Middle_Name, '') AS S_Middle_Name,
        + ISNULL(A.S_Last_Name, '') AS S_Last_Name  ,
        A.I_Enquiry_Status_Code ,
        A.S_Form_No ,
        A.S_Mobile_No ,
        A.S_Phone_No,
        TUM.S_First_Name+' '+ISNULL(TUM.S_Middle_Name,'')+' '+ISNULL(TUM.S_Last_Name,'') AS Councillor
FROM    T_Enquiry_Regn_Detail A
INNER JOIN dbo.T_User_Master TUM ON A.S_Crtd_By = TUM.S_Login_ID
WHERE   A.S_Form_No IS NOT NULL
        AND A.I_Centre_ID IN (SELECT centerID FROM dbo.fnGetCentersForReports(@iHierarchyDetailID,@iBrandID) FGCFR)
        AND ( A.I_Enquiry_Status_Code IS NULL
              OR A.I_Enquiry_Status_Code = 1
            )
        AND A.Dt_Crtd_On BETWEEN @dtFromDate AND @dtToDate
        AND A.I_Relevence_ID=@iFlag
        AND A.I_Enquiry_Regn_ID NOT IN (SELECT TSD.I_Enquiry_Regn_ID FROM dbo.T_Student_Detail TSD)
ORDER BY CONVERT(DATE, A.Dt_Crtd_On) ,
        A.I_Enquiry_Regn_ID
   END
     
END
