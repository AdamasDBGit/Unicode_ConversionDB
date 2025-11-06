/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 19/04/2007
Description: Search for students
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetStudentListForMigration]
(
	@iHierarchyDetailID int,
	@sStudentID varchar(500),
	@sFname varchar(50)
)
AS

BEGIN
	
	SELECT * FROM T_Student_Detail SD
	INNER JOIN T_Student_Center_Detail SCD
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	WHERE SCD.I_Centre_Id=(SELECT I_Center_Hierarchy_Detail_ID FROM T_Center_Hierarchy_Details D WHERE I_Hierarchy_Detail_ID = 11 AND I_Status<>0)
	AND SD.S_Student_ID LIKE ('%'+ISNULL(null,S_Student_ID)+'%')
	--AND SD.S_First_Name LIKE ('%'+ISNULL(null,S_First_Name)+'%')
END
