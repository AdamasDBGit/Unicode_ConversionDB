CREATE PROCEDURE [dbo].[uspGetEducationStreamGraduation]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TES.I_Education_Stream_ID,TES.S_Education_Stream_Description FROM dbo.T_Education_Stream TES WHERE I_Brand_ID=@iBrandID
END
