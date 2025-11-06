-- =============================================
-- Author:		Aritra Saha
-- Create date: 13/06/2007
-- Description:	Gets the list of FollowUps within a Date range
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEnquiryFollowUpList] 
(
	@dStartDate datetime = null,
	@dEndDate datetime = null
)

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT ED.S_First_Name as CouncellorFirstName,
		   ED.S_Middle_Name as CouncellorMiddleName,
		   ED.S_Last_Name as CouncellorLastName, 
		   ERF.Dt_Next_Followup_Date,
		   CHD.I_Hierarchy_Detail_ID,
		   CHD.I_Hierarchy_Master_ID,
		   ERD.*
	FROM dbo.T_Enquiry_Regn_Detail ERD
	INNER JOIN dbo.T_Enquiry_Regn_Followup ERF
	ON ERD.I_Enquiry_Regn_ID = ERF.I_Enquiry_Regn_ID
	INNER JOIN dbo.T_Employee_Dtls ED
	ON ED.I_Employee_ID = ERF.I_Employee_ID
	INNER JOIN dbo.T_Center_Hierarchy_Details CHD
	ON CHD.I_Center_Id = ERD.I_Centre_Id
	WHERE 	
	DATEDIFF(dd, ISNULL(@dStartDate,ERF.Dt_Next_Followup_Date), ERF.Dt_Next_Followup_Date) >= 0
	AND DATEDIFF(dd, ISNULL(@dEndDate,ERF.Dt_Next_Followup_Date), ERF.Dt_Next_Followup_Date) <= 0
	AND ERD.I_Enquiry_Status_Code <>  3-- Status Code = 3, closed enquiry
	  
END
