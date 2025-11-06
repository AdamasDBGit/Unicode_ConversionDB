CREATE PROCEDURE [SMManagement].[uspGetCenterList]
(
@BrandID INT,
@HierarchyListID VARCHAR(MAX)
)

AS

BEGIN

SELECT TCHND.I_Center_ID AS centerID,TCHND.I_Hierarchy_Detail_ID AS hierarchyDetailID,TCHND.I_Brand_ID AS brandID,TCHND.S_Center_Name AS centerName FROM dbo.T_Center_Hierarchy_Name_Details AS TCHND 
WHERE TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyListID,@BrandID) AS FGCFR)


END
