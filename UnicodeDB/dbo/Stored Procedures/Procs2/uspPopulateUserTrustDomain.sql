CREATE PROCEDURE [dbo].[uspPopulateUserTrustDomain] 
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT	A.I_Hierarchy_Detail_ID, 
			A.I_Hierarchy_Master_ID, 
			A.S_Hierarchy_Name
	FROM dbo.T_Hierarchy_Details A, dbo.T_Hierarchy_Master B
	WHERE A.I_Status = 1
	AND 
A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	AND B.S_Hierarchy_Type = 'RH'
	    
END
