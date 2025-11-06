CREATE function [dbo].[ufnCheckIfQBankExists]
(
	@iQBankID INT
)
RETURNS INT

AS
BEGIN

declare @sQBankID varchar(max)
DECLARE @iResult INT
SET @iResult = 0

	DECLARE _CURSOR CURSOR FOR
	SELECT DISTINCT S_Question_Bank_ID FROM EXAMINATION.T_Test_Design

		OPEN _CURSOR
		FETCH NEXT FROM _CURSOR INTO @sQBankID

		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF EXISTS(SELECT * FROM dbo.fnString2Rows(@sQBankID,',') where val = @iQBankID )
		BEGIN			
			SET @iResult = 1
			BREAK;
		END

			FETCH NEXT FROM _CURSOR INTO @sQBankID
		END	
	
	CLOSE _CURSOR
	DEALLOCATE _CURSOR

RETURN @iResult

END