-- =============================================
-- Author:		Soumya Sikder
-- Create date: 07/01/2008
-- Description:	It gets the Count of Courses Assigned to Center
-- exec uspGetEnquiryNumber
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCourseAssignedToCenter] 
(
	@iCenterID INT,
	@dtCurrentDate DATETIME
)
AS
BEGIN
	SET NOCOUNT OFF;

	SELECT COUNT(CCD.I_Course_ID)
	FROM dbo.T_Course_Center_Detail CCD
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF
	ON CCD.I_Course_Center_ID = CCDF.I_Course_Center_ID
	WHERE CCD.I_Centre_Id = @iCenterID
	AND CCD.I_Status <> 0
--	AND CCD.Dt_Valid_From <= ISNULL(@dtCurrentDate, CCD.Dt_Valid_From)
--	AND CCD.Dt_Valid_To >= ISNULL(@dtCurrentDate, CCD.Dt_Valid_To)
	AND CCDF.I_Status <> 0
--	AND CCDF.Dt_Valid_From <= ISNULL(@dtCurrentDate, CCDF.Dt_Valid_From)
--	AND CCDF.Dt_Valid_To >= ISNULL(@dtCurrentDate, CCDF.Dt_Valid_To)
	GROUP BY (CCD.I_Centre_Id)

END
