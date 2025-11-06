-- =============================================
-- Author:		Soumyopriyo Saha
-- Create date: 13/12/2010
-- Description:	Get Faculty List For HO
-- =============================================

CREATE PROCEDURE [dbo].[uspGetFacultyAtHO]
(	
	@iHierarchyDetailId int,
	@iRoleID int
)				
AS 
BEGIN TRY 
SELECT A.I_User_ID ,
        A.S_First_Name +' '+ A.S_Middle_Name +' '+ A.S_Last_Name AS FacultyName
        FROM dbo.T_User_Master A
INNER JOIN dbo.T_User_Hierarchy_Details B
ON A.I_User_ID = B.I_User_ID
WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailId
AND A.I_User_ID IN 
(SELECT I_User_ID FROM dbo.T_User_Role_Details WHERE I_Role_ID = @iRoleID)
AND I_Reference_ID = 0
AND A.I_Status = 1
END TRY
BEGIN CATCH
--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
