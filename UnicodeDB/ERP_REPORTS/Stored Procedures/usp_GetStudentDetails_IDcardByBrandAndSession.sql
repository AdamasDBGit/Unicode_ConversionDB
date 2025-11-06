CREATE PROCEDURE ERP_REPORTS.usp_GetStudentDetails_IDcardByBrandAndSession  
    @brandID INT,  
    @SessionID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT DISTINCT   
        bm.S_Brand_Name AS Brand,  
        SD.S_Student_ID,  
        SD.S_First_Name +  
            CASE  
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''  
                    THEN ' ' + SD.S_Middle_Name  
                ELSE ''  
            END +  
            ' ' + SD.S_Last_Name AS StudentName,  
        sg.S_School_Group_Name AS School_Group,  
        tc.S_Class_Name AS Class,  
        st.S_Section_Name AS Section,  
        stt.S_Stream AS Stream,  
        RD.S_Email_ID AS Contact_Email,  
        SD.Dt_Birth_Date AS DOB,  
        bg.S_Blood_Group AS Blood_Group,  
        RD.S_Father_Name AS Guardian_Name,  
        RD.S_Father_Office_Phone AS Father_No,  
        RD.S_Mother_Office_Phone AS Mother_No,  
        SD.S_Curr_Address1 AS Curr_Address1,  
        SD.S_Perm_Address1 AS Perm_Address1, 
		Case when RD.S_Student_Photo is not null Then
        CONCAT('https://ais-sms.arivoo.in/sms/upload/EnquiryCandidatePhoto/', RD.S_Student_Photo)
		else 'Image Not Available' end
		AS ImagePath,  
        TBRM.S_Route_No AS Route_Name,  
        TTM.S_PickupPoint_Name AS Stoppage,  
        TTM.N_Fees AS N_fees,  
        CASE   
            WHEN TBRM.S_Route_No IS NULL THEN 'Not Available'  
            ELSE 'Available'  
        END AS IS_Transport_Available  
    FROM   
        T_Student_Class_Section SCS  
        INNER JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID  
        INNER JOIN T_School_Group_Class sgc ON sgc.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID  
        INNER JOIN T_Class tc ON tc.I_Class_ID = sgc.I_Class_ID AND tc.I_Brand_ID = @brandID  
        INNER JOIN T_School_Group sg ON sg.I_School_Group_ID = sgc.I_School_Group_ID AND sg.I_Brand_Id = @brandID  
		and sg.I_Status=1
        LEFT JOIN T_Enquiry_Regn_Detail RD ON RD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID  
        LEFT JOIN T_Blood_Group bg ON bg.I_Blood_Group_ID = RD.I_Blood_Group_ID  
        LEFT JOIN dbo.T_Transport_Master TTM ON SD.I_Transport_ID = TTM.I_PickupPoint_ID AND TTM.I_Status = 1  
        LEFT JOIN dbo.T_BusRoute_Master TBRM ON SD.I_Route_ID = TBRM.I_Route_ID AND TBRM.I_Status = 1  
        LEFT JOIN T_Section st ON st.I_Section_ID = SCS.I_Section_ID  
        LEFT JOIN T_Stream stt ON stt.I_Stream_ID = SCS.I_Stream_ID AND stt.I_Brand_ID = @brandID  
        INNER JOIN T_Brand_Master bm ON bm.I_Brand_ID = SCS.I_Brand_ID  
    WHERE   
        SCS.I_Brand_ID = @brandID   
        AND SCS.I_School_Session_ID = @SessionID   
        AND SCS.I_Status = 1  
    ORDER BY   
        sg.S_School_Group_Name,  
        tc.S_Class_Name,  
        SD.S_Student_ID;  
END;  