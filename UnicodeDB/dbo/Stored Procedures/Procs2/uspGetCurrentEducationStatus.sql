CREATE PROCEDURE [dbo].[uspGetCurrentEducationStatus]
(
@iBrandID INT
)

AS
BEGIN
	SELECT TECS.I_Education_CurrentStatus_ID,TECS.S_Education_CurrentStatus_Description FROM dbo.T_Education_CurrentStatus TECS
	WHERE
	I_Brand_ID=@iBrandID AND TECS.I_Status=1
END
