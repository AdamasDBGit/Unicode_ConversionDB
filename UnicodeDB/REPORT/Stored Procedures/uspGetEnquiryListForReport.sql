/*****************************************************************************************************************
Created by: Abhisek Bhattacharya
Date: 11/06/2007
Description:Fetches the Enquiry List for the selected center(s) and Course
Parameters: @sHierarchyList, @iBrandID, @iCourseID
******************************************************************************************************************/
CREATE PROCEDURE [REPORT].[uspGetEnquiryListForReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@iCourseID INT = NULL
)
AS

BEGIN TRY 

	SELECT ERD.S_Enquiry_No,
		   ERD.I_Enquiry_Regn_ID
	FROM dbo.T_Enquiry_Regn_Detail ERD
    INNER JOIN dbo.T_Enquiry_Course EC
	ON ERD.I_Enquiry_Regn_ID = EC.I_Enquiry_Regn_ID
	WHERE ERD.I_Centre_Id IN 
	(
		SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID)
	)
	AND EC.I_Course_ID = ISNULL(@iCourseID, EC.I_Course_ID)
	AND ERD.I_Enquiry_Status_Code = 1

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
