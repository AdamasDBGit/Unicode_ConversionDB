-- =============================================
-- Author:		Rabin Mukherjee
-- Create date: 17/01/2007
-- Description:	Selects All the Grading Pattern from master and details table 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetGradingPattern] 

AS
BEGIN

	SELECT GPM.*,GPD.I_Grading_Pattern_Detail_ID,
		GPD.S_Grade_Type,
		GPD.I_MinMarks,
		GPD.I_MaxMarks
	FROM 
		T_Grading_Pattern_Master AS GPM,T_Grading_Pattern_Detail GPD
	WHERE 
		GPM.I_Grading_Pattern_ID=GPD.I_Grading_Pattern_ID
		AND GPM.I_Status<>0
END
