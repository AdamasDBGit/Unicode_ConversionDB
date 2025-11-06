CREATE PROCEDURE [dbo].[uspGetAimList]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TA.I_Aim_ID,TA.S_Aim_Description FROM dbo.T_Aim TA WHERE I_Brand_ID=@iBrandID AND TA.I_Status=1
END
