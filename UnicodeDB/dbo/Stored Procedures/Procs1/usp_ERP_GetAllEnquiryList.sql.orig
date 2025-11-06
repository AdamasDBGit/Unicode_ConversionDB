-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_GetAllEnquiryList] 3, null, null, null
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllEnquiryList]
	-- Add the parameters for the stored procedure here
	(
		@I_Enquiry_Regn_ID INT = null,
		@Full_Name VARCHAR = null,
		@Email VARCHAR(255) = null,
		@Mobile VARCHAR(255) = null
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TEERD.[I_Enquiry_Regn_ID] AS EnquiryRegnID
      ,[I_Enquiry_Status_Code] AS EnquiryStatusCode
      ,TEERD.[I_Info_Source_ID] AS SourceID
	  ,TEISM.S_Info_Source_Name AS SourceName
	  --,[S_Info_Source_Name] -- T_ERP_Information_Source_Master
      ,TEERD.[I_Enquiry_Type_ID] AS EnquiryType
	  ,TEET.[S_Enquiry_Type_Desc] AS EnquiryTypeDesc -- T_ERP_Enquiry_Type
      ,[S_Enquiry_No] AS EnquiryNo
	  ,CONCAT(ISNULL(TEERD.S_First_Name, ''),' ',ISNULL(TEERD.S_Middle_Name, ''),' ',ISNULL(TEERD.S_Last_Name, '')) AS Full_Name
      --,[Dt_Birth_Date] AS DOB
	  --,CAST( [Dt_Birth_Date] AS DATE) AS DOB
	  ,DATENAME(YEAR, [Dt_Birth_Date]) + '-' + RIGHT('0' + CAST(MONTH([Dt_Birth_Date]) AS VARCHAR(2)), 2) + '-' + RIGHT('0' + CAST(DAY([Dt_Birth_Date]) AS VARCHAR(2)), 2) AS DOB
      ,TEERD.S_Email_ID AS Email
      ,TEERD.S_Mobile_No AS Mobile
      --,TEERD.[I_Income_Group_ID] AS IncomeGroupID
	  --,TEIGM.[S_Income_Group_Name] AS IncomeGroupName -- [T_ERP_Income_Group_Master]
      ,TEERD.[S_Crtd_By] AS CreatedBy
      ,TEERD.[S_Upd_By] AS UpdatedBy
	  ,CAST(TEERD.[Dt_Crtd_On] AS DATE) AS CreatedOn
      --,TEERD.[Dt_Crtd_On] AS CreatedOn
      --,TEERD.[Dt_Upd_On] AS UpdatedOn
	  ,CAST(TEERD.[Dt_Upd_On] AS DATE) AS UpdatedOn
      ,TEERD.[I_Caste_ID] AS CasteID
	  ,TECM.[S_Caste_Name] AS CasteName --[T_ERP_Caste_Master]
      ,[S_Student_Photo] AS Photo
      ,[B_IsPreEnquiry] AS IsPreEnquiry
      ,TEERD.[I_Gender_ID] AS GenderID
	  ,TEG.[S_Gender_Name] AS GenderName  --[T_ERP_Gender]
      ,TEERD.[I_Native_Language_ID] AS NativeLanguageID
	  ,TENL.[S_Native_Language_Name] AS NativeLanguageName --[T_ERP_Native_Language]
      ,TEERD.[I_Nationality_ID] AS NationalityID
	  ,TUN.[S_Nationality] AS Nationality --[T_User_Nationality]
      ,TEERD.[I_Religion_ID] AS ReligionID
	  ,TUR.[S_Religion_Name] AS ReligionName --[T_User_Religion]
      ,TEERD.[I_Marital_Status_ID] AS MaritalStatusID
	  ,TEMS.[S_Marital_Status] AS MaritalStatus --[T_ERP_Marital_Status]
      ,TEERD.[I_Blood_Group_ID] AS BloodGroupID
	  ,TEBG.[S_Blood_Group] AS BloodGroup --[T_ERP_Blood_Group]
      ,TEERD.[I_Monthly_Family_Income_ID] AS MonthlyFamilyIncomeID
	  ,TEIGM.[S_Income_Group_Name] AS MonthlyFamilyIncome -- [T_ERP_Income_Group_Master]
      ,[I_PreEnquiryFor] AS PreEnquiryFor
      --,[Enquiry_Date] AS EnquiryDate
	  ,CAST([Enquiry_Date] AS DATE) AS EnquiryDate
      ,[Enquiry_Crtd_By] AS EnquiryCretedBy
      --,[PreEnquiryDate] AS PreEnquiryDate
	  ,CAST([PreEnquiryDate] AS DATE) AS PreEnquiryDate
      ,[PreEnquiry_Crtd_By] AS PreEnquiryCreatedBy
      ,[I_Course_Applied_For] AS CourseAppliedForID
	  ,[S_Class_Name] AS CourseAppliedFor --[T_Class]
	  ,TEERA.S_Address_Type AS AddressType
	  ,TEERA.S_Country_ID AS CountryID
	  ,TCM.S_Country_Name AS CountryName
	  ,TEERA.S_State_ID AS StateID
	  ,TESM.S_State_Name AS StateName
	  ,TEERA.S_City_ID AS CityID
	  ,TCCM.S_City_Name AS CityName
	  ,TEERA.S_Area AS Area
	  ,TEERA.S_Pincode AS Pincode
	  ,TEERA.S_Address1 AS Address1
	  ,TEERA.S_Address2 AS Address2
	  ,TEERD.App_Payment_Status AS AppPaymentStatus
	  --,CONCAT(ISNULL(TEERGM.S_First_Name, ''),' ',ISNULL(TEERGM.S_Middile_Name, ''),' ',ISNULL(TEERGM.S_Last_Name, '')) AS Guardian_Name
	  --,TEERGM.I_Relation_ID AS RelationID
	  --,TRM.S_Relation_Type AS RelationName
	  --,TEERGM.S_Mobile_No AS GaurdianMobile
	  --,TEERGM.S_Guardian_Email AS GuardianEmail
	  ----,TEERGM.I_Business_Type_ID AS GuardianBussinessType
	  --,TEERGM.I_Income_Group_ID AS GuardianIncomeGroupID
	  --,TEIGM2.S_Income_Group_Name AS GuardianIncomeGroup
	  --,TEERGM.I_Qualification_ID AS GuardianQualificationID
	  --,TEQNM.S_Qualification_Name AS GuardianQualificationName
	  --,TEERGM.I_Occupation_ID AS GuardianOccupationID
	  --,TEERGM.S_Designation AS GuardianDesignation
	  --,TEERGM.S_Company_Name AS GuardianCompany
	  --,TEERF.I_Followup_ID AS FollowUpID
	  --,TEERF.Dt_Followup_Date AS FollowUpDate
	  --,TEERF.R_I_Enquiry_Type_ID AS FollowUpEnquiryType
	  --,TEET2.S_Enquiry_Type_Desc AS FollowUpType
	  --,TEERF.S_Followup_By AS FollowUpBy
	  --,TEERF.S_Followup_Status AS FollowUpStatus
	  --,TEERF.S_Followup_Remarks AS FollowUpRemark


	  FROM [T_ERP_Enquiry_Regn_Detail] AS TEERD 
	  inner join T_ERP_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID
	  left join T_ERP_Income_Group_Master AS TEIGM ON TEERD.I_Income_Group_ID = TEIGM.I_Income_Group_ID
	  left join T_ERP_Caste_Master AS TECM ON TEERD.I_Caste_ID = TECM.I_Caste_ID
	  left join T_ERP_Gender AS TEG ON TEERD.I_Gender_ID = TEG.I_Gender_ID
	  left join T_ERP_Native_Language AS TENL ON TEERD.I_Native_Language_ID = TENL.I_Native_Language_ID
	  left join T_User_Nationality AS TUN ON TEERD.I_Nationality_ID = TUN.I_Nationality_ID
	  left join T_User_Religion AS TUR ON TEERD.I_Religion_ID = TUR.I_Religion_ID
	  left join T_ERP_Marital_Status AS TEMS ON TEERD.I_Marital_Status_ID = TEMS.I_Marital_Status_ID
	  left join T_ERP_Blood_Group AS TEBG ON TEERD.I_Blood_Group_ID = TEBG.I_Blood_Group_ID
	  left join T_Class AS TC ON TEERD.I_Course_Applied_For = TC.I_Class_ID
	  left join T_ERP_Information_Source_Master AS TEISM ON TEERD.I_Info_Source_ID = TEISM.I_Info_Source_ID
	  left join T_ERP_Enquiry_Regn_Address AS TEERA ON TEERD.I_Enquiry_Regn_ID = TEERA.I_Enquiry_Regn_ID
	  left join T_Country_Master AS TCM ON TEERA.S_Country_ID = TCM.I_Country_ID
	  left join T_ERP_State_Master AS TESM ON TEERA.S_State_ID = TESM.I_State_ID
	  left join T_City_Master AS TCCM ON TEERA.S_City_ID = TCCM.I_City_ID
	  --left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID
	  --left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID
	  --left join T_ERP_Income_Group_Master AS TEIGM2 ON TEERGM.I_Income_Group_ID = TEIGM2.I_Income_Group_ID
	  --left join T_ERP_Qualification_Name_Master AS TEQNM ON TEERGM.I_Qualification_ID = TEQNM.I_Qualification_Name_ID
	  --left join T_ERP_Enquiry_Regn_Followup AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID
	  --left join T_ERP_Enquiry_Type AS TEET2 ON TEERF.R_I_Enquiry_Type_ID = TEET2.I_Enquiry_Type_ID

	  WHERE
		(TEERD.I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID OR @I_Enquiry_Regn_ID IS NULL)
		AND (
			CONCAT(ISNULL(TEERD.S_First_Name, ''), ' ', ISNULL(TEERD.S_Middle_Name, ''), ' ', ISNULL(TEERD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%' OR @Full_Name IS NULL
		)
        AND (
			TEERD.S_Email_ID LIKE '%' + @Email + '%' OR @Email IS NULL
		)
		AND (
			TEERD.S_Mobile_No LIKE '%' + @Mobile + '%' OR @Mobile IS NULL
		)

		SELECT 
		--TEERD.Enquiry_Date AS EnquiryDate
		
		--,TEERF.I_Followup_ID AS FollowUpID
		TEERF.R_I_FollowupType_ID AS FollowUpType --
		,TEFM.S_Followup_Name AS FollowUpTypeName
		,TEERF.S_Followup_By AS FollowUpBy
		,TEERF.Dt_Followup_Date AS FollowUpDate
		,TEERF.I_Followup_Status AS FollowUpStatus
		,TEERF.S_Followup_Remarks AS FollowUpRemark
		--,TEFM.S_Followup_Name AS FollowUpName
		
		FROM T_ERP_Enquiry_Regn_Detail AS TEERD
		inner join T_ERP_Enquiry_Regn_Followup AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID
		--left join T_ERP_Followup_Closure_Master AS TEFCM ON TEERF.R_I_Followup_Closure_ID = TEFCM.I_Followup_Closure_ID
		left join T_ERP_Enquiry_Type AS TEET ON TEERF.R_I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID
		left join T_ERP_FollowupType_Master AS TEFM ON TEERF.R_I_FollowupType_ID = TEFM.I_FollowupType_ID
		--left join T_ERP_FollowupType_Master AS TEFM ON TEERF.R_I_FollowupType_ID = TEFM.I_FollowupType_ID

		WHERE (TEERF.R_I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID OR @I_Enquiry_Regn_ID IS NULL)

		SELECT
		CONCAT(ISNULL(TEERGM.S_First_Name, ''),' ',ISNULL(TEERGM.S_Middile_Name, ''),' ',ISNULL(TEERGM.S_Last_Name, '')) AS Guardian_Name
		,TEERGM.I_Relation_ID AS RelationID
		,TRM.S_Relation_Type AS RelationName
		,TEERGM.S_Mobile_No AS GaurdianMobile
		,TEERGM.S_Guardian_Email AS GuardianEmail
		--,TEERGM.I_Business_Type_ID AS GuardianBussinessType
		,TEERGM.I_Income_Group_ID AS GuardianIncomeGroupID
		,TEIGM2.S_Income_Group_Name AS GuardianIncomeGroup
		,TEERGM.I_Qualification_ID AS GuardianQualificationID
		,TEQNM.S_Qualification_Name AS GuardianQualificationName
		,TEERGM.I_Occupation_ID AS GuardianOccupationID
		,TEOM.S_Occupation_Name AS GuardianOccupationName
		,TEERGM.S_Designation AS GuardianDesignation
		,TEERGM.S_Company_Name AS GuardianCompany
		
		FROM T_ERP_Enquiry_Regn_Detail AS TEERD
		left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID
		left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID
		left join T_ERP_Income_Group_Master AS TEIGM2 ON TEERGM.I_Income_Group_ID = TEIGM2.I_Income_Group_ID
		left join T_ERP_Qualification_Name_Master AS TEQNM ON TEERGM.I_Qualification_ID = TEQNM.I_Qualification_Name_ID
		left join T_ERP_Occupation_Master AS TEOM ON TEERGM.I_Occupation_ID = TEOM.I_Occupation_ID

		WHERE (TEERGM.I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID OR @I_Enquiry_Regn_ID IS NULL)

END
