CREATE PROCEDURE [dbo].[uspGetEducationQualificationPostGraduation]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TEQ.I_Education_Qualification_ID,TEQ.S_Education_Qualification_Description FROM dbo.T_Education_Qualification TEQ WHERE I_Brand_ID=@iBrandID
END
