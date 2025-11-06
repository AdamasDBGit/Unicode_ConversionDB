CREATE PROCEDURE [dbo].[uspGetIndustryType]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TED.I_Employment_Details_ID,TED.S_Employment_Details_Description FROM dbo.T_Employment_Details TED WHERE I_Brand_ID=@iBrandID
END
