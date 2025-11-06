

CREATE PROCEDURE [dbo].[uspGetPreEnquiryDetails_BKP_2023Nov] -- [dbo].[uspGetPreEnquiryDetails] 20393,'',17,2                  
    (
      -- Add the parameters for the stored procedure here                        
      @sEnquiryNo VARCHAR(20) = NULL ,
      @sMobileNo VARCHAR(20) = NULL ,
      @iCenterID INT = NULL ,
      @stuStatusFor INT = NULL                                 
    )
AS
    BEGIN 
	
	DECLARE @iEnquiryID INT=0
 -- SET NOCOUNT ON added to prevent extra result sets from                        
 -- interfering with SELECT statements.                        
        SET NOCOUNT ON         
        IF ( @stuStatusFor = 2 )
		BEGIN
            SELECT  A.I_Enquiry_Regn_ID ,
                    A.S_First_Name ,
                    A.S_Middle_Name ,
                    A.S_Last_Name ,
                    A.Dt_Birth_Date ,
                    A.S_Age ,
                    A.I_Sex_ID ,
                    A.I_Native_Language_ID ,
                    A.I_Nationality_ID ,
                    A.I_Religion_ID ,
                    A.I_Marital_Status_ID ,
                    A.I_Blood_Group_ID ,
                    A.I_Caste_ID ,
                    A.S_Email_ID ,
                    A.S_Phone_No ,
                    A.S_Student_Photo ,
                    A.S_Father_Name ,
                    A.I_Father_Qualification_ID ,
                    A.I_Father_Occupation_ID ,
                    A.I_Father_Business_Type_ID ,
                    A.S_Father_Designation ,
                    A.S_Father_Office_Address ,
                    A.S_Father_Office_Phone ,
                    A.I_Father_Income_Group_ID ,
                    A.S_Mother_Name ,
                    A.I_Mother_Qualification_ID ,
                    A.I_Mother_Occupation_ID ,
                    A.I_Mother_Business_Type_ID ,
                    A.S_Mother_Designation ,
                    A.S_Mother_Office_Address ,
                    A.S_Mother_Office_Phone ,
                    A.I_Mother_Income_Group_ID ,
                    A.S_Guardian_Name ,
                    A.S_Guardian_Relationship ,
                    A.S_Guardian_Address ,
                    A.S_Guardian_Phone_No ,
                    A.S_Guardian_Mobile_No ,
                    A.S_Curr_Address1 ,
                    A.S_Curr_Address2 ,
                    A.I_Curr_Country_ID ,
                    A.I_Curr_State_ID ,
                    A.I_Curr_City_ID ,
                    A.S_Curr_Pincode ,
                    A.S_Perm_Address1 ,
                    A.S_Perm_Address2 ,
                    A.I_Perm_Country_ID ,
                    A.I_Perm_State_ID ,
                    A.I_Perm_City_ID ,
                    A.S_Perm_Area ,
                    A.S_Perm_Pincode ,
                    A.S_Mobile_No ,
                    A.S_Enquiry_No ,         
  --A.I_Caste_ID ,    
                    A.B_Has_Given_Exam ,
                    A.I_Attempts ,
                    A.S_Other_Institute ,
                    A.N_Duration ,
                    A.I_Info_Source_ID ,
                    A.B_Has_Given_Exam ,
                    A.I_Seat_Type_ID ,
                    A.I_Enrolment_Type_ID ,
                    A.S_Enrolment_No ,
                    A.I_Rank_Obtained,
                    TEECS.I_Education_CurrentStatus_ID
            FROM    dbo.T_Enquiry_Regn_Detail A
            LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
            WHERE   A.I_Centre_Id = @iCenterID
                    AND S_Enquiry_No LIKE ISNULL(@sEnquiryNo, S_Enquiry_No)
                    AND S_Mobile_No LIKE ISNULL(@sMobileNo, S_Mobile_No)
                    AND ( B_IsPreEnquiry = 0
                          OR B_IsPreEnquiry = 1
                        )
                    AND ( I_Enquiry_Status_Code IS NULL
                          OR I_Enquiry_Status_Code = 1
                        )
                    AND ( I_PreEnquiryFor IS NULL
                          OR I_PreEnquiryFor NOT IN ( 2, 3 )
                        )           
  --AND S_Form_No IS NOT NULL 
  

			select @iEnquiryID=A.I_Enquiry_Regn_ID from dbo.T_Enquiry_Regn_Detail A where
			A.I_Centre_Id = @iCenterID
                    AND S_Enquiry_No LIKE ISNULL(@sEnquiryNo, S_Enquiry_No)
                    AND S_Mobile_No LIKE ISNULL(@sMobileNo, S_Mobile_No)
                    AND ( B_IsPreEnquiry = 0
                          OR B_IsPreEnquiry = 1
                        )
                    AND ( I_Enquiry_Status_Code IS NULL
                          OR I_Enquiry_Status_Code = 1
                        )
                    AND ( I_PreEnquiryFor IS NULL
                          OR I_PreEnquiryFor NOT IN ( 2, 3 )
                        )        
          
        END  
        ELSE
		BEGIN
            SELECT  A.I_Enquiry_Regn_ID ,
                    A.S_First_Name ,
                    A.S_Middle_Name ,
                    A.S_Last_Name ,
                    A.Dt_Birth_Date ,
                    A.S_Age ,
                    A.S_Father_Name ,
                    A.S_Mother_Name ,
                    A.S_Curr_Address1 ,
                    A.S_Curr_Address2 ,
                    A.I_Curr_Country_ID ,
                    A.I_Curr_State_ID ,
                    A.I_Curr_City_ID ,
                    A.S_Curr_Pincode ,
                    A.S_Mobile_No ,
                    A.S_Enquiry_No ,
                    A.I_Caste_ID ,
                    A.S_Father_Name ,
                    A.S_Mother_Name ,
                    A.I_Info_Source_ID ,
                    A.B_Has_Given_Exam ,
                    A.I_Seat_Type_ID ,
                    A.I_Enrolment_Type_ID ,
                    A.S_Enrolment_No ,
                    A.I_Rank_Obtained ,
                    A.I_Sex_ID ,
                    A.I_Native_Language_ID ,
                    A.I_Nationality_ID ,
                    A.I_Religion_ID ,
                    A.I_Marital_Status_ID ,
                    A.I_Blood_Group_ID ,
                    A.I_Caste_ID ,
                    A.S_Email_ID ,
                    A.S_Phone_No ,
                    A.S_Student_Photo ,
                    A.I_Father_Qualification_ID ,
                    A.I_Father_Occupation_ID ,
                    A.I_Father_Business_Type_ID ,
                    A.S_Father_Designation ,
                    A.S_Father_Office_Address ,
                    A.S_Father_Office_Phone ,
                    A.I_Father_Income_Group_ID ,
                    A.I_Mother_Qualification_ID ,
                    A.I_Mother_Occupation_ID ,
                    A.I_Mother_Business_Type_ID ,
                    A.S_Mother_Designation ,
                    A.S_Mother_Office_Address ,
                    A.S_Mother_Office_Phone ,
                    A.I_Mother_Income_Group_ID ,
                    A.S_Guardian_Name ,
                    A.S_Guardian_Relationship ,
                    A.S_Guardian_Address ,
                    A.S_Guardian_Phone_No ,
                    A.S_Guardian_Mobile_No ,
                    A.S_Curr_Address1 ,
                    A.S_Curr_Address2 ,
                    A.I_Curr_Country_ID ,
                    A.I_Curr_State_ID ,
                    A.I_Curr_City_ID ,
                    A.S_Curr_Pincode ,
                    A.S_Perm_Address1 ,
                    A.S_Perm_Address2 ,
                    A.I_Perm_Country_ID ,
                    A.I_Perm_State_ID ,
                    A.I_Perm_City_ID ,
                    A.S_Perm_Area ,
                    A.S_Perm_Pincode ,
                    A.B_Has_Given_Exam ,
                    A.I_Attempts ,
                    A.S_Other_Institute ,
                    A.N_Duration,
                    TEECS.I_Education_CurrentStatus_ID
            FROM    dbo.T_Enquiry_Regn_Detail A
            LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
            WHERE   A.I_Centre_Id = @iCenterID
                    AND S_Enquiry_No LIKE ISNULL(@sEnquiryNo, S_Enquiry_No)
                    AND S_Mobile_No LIKE ISNULL(@sMobileNo, S_Mobile_No)
                    AND B_IsPreEnquiry = 1
                    AND I_Enquiry_Status_Code IS NULL
                    AND ( I_PreEnquiryFor IS NULL
                          OR I_PreEnquiryFor NOT IN ( 2, 3 )
                        ) 
						

			select  @iEnquiryID=A.I_Enquiry_Regn_ID from dbo.T_Enquiry_Regn_Detail A where 
			A.I_Centre_Id = @iCenterID
                    AND S_Enquiry_No LIKE ISNULL(@sEnquiryNo, S_Enquiry_No)
                    AND S_Mobile_No LIKE ISNULL(@sMobileNo, S_Mobile_No)
                    AND B_IsPreEnquiry = 1
                    AND I_Enquiry_Status_Code IS NULL
                    AND ( I_PreEnquiryFor IS NULL
                          OR I_PreEnquiryFor NOT IN ( 2, 3 )
                        ) 
		END					
          
-- Table[1] Enquiry Course Details                              
        SELECT  DISTINCT
                A.I_Course_ID ,
                C.S_Course_Name ,
                C.I_CourseFamily_ID ,
                TCFM.S_CourseFamily_Name ,
                A.I_Enquiry_Regn_ID,
				COALESCE(c.I_Language_ID,0) as I_Language_ID,--samim
				COALESCE(c.I_Language_Name,'') as I_Language_Name--samim
        FROM    dbo.T_Enquiry_Course A ,
                dbo.T_Enquiry_Regn_Detail B WITH ( NOLOCK ) ,
                dbo.T_Course_Master C ,
                dbo.T_CourseFamily_Master AS TCFM
        WHERE   A.I_Course_ID = C.I_Course_ID
                AND A.I_Enquiry_Regn_ID = @iEnquiryID--@sEnquiryNo
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
                TEQD.S_Division ,
                TEQD.S_Institution
        FROM    dbo.T_Enquiry_Qualification_Details AS TEQD
        WHERE   I_Enquiry_Regn_ID = @iEnquiryID--@sEnquiryNo
                AND TEQD.I_Status = 1 
---- Table[3] Enquiry Course Details 
--        SELECT  TEECS.I_Enquiry_Regn_ID ,
--                TEECS.I_Education_CurrentStatus_ID
--        FROM    dbo.T_Enquiry_Education_CurrentStatus AS TEECS
--        WHERE   TEECS.I_Enquiry_Regn_ID = @sEnquiryNo

                            
    END 
