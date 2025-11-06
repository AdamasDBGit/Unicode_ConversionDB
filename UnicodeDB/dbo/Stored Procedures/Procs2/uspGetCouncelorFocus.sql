CREATE PROCEDURE [dbo].[uspGetCouncelorFocus]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TCF.I_Counseling_Focus_ID,TCF.S_Counseling_Focus_Description FROM dbo.T_Counseling_Focus TCF WHERE TCF.I_Brand_ID=@iBrandID AND TCF.I_Status=1
END
