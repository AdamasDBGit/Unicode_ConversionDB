-- =============================================
-- Author:		Debarshi Basu
-- Create date: 12/03/2007
-- Description:	Gets the Module List
-- =============================================
CREATE PROCEDURE [dbo].[uspGetModuleListForTerm] -- [dbo].[uspGetModuleListForTerm] 31,null
(
	@iTermID INT,
	@dtCurrentDate datetime = null
)

AS
BEGIN
	
	SET NOCOUNT OFF
	Set @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())
	SELECT	[T_Module_Master].I_Module_ID,
			[T_Module_Master].S_Module_Code,
			[T_Module_Master].S_Module_Name,
			[T_Module_Term_Map].I_Sequence,
			[T_Module_Term_Map].C_Examinable		
	FROM dbo.T_Module_Master
	INNER JOIN dbo.[T_Module_Term_Map] WITH(NOLOCK)
	ON [dbo].[T_Module_Master].[I_Module_ID] = [dbo].[T_Module_Term_Map].[I_Module_ID] 
	WHERE [T_Module_Master].I_Status <> 0 AND [T_Module_Term_Map].[I_Term_ID] = @iTermID
	AND [T_Module_Term_Map].I_Status = 1
	AND @dtCurrentDate >= ISNULL([T_Module_Term_Map].Dt_Valid_From,@dtCurrentDate)
	AND @dtCurrentDate <= ISNULL([T_Module_Term_Map].Dt_Valid_To,@dtCurrentDate)
	ORDER BY [T_Module_Term_Map].I_Sequence
	
END
