CREATE PROCEDURE [dbo].[uspGetITSkills]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TIS.I_IT_Skills_ID,TIS.S_IT_Skills_Description FROM dbo.T_IT_Skills TIS WHERE I_Brand_ID=@iBrandID
END
