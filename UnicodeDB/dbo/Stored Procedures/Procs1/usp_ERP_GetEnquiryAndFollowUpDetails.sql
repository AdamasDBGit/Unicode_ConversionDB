CREATE PROCEDURE [dbo].[usp_ERP_GetEnquiryAndFollowUpDetails]  
	@I_Enquiry_Regn_ID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	--------------------------------------------------------------------------------------------
	------------------------  Get the Enquiry Info ---------------------------------
	--------------------------------------------------------------------------------------------
	SELECT TEERD.[I_Enquiry_Regn_ID] AS EnquiryRegnID
      ,[I_Enquiry_Status_Code] AS EnquiryStatusCode
      ,TEERD.[I_Enquiry_Type_ID] AS EnquiryType
	  ,TEET.[S_Enquiry_Type_Desc] AS EnquiryTypeDesc 
      ,[S_Enquiry_No] AS EnquiryNo
	  ,CONCAT(ISNULL(TEERD.S_First_Name, ''),' ',ISNULL(TEERD.S_Middle_Name, ''),' ',ISNULL(TEERD.S_Last_Name, '')) AS Full_Name
      ,TEERD.S_Email_ID AS Email
      ,TEERD.S_Mobile_No AS Mobile
	  ,TEERD.R_I_School_Session_ID AS AcademicSessionID
	  ,TSASM.S_Label AS AcademicSessionName
      ,[S_Student_Photo] AS Photo
	  ,CAST(TEERD.[Dt_Crtd_On] AS DATE) AS EnquiryDate
      ,[Enquiry_Crtd_By] AS EnquiryCretedBy
	  ,CAST(TEERD.[PreEnquiryDate] AS DATE) AS PreEnquiryDate
      ,[PreEnquiry_Crtd_By] AS PreEnquiryCreatedBy
	  ,TEERD.App_Payment_Status AS AppPaymentStatus
	  ,TEERD.S_Father_Name as FatherName
	  ,TEERD.S_Mother_Name AS MotherName
	  ,ISNULL(TEISM.S_Info_Source_Name,'NA') S_Info_Source_Name,
	  TEISM.I_Info_Source_ID
	  ,ISNULL(TECD.S_Name,'NA') S_Name
	  ,ISNULL(TEECD.S_Referal,'NA')S_Referal


	  FROM [T_Enquiry_Regn_Detail] AS TEERD 
	  left join T_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID
	  left join T_School_Academic_Session_Master as TSASM on TEERD.R_I_School_Session_ID = TSASM.I_School_Session_ID
	  left join T_ERP_Enquiry_CRM_Details TEECD on TEECD.I_Enquiry_ID=TEERD.I_Enquiry_Regn_ID
	  left join T_ERP_CRMSource_Details TECD on TECD.I_Source_DetailsID = TEECD.I_Source_DetailsID
	  left join T_ERP_EnqType_Source_Mapping TEESM ON TEESM.I_EnqType_Source_Mapping_ID=TECD.I_EnqType_Source_Mapping_ID
	  left join T_Information_Source_Master TEISM ON TEISM.I_Info_Source_ID = TEESM.I_Info_Source_ID
	  

	  WHERE
		(TEERD.I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID) AND I_ERP_Entry = 1
	



		--------------------------------------------------------------------------------------------
		------------------------  Get the FolllowUp Info ---------------------------------
		--------------------------------------------------------------------------------------------

		SELECT 		
		TEERF.ERP_R_I_FollowupType_ID AS FollowUpType --
		,TEFM.S_Followup_Name AS FollowUpTypeName
		,TEERF.Dt_Followup_Date AS FollowUpDate
		,TEERF.Dt_Next_Followup_Date AS NextFollowUpDate
		,TEERF.S_Followup_Status AS FollowUpStatus
		,TEFSM.S_FollowupStatus_Desc AS FollowUpStatusDesc
		,TEERF.S_Followup_Remarks AS FollowUpRemark

		FROM
		T_Enquiry_Regn_Followup AS TEERF 
		inner join [dbo].[T_ERP_Followup_StatusM] as TEFSM on TEFSM.[I_FollowupStatus_ID] = TEERF.S_Followup_Status
		left join T_ERP_FollowupType_Master AS TEFM ON TEERF.ERP_R_I_FollowupType_ID = TEFM.I_FollowupType_ID

		
		WHERE (TEERF.I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID )
		order by TEERF.I_Followup_ID desc
END
