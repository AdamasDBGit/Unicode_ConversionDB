CREATE PROCEDURE [ERP_REPORTS].ERP_Usp_GetEnquiryInsight_Details
    @BrandID INT,
    @SessionID INT,
    @dt_st_dt DATE,
    @dt_end_dt DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        RD.Dt_Crtd_On AS Lead_date,
        RD.S_Enquiry_No,
        RD.S_First_Name +  
            CASE 
                WHEN RD.S_Middle_Name IS NOT NULL AND RD.S_Middle_Name != '' THEN ' ' + RD.S_Middle_Name  
                ELSE '' 
            END + ' ' + RD.S_Last_Name AS StudentName,
        S_Phone_No AS Student_Phone_No,
        S_Email_ID AS Email,
        ET.S_Enquiry_Type_Desc AS Enquiry_Type,
        adsm.S_Admission_Current_Stage_Desc AS Current_Stage,
        ISM.S_Info_Source_Name AS Source_Type,
        ISNULL(t_followup.Next_Followupdt, '1900-01-01') AS Next_Followup_date,
        ISNULL(t_lastdt.Dt_of_Last_Interaction, '1900-01-01') AS Last_Date_of_Interaction,
        t_followup.S_Followup_Remarks AS Followup_Remarks,
        TCM.S_Country_Name AS Country,
        TSM.S_State_Name AS State,
        Tcim.S_City_Name AS City,
        RD.S_Curr_Pincode AS Pincode,
        RD.S_Curr_Address1 AS Address1,
        RD.S_Curr_Address2 AS Address2
    FROM T_Enquiry_Regn_Detail RD
    INNER JOIN T_Brand_Center_Details BCD 
        ON BCD.I_Centre_Id = RD.I_Centre_Id 
        AND BCD.I_Brand_ID = @BrandID
    LEFT JOIN T_Enquiry_Type ET 
        ON RD.I_Enquiry_Type_ID = ET.I_Enquiry_Type_ID
    LEFT JOIN T_ERP_Admission_Stage_Master adsm 
        ON adsm.I_Admission_Stage_ID = RD.R_I_AdmStgTypeID
        AND adsm.I_Brand_ID = @BrandID
    LEFT JOIN T_Information_Source_Master ISM 
        ON ISM.I_Info_Source_ID = RD.I_Info_Source_ID
    LEFT JOIN (
        SELECT 
            S_Followup_Remarks, 
            CONVERT(DATE, MAX(ISNULL(Dt_Next_Followup_Date, '1900-01-01'))) AS Next_Followupdt,
            I_Enquiry_Regn_ID
        FROM T_Enquiry_Regn_Followup
        GROUP BY I_Enquiry_Regn_ID,S_Followup_Remarks
    ) AS t_followup 
        ON t_followup.I_Enquiry_Regn_ID = RD.I_Enquiry_Regn_ID
    LEFT JOIN (
        SELECT 
            CONVERT(DATE, MAX(ISNULL(Dt_Followup_Date, '1900-01-01'))) AS Dt_of_Last_Interaction,
            I_Enquiry_Regn_ID
        FROM T_Enquiry_Regn_Followup
        GROUP BY I_Enquiry_Regn_ID
    ) AS t_lastdt 
        ON t_lastdt.I_Enquiry_Regn_ID = RD.I_Enquiry_Regn_ID
    LEFT JOIN T_Country_Master TCM 
        ON TCM.I_Country_ID = RD.I_Curr_Country_ID
    LEFT JOIN T_State_Master TSM 
        ON TSM.I_State_ID = RD.I_Curr_State_ID
    LEFT JOIN T_City_Master Tcim 
        ON Tcim.I_City_ID = RD.I_Curr_City_ID
    WHERE CONVERT(DATE, RD.Dt_Crtd_On) BETWEEN @dt_st_dt AND @dt_end_dt;
END;
