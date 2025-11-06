CREATE PROCEDURE [dbo].[uspGetEnquiryDetails_BKP_LANG]    
    (    
      -- Add the parameters for the stored procedure here                              
      @iEnquiryRegnID INT = NULL ,    
      @dStartDate DATETIME = NULL ,    
      @dEndDate DATETIME = NULL ,    
      @iEnquiryStatus INT = NULL ,    
      @sFirstName VARCHAR(50) = NULL ,    
      @sMiddleName VARCHAR(50) = NULL ,    
      @sLastName VARCHAR(50) = NULL ,    
      @sEnquiryNo VARCHAR(20) = NULL ,    
      @sCourseList VARCHAR(500) = NULL ,    
      @iCenterID INT = NULL ,    
      @dtFollowUpFromDate DATETIME = NULL ,    
      @dtFollowUpToDate DATETIME = NULL ,    
      @sFormNo VARCHAR(100) = NULL                             
    )    
AS     
    BEGIN                              
 -- SET NOCOUNT ON added to prevent extra result sets from                              
 -- interfering with SELECT statements.                              
        SET NOCOUNT ON                              
                              
        IF ( ( @iEnquiryRegnID = 0 )    
             OR ( @iEnquiryRegnID IS NULL )    
           )     
            BEGIN                              
   -- Table[0]  Enquiry Details                              
                SELECT  I_Enquiry_Regn_ID ,    
                        S_First_Name ,    
                        S_Middle_Name ,    
                        S_Last_Name ,    
                        A.Dt_Crtd_On ,    
                        I_Enquiry_Status_Code ,    
                        S_Title ,    
                        Dt_Birth_Date ,    
                        S_Age ,    
                        C_Skip_Test ,    
                        S_Email_ID ,    
                        S_Phone_No ,    
                        S_Mobile_No ,    
                        I_Qualification_Name_ID ,    
                        I_Occupation_ID ,    
                        I_Stream_ID ,    
                        I_Pref_Career_ID ,    
                        S_Guardian_Name ,    
                        I_Guardian_Occupation_ID ,    
                        S_Guardian_Email_ID ,    
                        S_Guardian_Phone_No ,    
                        S_Guardian_Mobile_No ,    
                        I_Income_Group_ID ,    
                        S_Curr_Address1 ,    
                        S_Curr_Address2 ,    
                        I_Curr_Country_ID ,    
                        I_Curr_State_ID ,    
                        I_Curr_City_ID ,    
                        S_Curr_Area ,    
                        S_Curr_Pincode ,    
                        S_Perm_Address1 ,    
                        S_Perm_Address2 ,    
                        I_Perm_Country_ID ,    
                        I_Perm_State_ID ,    
                        I_Perm_City_ID ,    
                        S_Perm_Area ,    
                        S_Perm_Pincode ,    
                        S_Enquiry_No ,    
                        I_Enquiry_Type_ID ,    
                        S_Is_Corporate ,    
                        I_Info_Source_ID ,    
                        S_Enquiry_Desc ,    
                        A.S_Crtd_By ,    
                        S_Student_Photo ,    
                        A.I_Corporate_ID ,    
                        A.I_Corporate_Plan_ID ,    
                        S_Corporate_Plan_Name ,    
                        I_Caste_ID ,    
                        I_Residence_Area_ID ,    
                        CASE WHEN S_Father_Name IS NULL OR S_Father_Name='' OR S_Father_Name LIKE '%LATE%' OR S_Father_Name LIKE '%Late%' THEN S_Guardian_Name
                        WHEN S_Father_Name IS NOT NULL AND S_Father_Name!='' AND S_Father_Name NOT LIKE '%LATE%' AND S_Father_Name NOT LIKE '%Late%' THEN S_Father_Name
                        END AS S_Father_Name ,    
                        S_Mother_Name ,    
                        B_IsPreEnquiry ,    
                        I_Sex_ID ,    
                        I_Native_Language_ID ,    
                        I_Nationality_ID ,    
                        I_Religion_ID ,    
                        I_Marital_Status_ID ,    
                        I_Blood_Group_ID ,    
                        I_Father_Qualification_ID ,    
                        I_Father_Occupation_ID ,    
                        I_Father_Business_Type_ID ,    
                        S_Father_Company_Name ,    
                        S_Father_Designation ,    
                        S_Father_Office_Phone ,    
                        I_Father_Income_Group_ID ,    
 S_Father_Photo ,    
                        S_Father_Office_Address ,    
                        I_Mother_Qualification_ID ,    
                        I_Mother_Occupation_ID ,    
                        I_Mother_Business_Type_ID ,    
                        S_Mother_Designation ,    
                        S_Mother_Company_Name ,    
                        S_Mother_Office_Address ,    
                        S_Mother_Office_Phone ,    
                        I_Mother_Income_Group_ID ,    
                        S_Mother_Photo ,    
                        S_Guardian_Relationship ,    
                        S_Guardian_Address ,    
                        I_Monthly_Family_Income_ID ,    
                        B_Can_Sponsor_Education ,    
                        S_Sibling_ID ,    
                        B_Has_Given_Exam ,    
                        I_Attempts ,    
                        S_Other_Institute ,    
                        N_Duration ,    
                        I_Seat_Type_ID ,    
                        I_Enrolment_Type_ID ,    
                        S_Enrolment_No ,    
                        I_Rank_Obtained ,    
                        S_Univ_Registration_No ,    
                        S_Univ_Roll_No ,    
                        I_Scholar_Type_ID ,    
                        S_Second_Language_Opted ,    
                        S_Physical_Ailment ,    
                        S_Form_No  ,
                        B_IsLateral  
                FROM    dbo.T_Enquiry_Regn_Detail A WITH ( NOLOCK )    
                        LEFT OUTER JOIN CORPORATE.T_Corporate_Plan AS tcp2 ON A.I_Corporate_Plan_ID = tcp2.I_Corporate_Plan_ID    
                WHERE   CAST(CONVERT(VARCHAR(10), A.Dt_Crtd_On, 101) AS DATETIME) >= ISNULL(@dStartDate,    
                                                              '1/1/2000')    
                        AND CAST(CONVERT(VARCHAR(10), A.Dt_Crtd_On, 101) AS DATETIME) <= ISNULL(@dEndDate,    
                                                              GETDATE())    
                        AND A.I_Enquiry_Status_Code = ISNULL(@iEnquiryStatus,    
                                                             A.I_Enquiry_Status_Code)    
                        AND A.S_First_Name LIKE ISNULL(@sFirstName,    
                                                       A.S_First_Name) + '%'    
                        AND ISNULL(A.S_Middle_Name, '') LIKE ISNULL(@sMiddleName,    
                                                              ISNULL(A.S_Middle_Name,    
                                                              '')) + '%'    
                        AND A.S_Last_Name LIKE ISNULL(@sLastName,    
                                                      A.S_Last_Name) + '%'    
                        AND A.S_Enquiry_No LIKE ISNULL(@sEnquiryNo,    
                                                       A.S_Enquiry_No) + '%'    
                            
                        AND ISNULL(A.S_Form_No, '') = ISNULL(@sFormNo,    
                                                              ISNULL(A.S_Form_No,    
                                                              ''))    
                        AND A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id)    
                        AND ( A.I_Enquiry_Regn_ID IN (    
                              SELECT    I_Enquiry_Regn_ID    
                              FROM      dbo.T_Enquiry_Course    
                              WHERE     CHARINDEX(','    
                                                  + CAST(I_Course_ID AS VARCHAR(20))    
                                                  + ',',    
                                                  ISNULL(@sCourseList,    
                                                         ','    
                                                         + CAST(I_Course_ID AS VARCHAR(20))    
                                               + ',')) > 0 )    
                              OR @sCourseList IS NULL    
                            )    
                ORDER BY A.I_Enquiry_Regn_ID                              
                                    
            
    -- Table[1] Enquiry Course Details                                
                SELECT  A.I_Course_ID ,    
                        C.S_Course_Name ,    
                        C.I_CourseFamily_ID ,    
                        TCFM.S_CourseFamily_Name ,    
                        B.I_Enquiry_Regn_ID    
                FROM    dbo.T_Enquiry_Course A ,    
                        dbo.T_Enquiry_Regn_Detail B WITH ( NOLOCK ) ,    
                        dbo.T_Course_Master C ,    
                        dbo.T_CourseFamily_Master AS TCFM    
                WHERE   B.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID    
                        AND A.I_Course_ID = C.I_Course_ID    
                        AND C.I_CourseFamily_ID = TCFM.I_CourseFamily_ID    
                        AND A.I_Enquiry_Regn_ID IN (    
                        SELECT  I_Enquiry_Regn_ID    
                        FROM    dbo.T_Enquiry_Regn_Detail A WITH ( NOLOCK )    
                        WHERE   Dt_Crtd_On BETWEEN ISNULL(@dStartDate,    
                                                          '4/3/2000')    
                                           AND     ISNULL(@dEndDate, GETDATE())    
                                AND A.I_Enquiry_Status_Code = ISNULL(@iEnquiryStatus,    
                                                              A.I_Enquiry_Status_Code)    
                                AND A.S_First_Name LIKE ISNULL(@sFirstName,    
                                                              A.S_First_Name)    
                                + '%'    
                                AND ISNULL(A.S_Middle_Name, '') LIKE ISNULL(@sMiddleName,    
                                                              ISNULL(A.S_Middle_Name,    
                                                              '')) + '%'    
                                AND A.S_Last_Name LIKE ISNULL(@sLastName,    
                                                              A.S_Last_Name)    
                                + '%'    
                                AND A.S_Enquiry_No LIKE ISNULL(@sEnquiryNo,    
                                                              A.S_Enquiry_No)    
                                + '%'    
                                AND A.I_Centre_Id = ISNULL(@iCenterID,    
                                                           A.I_Centre_Id)    
                                AND A.I_Enquiry_Regn_ID IN (    
                                SELECT  I_Enquiry_Regn_ID    
                                FROM    dbo.T_Enquiry_Course    
                                WHERE   CHARINDEX(','    
                                                  + CAST(I_Course_ID AS VARCHAR(20))    
                                                  + ',',    
                                                  ISNULL(@sCourseList,    
                                                         ','    
                                                         + CAST(I_Course_ID AS VARCHAR(20))    
                                                         + ',')) > 0 ) )             
            
            
 --Table[2] Enquiry Qualification Details            
                SELECT  TEQD.I_Enquiry_Regn_ID ,    
                        TEQD.S_Name_Of_Exam ,    
                        TEQD.S_University_Name ,    
                        TEQD.S_Year_From ,    
                        TEQD.S_Year_To ,    
                        TEQD.S_Subject_Name ,    
                        TEQD.N_Marks_Obtained ,    
                        TEQD.N_Percentage ,    
                        TEQD.S_Division,
                        TEQD.S_Institution    
                FROM    dbo.T_Enquiry_Qualification_Details AS TEQD    
                        INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TEQD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID    
                WHERE   CAST(CONVERT(VARCHAR(10), TERD.Dt_Crtd_On, 101) AS DATETIME) >= ISNULL(@dStartDate,    
                                                              '1/1/2000')    
                        AND CAST(CONVERT(VARCHAR(10), TERD.Dt_Crtd_On, 101) AS DATETIME) <= ISNULL(@dEndDate,    
                      GETDATE())    
                        AND I_Enquiry_Status_Code = ISNULL(@iEnquiryStatus,    
                                                           I_Enquiry_Status_Code)    
                        AND S_First_Name LIKE ISNULL(@sFirstName, S_First_Name)    
                        + '%'    
                        AND ISNULL(S_Middle_Name, '') LIKE ISNULL(@sMiddleName,    
                                                              ISNULL(S_Middle_Name,    
                                                              '')) + '%'    
                        AND S_Last_Name LIKE ISNULL(@sLastName, S_Last_Name)    
                        + '%'    
                        AND S_Enquiry_No LIKE ISNULL(@sEnquiryNo, S_Enquiry_No)    
                        + '%'    
                        AND I_Centre_Id = ISNULL(@iCenterID, I_Centre_Id)    
                        AND TERD.I_Enquiry_Regn_ID IN (    
                        SELECT  I_Enquiry_Regn_ID    
                        FROM    dbo.T_Enquiry_Course    
                        WHERE   CHARINDEX(','    
                                          + CAST(I_Course_ID AS VARCHAR(20))    
                                          + ',',    
                                          ISNULL(@sCourseList,    
                                                 ','    
                                                 + CAST(I_Course_ID AS VARCHAR(20))    
                                                 + ',')) > 0 )    
                        AND TEQD.I_Status = 1                                                              
            END                               
        ELSE     
            BEGIN                               
                SELECT  I_Enquiry_Regn_ID ,    
                        S_First_Name ,    
                        S_Middle_Name ,    
                        S_Last_Name ,    
                        A.Dt_Crtd_On ,    
                        I_Enquiry_Status_Code ,    
                        S_Title ,    
                        Dt_Birth_Date ,    
                        S_Age ,    
                        C_Skip_Test ,    
                        S_Email_ID ,    
                        S_Phone_No ,    
                        S_Mobile_No ,    
                        I_Qualification_Name_ID ,    
                        I_Occupation_ID ,    
                        I_Stream_ID ,    
                        I_Pref_Career_ID ,    
                        S_Guardian_Name ,    
                        I_Guardian_Occupation_ID ,    
                        S_Guardian_Email_ID ,    
                        S_Guardian_Phone_No ,    
                        S_Guardian_Mobile_No ,    
                        I_Income_Group_ID ,    
                        S_Curr_Address1 ,    
                        S_Curr_Address2 ,    
                        I_Curr_Country_ID ,    
                        I_Curr_State_ID ,    
                        I_Curr_City_ID ,    
                        S_Curr_Area ,    
                        S_Curr_Pincode ,    
                        S_Perm_Address1 ,    
                        S_Perm_Address2 ,    
                        I_Perm_Country_ID ,    
                        I_Perm_State_ID ,    
                        I_Perm_City_ID ,    
                        S_Perm_Area ,    
                        S_Perm_Pincode ,    
                        S_Enquiry_No ,    
                        I_Enquiry_Type_ID ,    
                        S_Is_Corporate ,    
                        I_Info_Source_ID ,    
                        S_Enquiry_Desc ,    
                        A.S_Crtd_By ,    
                        S_Student_Photo ,    
                        A.I_Corporate_ID ,    
                        A.I_Corporate_Plan_ID ,    
                        S_Corporate_Plan_Name ,    
                        I_Caste_ID ,    
                        I_Residence_Area_ID ,    
                        S_Father_Name ,    
                        S_Mother_Name ,    
                        B_IsPreEnquiry ,    
                        I_Sex_ID ,    
                        I_Native_Language_ID ,    
                        I_Nationality_ID ,    
                        I_Religion_ID ,    
                        I_Marital_Status_ID ,    
                        I_Blood_Group_ID ,    
                        I_Father_Qualification_ID ,    
                        I_Father_Occupation_ID ,    
                        I_Father_Business_Type_ID ,    
                        S_Father_Company_Name ,    
                        S_Father_Designation ,    
                        S_Father_Office_Phone ,    
                        I_Father_Income_Group_ID ,    
                        S_Father_Photo ,    
                        S_Father_Office_Address ,    
                        I_Mother_Qualification_ID ,    
                        I_Mother_Occupation_ID ,    
                        I_Mother_Business_Type_ID ,    
                        S_Mother_Designation ,    
                        S_Mother_Company_Name ,    
                        S_Mother_Office_Address ,    
                        S_Mother_Office_Phone ,    
                        I_Mother_Income_Group_ID ,    
                        S_Mother_Photo ,    
                        S_Guardian_Relationship ,    
                        S_Guardian_Address ,    
                        I_Monthly_Family_Income_ID ,    
                        B_Can_Sponsor_Education ,    
                        S_Sibling_ID ,    
                        B_Has_Given_Exam ,    
                        I_Attempts ,    
                        S_Other_Institute ,    
                        N_Duration ,    
                        I_Seat_Type_ID ,    
                        I_Enrolment_Type_ID ,    
                        S_Enrolment_No ,    
                        I_Rank_Obtained ,    
                        S_Univ_Registration_No ,    
                        S_Univ_Roll_No ,    
                        I_Scholar_Type_ID ,    
                        S_Second_Language_Opted ,    
                        S_Physical_Ailment ,    
                        S_Form_No  ,
                        B_IsLateral  
                FROM    dbo.T_Enquiry_Regn_Detail A WITH ( NOLOCK )    
                        LEFT OUTER JOIN CORPORATE.T_Corporate_Plan AS tcp1 ON A.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID    
                WHERE   A.I_Enquiry_Regn_ID = @iEnquiryRegnID    
                ORDER BY A.I_Enquiry_Regn_ID                              
                                 
                                 
                                  
    -- Table[1] Enquiry Course Details                                
                SELECT  DISTINCT    
                        A.I_Course_ID ,    
                        C.S_Course_Name ,    
                        C.I_CourseFamily_ID ,    
                        TCFM.S_CourseFamily_Name ,    
                        A.I_Enquiry_Regn_ID    
                FROM    dbo.T_Enquiry_Course A ,    
                        dbo.T_Enquiry_Regn_Detail B WITH ( NOLOCK ) ,    
                        dbo.T_Course_Master C ,    
                        dbo.T_CourseFamily_Master AS TCFM    
                WHERE   A.I_Course_ID = C.I_Course_ID    
                        AND A.I_Enquiry_Regn_ID = @iEnquiryRegnID    
                        AND C.I_CourseFamily_ID = TCFM.I_CourseFamily_ID             
                                    
 --Table[2] Enquiry Qualification Details            
                SELECT  TEQD.I_Enquiry_Regn_ID ,    
                        TEQD.S_Name_Of_Exam ,    
                        TEQD.S_University_Name ,    
                        TEQD.S_Year_From ,    
              TEQD.S_Year_To ,    
                        TEQD.S_Subject_Name ,    
                        TEQD.N_Marks_Obtained ,    
                        TEQD.N_Percentage ,    
                        TEQD.S_Division,
                        TEQD.S_Institution    
                FROM    dbo.T_Enquiry_Qualification_Details AS TEQD    
                WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID    
                        AND TEQD.I_Status = 1                                                        
            END                               
    END   
