CREATE PROCEDURE [dbo].[uspGetHolidayList]
(
	@iCenterID INT = NULL,
	@dtHolidayDate  DATETIME = NULL
)
AS
BEGIN
	IF @iCenterID IS NOT NULL
		BEGIN
			SELECT thm.[I_Holiday_ID],thm.I_Brand_ID,thm.[I_Center_ID],thm.[Dt_Holiday_Date], thm.[S_Holiday_Description]
			FROM [dbo].[T_Holiday_Master] AS thm WITH(NOLOCK)
			WHERE thm.[I_Center_ID] = ISNULL(@iCenterID,thm.[I_Center_ID])
			AND thm.[Dt_Holiday_Date] = ISNULL(@dtHolidayDate,thm.[Dt_Holiday_Date])
		END
	ELSE
		BEGIN
			SELECT thm.[I_Holiday_ID],thm.I_Brand_ID,thm.[I_Center_ID],thm.[Dt_Holiday_Date], thm.[S_Holiday_Description]
			FROM [dbo].[T_Holiday_Master] AS thm WITH(NOLOCK)
			WHERE thm.[Dt_Holiday_Date] = ISNULL(@dtHolidayDate,thm.[Dt_Holiday_Date])
		END
END
