/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the KRAs for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetKRAAssessorDetails]
(	
	@iBrandID INT,
	@iRoleID INT
)	
AS
BEGIN
	SELECT 
		TRM.I_Role_ID,
		TRA.I_Assessor_Role_ID,
		TRM.S_Role_Code,
		TRM.S_Role_Desc,
		TRM.S_Role_Type,
		TRM.I_Status	
	FROM
		EOS.T_Role_Assessor TRA WITH(NOLOCK)
		INNER JOIN dbo.T_Role_Master TRM WITH(NOLOCK)
			ON TRA.I_Assessor_Role_ID = TRM.I_Role_ID
	WHERE
			--TRA.I_Brand_ID = @iBrandID AND
		TRA.I_Role_ID = @iRoleID
END
