-- =============================================
-- Author:		Soumyopriyo Saha
-- Create date: 24/09/2010
-- Description:	Get Faculty List For Center
-- =============================================

CREATE PROCEDURE [dbo].[uspGetFacultyListForCenter]
(	
	@iCenterID int,
	@iRoleID int
)				
AS 
BEGIN TRY 
SELECT A.I_Employee_ID,A.S_First_Name+' '+ISnull(A.S_Middle_Name,'')+' '+A.S_Last_Name AS FacultyName,A.B_IsRoamingFaculty,D.I_Brand_ID,a.I_Centre_Id
FROM dbo.T_Employee_Dtls A
INNER JOIN dbo.T_User_Master B
ON A.I_Employee_ID = B.I_Reference_ID
INNER JOIN dbo.T_User_Role_Details C
--INNER JOIN dbo.T_User_Hierarchy_Details C
ON B.I_User_ID = C.I_User_ID
--INNER JOIN dbo.T_Role_Master D
--ON C.I_Hierarchy_Detail_ID = D.I_Hierarchy_Detail_ID
INNER JOIN dbo.[T_Center_Hierarchy_Name_Details] D
ON A.I_Centre_Id = D.I_Center_ID

WHERE C.I_Role_ID = @iRoleID
--AND A.I_Centre_Id = @iCenterID

END TRY
BEGIN CATCH
--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
