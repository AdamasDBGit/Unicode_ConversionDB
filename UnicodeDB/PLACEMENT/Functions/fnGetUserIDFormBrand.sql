-- =============================================
-- Author:		Shankha Roy
-- Create date: '12/02/2008'
-- Description:	This Function return a table 
-- constains user Id from giving brand 
-- Return: Table
-- =============================================
CREATE FUNCTION [PLACEMENT].[fnGetUserIDFormBrand]
(
	@iBrandId INT
)
RETURNS  @TempUser TABLE
	( 
		I_User_ID int
	)

AS 
BEGIN
	DECLARE @sSearchCriteria varchar(20)
			IF (@iBrandId != 0 AND @iBrandId IS NOT NULL) 
			BEGIN
				INSERT INTO @TempUser 
				SELECT UM.I_User_ID from dbo.T_User_Master UM
				INNER JOIN dbo.T_User_Hierarchy_Details UHD
				ON UM.I_User_ID = UHD.I_User_ID
				INNER JOIN dbo.T_Hierarchy_Brand_Details HBD
				ON UHD.I_Hierarchy_Master_ID = HBD.I_Hierarchy_Master_ID
				WHERE UM.S_User_Type='EM'
				AND HBD.I_Brand_ID =@iBrandId
			END
		ELSE
			BEGIN
				INSERT INTO @TempUser  
				SELECT UM.I_User_ID from dbo.T_User_Master UM			 
			END
	
	
 RETURN ;
END