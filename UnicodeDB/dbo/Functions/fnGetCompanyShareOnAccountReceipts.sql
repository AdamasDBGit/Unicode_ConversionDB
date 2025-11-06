-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/07/07
-- Description:	This function gets the value of the 
--	Company Share for a receiptType,center,country. 
-- Return: Company Share(numeric)
-- =============================================
CREATE FUNCTION [dbo].[fnGetCompanyShareOnAccountReceipts]
(
	@dtReceiptDate Datetime,
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iReceiptType INT = NULL,
	@iBrandID INT = NULL
)
RETURNS  NUMERIC(8,4)

AS 
BEGIN

	DECLARE @nCompanyShare NUMERIC(8,4)

	IF EXISTS (SELECT *
					FROM dbo.T_Fee_Sharing_OnAccount
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Center_ID = @iCenterID
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1)
	BEGIN
		SELECT  @nCompanyShare = N_Company_Share
				FROM dbo.T_Fee_Sharing_OnAccount
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Center_ID = @iCenterID
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1
	END 
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_OnAccount 
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Center_ID IS NULL
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1)
		BEGIN
			SELECT @nCompanyShare = N_Company_Share
				FROM dbo.T_Fee_Sharing_OnAccount
				WHERE I_Receipt_Type = @iReceiptType
				AND I_Center_ID IS NULL
				AND I_Brand_ID = @iBrandID
				AND I_Country_ID = @iCountryID
				AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1
		END
		ELSE
		BEGIN
			IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_OnAccount
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1 )
			BEGIN
				SELECT @nCompanyShare = N_Company_Share
					FROM dbo.T_Fee_Sharing_OnAccount 
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Brand_ID = @iBrandID
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1
			END
			ELSE			
			BEGIN
			IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_OnAccount
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL
					AND I_Brand_ID IS NULL
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1 )
			BEGIN
				SELECT @nCompanyShare = N_Company_Share
					FROM dbo.T_Fee_Sharing_OnAccount 
					WHERE I_Receipt_Type = @iReceiptType
					AND I_Brand_ID IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1
			END
			ELSE			
			BEGIN					
				SELECT @nCompanyShare = N_Company_Share
					FROM dbo.T_Fee_Sharing_OnAccount 
					WHERE I_Receipt_Type IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL	
					AND I_Brand_ID IS NULL
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1			
			END 			
		END 			
		END 
	END
	IF @nCompanyShare IS NULL
	BEGIN 
		SET @nCompanyShare = 0
	END

	DECLARE @iIsOwnCenter INT
	SELECT @iIsOwnCenter = ISNULL(I_Is_OwnCenter ,0) 
		FROM dbo.T_Centre_Master where I_Centre_Id = @iCenterID

	IF @iIsOwnCenter = 1
	BEGIN
		SET @nCompanyShare = 100
	END

	RETURN @nCompanyShare

END