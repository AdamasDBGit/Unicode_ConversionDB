CREATE PROCEDURE [REPORT].[uspGetComboFilled]
(
	@CType INT=0
)	
AS
	BEGIN
		DECLARE @tmpMaster TABLE (ID INT, NAME VARCHAR(250))
		
		IF @CType=1
			BEGIN
				INSERT INTO @tmpMaster
				SELECT tcm.I_Country_ID, tcm.S_Country_Name FROM dbo.T_Country_Master tcm
			END
		ELSE IF @CType=2
			BEGIN
				INSERT INTO @tmpMaster
				SELECT tsm.I_State_ID, tsm.S_State_Name FROM dbo.T_State_Master tsm
			END
		ELSE
			BEGIN
				INSERT INTO @tmpMaster
				SELECT tccm.I_City_ID, tccm.S_City_Name FROM dbo.T_City_Master tccm
			END
		
		SELECT * FROM @tmpMaster ORDER BY name
	END
