CREATE PROCEDURE [dbo].[uspGetUserEnquiryDetails]           
(                  
  @iEnquiryID INT = NULL             
                     
)                      
AS                  
BEGIN                  
SET NOCOUNT OFF;                      
                  

SELECT I_Enquiry_Regn_ID ,
        I_Centre_Id ,
        I_Occupation_ID ,
        I_Pref_Career_ID ,
        I_Enquiry_Status_Code ,
        I_Info_Source_ID ,
        I_Enquiry_Type_ID ,
        S_Enquiry_No ,
        S_Is_Corporate ,
        S_Enquiry_Desc ,
        S_Title ,
        S_First_Name ,
        S_Middle_Name ,
        S_Last_Name ,
        Dt_Birth_Date ,
        S_Age ,
        I_Qualification_Name_ID ,
        C_Skip_Test ,
        I_Stream_ID ,
        I_Aptitude_Marks ,
        S_Email_ID ,
        S_Phone_No ,
        S_Mobile_No ,
        I_Curr_City_ID ,
        I_Curr_State_ID ,
        I_Curr_Country_ID ,
        S_Guardian_Name ,
        I_Guardian_Occupation_ID ,
        S_Guardian_Email_ID ,
        S_Guardian_Phone_No ,
        S_Guardian_Mobile_No ,
        I_Income_Group_ID ,
        S_Curr_Address1 ,
        S_Curr_Address2 ,
        S_Curr_Pincode ,
        S_Curr_Area ,
        S_Perm_Address1 ,
        S_Perm_Address2 ,
        S_Perm_Pincode ,
        I_Perm_City_ID ,
        I_Perm_State_ID ,
        I_Perm_Country_ID ,
        S_Perm_Area ,
        S_Crtd_By ,
        S_Upd_By ,
        Dt_Crtd_On ,
        Dt_Upd_On ,
        I_Corporate_ID
        FROM dbo.T_Enquiry_Regn_Detail AS terd
        WHERE terd.I_Enquiry_Regn_ID = @iEnquiryID
                  
                  
END
