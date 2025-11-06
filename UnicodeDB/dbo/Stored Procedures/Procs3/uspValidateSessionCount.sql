CREATE PROCEDURE [dbo].[uspValidateSessionCount]
(
	@I_MODULE_ID INT
)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT [I_Total_Session_Count] AS [I_Total_Session_Count_Term_Master] FROM [T_Term_Master] WITH(NOLOCK)  WHERE [I_Term_ID] IN
	(
		SELECT [I_Term_ID] FROM [T_Module_Term_Map] WITH(NOLOCK) WHERE [I_Module_ID]=@I_MODULE_ID AND [I_Status]=1
	)

	SELECT COUNT(*) [I_Total_Session_Count_From_Mapping] FROM [T_Session_Module_Map] WITH(NOLOCK) WHERE [I_Module_ID] IN
	(
		SELECT [I_Module_ID] FROM [T_Module_Term_Map] WITH(NOLOCK) WHERE [I_Term_ID] IN
		(
			SELECT [I_Term_ID] FROM [T_Module_Term_Map] WITH(NOLOCK) WHERE [I_Module_ID]=@I_MODULE_ID AND [I_Status]=1
		) AND [I_Status]=1
	) AND [I_Status]=1

	SELECT COUNT(*) [I_Total_Session_For_This_Module] FROM [T_Session_Module_Map] WITH(NOLOCK) WHERE [I_Module_ID] IN
	(
		SELECT [I_Module_ID] FROM [T_Module_Term_Map] WITH(NOLOCK) WHERE [I_Module_ID]=@I_MODULE_ID AND [I_Status]=1
	) AND [I_Status]=1
END
