CREATE FUNCTION [PSCERTIFICATE].[fnGetTotalCourseDuration]
(
	@iCourseId INT
)
RETURNS NUMERIC(18,2)
AS
BEGIN
	DECLARE @Duration NUMERIC(18,2)

	SELECT @Duration = ISNULL(SUM([TSM].[N_Session_Duration]),0)/60 
	FROM [dbo].[T_Term_Course_Map] AS TTCM	
	INNER JOIN [dbo].[T_Module_Term_Map] AS TMTM
	ON [TTCM].[I_Term_ID] = [TMTM].[I_Term_ID]
	AND [TMTM].[I_Status] = 1
	INNER JOIN [dbo].[T_Session_Module_Map] AS TSMM
	ON [TMTM].[I_Module_ID] = [TSMM].[I_Module_ID]
	AND [TSMM].[I_Status] = 1
	INNER JOIN [dbo].[T_Session_Master] AS TSM
	ON [tsmm].[I_Session_ID] = [TSM].[I_Session_ID]
	AND [TSM].[I_Status] = 1
	WHERE [TTCM].[I_Course_ID] = @iCourseId
	AND [TTCM].[I_Status] = 1
	
	RETURN @Duration
END