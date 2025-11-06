-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [dbo].[uspERPGetPreEnquiryList] null, null, null, null, null
-- =============================================
CREATE PROCEDURE [dbo].[uspERPGetPreEnquiryList]
	-- Add the parameters for the stored procedure here
	(
		@Enquiry_No VARCHAR(100) = null,
		@Full_Name VARCHAR(100) = null,
		@GuardianName VARCHAR(100) = null,
		@Mobile VARCHAR(255) = null,
		@SchoolGroupID VARCHAR(100) = null
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TEERD.I_Enquiry_Regn_ID EnquiryRegnID
	,TEERD.S_Enquiry_No EnquiryNo
	,TEERD.I_Enquiry_Type_ID EnquiryTypeID
	,TEET.S_Enquiry_Type_Desc EnquiryTypeDesc
	,TEERD.PreEnquiryDate LeadDate
	,CONCAT(ISNULL(TEERD.S_First_Name, ''),' ',ISNULL(TEERD.S_Middle_Name, ''),' ',ISNULL(TEERD.S_Last_Name, '')) FullName
	,TEERd.S_Mobile_No MobileNumber
	,TEERD.I_Course_Applied_For CourseAppliedForID
	,[S_Class_Name] AS CourseAppliedFor
	,TEERD.R_I_AdmStgTypeID AdmissionStage
	,TEERD.App_Payment_Status ApplicationPayment
	,TEERF.I_Followup_Status FollowUpStatus
	,TEERF.S_Followup_Remarks FollowUpRemark
	,CONCAT(ISNULL(TEERGM.S_First_Name, ''),' ',ISNULL(TEERGM.S_Middile_Name, ''),' ',ISNULL(TEERGM.S_Last_Name, '')) AS GuardianName
	,TEERGM.I_Relation_ID AS RelationID
	,TRM.S_Relation_Type AS RelationName
	,TEERD.I_Is_Active AS IsActive
	,TEERD.I_School_Group_ID AS SchoolGroupID

	FROM [T_ERP_Enquiry_Regn_Detail] AS TEERD
	inner join T_ERP_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID
	left join T_Class AS TC ON TEERD.I_Course_Applied_For = TC.I_Class_ID
	left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID AND TEERGM.I_Relation_ID = 1
	left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID
	left join (
    SELECT TOP 1 R_I_Enquiry_Regn_ID, I_Followup_Status, S_Followup_Remarks
    FROM T_ERP_Enquiry_Regn_Followup
    ORDER BY Dt_Followup_Date DESC
    --LIMIT 1 -- or TOP 1 for SQL Server
	) AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID

	WHERE
		(TEERD.S_Enquiry_No LIKE '%' + ISNULL(@Enquiry_No, '') + '%' OR @Enquiry_No IS NULL)
		AND (
			CONCAT(ISNULL(TEERD.S_First_Name, ''), ' ', ISNULL(TEERD.S_Middle_Name, ''), ' ', ISNULL(TEERD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%' OR @Full_Name IS NULL
		)
        AND (
			CONCAT(ISNULL(TEERGM.S_First_Name, ''),' ',ISNULL(TEERGM.S_Middile_Name, ''),' ',ISNULL(TEERGM.S_Last_Name, '')) LIKE '%' + @GuardianName + '%' OR @GuardianName IS NULL
		)
		AND (
			TEERD.S_Mobile_No LIKE '%' + @Mobile + '%' OR @Mobile IS NULL
		)
		AND (
			TEERD.I_School_Group_ID LIKE '%' + @SchoolGroupID + '%' OR @SchoolGroupID IS NULL
		)
END
