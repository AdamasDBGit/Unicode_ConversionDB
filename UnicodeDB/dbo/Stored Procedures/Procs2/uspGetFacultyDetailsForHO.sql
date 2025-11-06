-- =============================================
-- Author:		Soumyopriyo Saha
-- Create date: 14/12/2010
-- Description:	Get Faculty List For HO
-- =============================================

CREATE PROCEDURE [dbo].[uspGetFacultyDetailsForHO]
(	
	@iUserid int
)				
AS 
BEGIN TRY 
SELECT A.I_User_ID ,
        A.S_First_Name +' '+ A.S_Middle_Name +' '+ A.S_Last_Name AS Faculty_Name
        FROM dbo.T_User_Master A
		WHERE I_User_ID = @iUserid
END TRY
BEGIN CATCH
--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
