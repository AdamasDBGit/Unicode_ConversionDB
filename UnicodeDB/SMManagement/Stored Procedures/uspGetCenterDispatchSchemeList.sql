CREATE PROCEDURE [SMManagement].[uspGetCenterDispatchSchemeList]
(
@iCenterID INT,
@iCourseID INT
)

AS


BEGIN


SELECT DISTINCT TCDSM.CentreDispatchSchemeID,TDSM.DispatchSchemeName FROM SMManagement.T_Centre_Dispatch_Scheme_Map AS TCDSM
INNER JOIN SMManagement.T_Dispatch_Scheme_Master AS TDSM ON TDSM.DispatchSchemeID=TCDSM.SchemeID
WHERE
TCDSM.CourseID=@iCourseID AND TCDSM.CentreID=@iCenterID AND TDSM.StatusID=1 AND TCDSM.StatusID=1


END
