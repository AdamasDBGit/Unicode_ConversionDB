/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:14/08/2007
-- Description: Get Course Family  List From a Center
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetCourseFamilyListForCenter]
(
	@iCenterID INT
)
AS
BEGIN
	SELECT DISTINCT
		ISNULL(CFM.I_CourseFamily_ID, 0) AS I_CourseFamily_ID,
		ISNULL(CFM.I_Brand_ID, 0) AS I_Brand_ID,
		ISNULL(CCD.I_Centre_Id,0) AS I_Center_ID,
  		ISNULL(CFM.S_CourseFamily_Name, '') AS S_CourseFamily_Name
	FROM
		  dbo.T_CourseFamily_Master CFM
		  LEFT OUTER JOIN dbo.T_Course_Master CM
		  ON CFM.I_CourseFamily_ID = CM.I_CourseFamily_ID
		  LEFT OUTER JOIN dbo.T_Course_Center_Detail CCD
		  ON CM.I_Course_ID = CCD.I_Course_ID
	WHERE
        CCD.I_Centre_Id = COALESCE(@iCenterID, CCD.I_Centre_Id)
END
