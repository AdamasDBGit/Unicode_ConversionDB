-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_GetEventRelevantInformation] 107, 1, 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetEventRelevantInformation]
	-- Add the parameters for the stored procedure here
	(
		@iBrandid INT = null,
		@SchoolGroupID INT = null,
		@ClassID INT = null
		--@flag INT = null
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TE.I_Event_Category_ID AS EventCategoryID,
	TECA.S_Event_Category AS EventCategoryName,
	COUNT(*) AS EventCount
	
	FROM T_Event AS TE
	INNER JOIN T_Event_Class AS TEC ON TE.I_Event_ID = TEC.I_Event_ID
	INNER JOIN T_Event_Category AS TECA ON TE.I_Event_Category_ID = TECA.I_Event_Category_ID

	WHERE (TE.I_Brand_ID = @iBrandid OR @iBrandid IS NULL)
    AND (TEC.I_School_Group_ID = @SchoolGroupID OR @SchoolGroupID IS NULL OR @SchoolGroupID = 0)
    AND (TEC.I_Class_ID = @ClassID OR @ClassID IS NULL OR @ClassID = 0)

	GROUP BY TE.I_Event_Category_ID, TECA.S_Event_Category

END
