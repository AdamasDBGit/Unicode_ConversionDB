-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/07/07
-- Description:	This function gets the value of the 
--	Company Share for a fee component,course,center,country. 
-- Return: Company Share(numeric)
-- =============================================
CREATE FUNCTION [dbo].[fnGetCompanyShare]
(
	@dtReceiptDate Datetime,
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iCourseID INT = NULL,
	@iFeeComponentID INT = NULL,
	@iBrandID INT = NULL
)
RETURNS  NUMERIC(8,4)

AS 
BEGIN

	DECLARE @nCompanyShare NUMERIC(8,4)

	IF EXISTS (SELECT *
					FROM dbo.T_Fee_Sharing_Master
					WHERE I_Fee_Component_ID = @iFeeComponentID
					AND I_Course_ID = @iCourseID
					AND I_Center_ID = @iCenterID
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1)
	BEGIN
		SELECT  @nCompanyShare = N_Company_Share
				FROM dbo.T_Fee_Sharing_Master
				WHERE I_Fee_Component_ID = @iFeeComponentID
				AND I_Course_ID = @iCourseID
				AND I_Center_ID = @iCenterID
				AND I_Country_ID = @iCountryID
				AND I_Brand_ID = @iBrandID
				AND Dt_Period_Start <= @dtReceiptDate
				AND Dt_Period_End >= @dtReceiptDate
				AND I_Status = 1
	END 
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_Master 
					WHERE I_Fee_Component_ID = @iFeeComponentID
					AND I_Course_ID = @iCourseID
					AND I_Center_ID IS NULL
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1)
		BEGIN
			SELECT @nCompanyShare = N_Company_Share
				FROM dbo.T_Fee_Sharing_Master 
				WHERE I_Fee_Component_ID = @iFeeComponentID
				AND I_Course_ID = @iCourseID
				AND I_Center_ID IS NULL
				AND I_Country_ID = @iCountryID
				AND I_Brand_ID = @iBrandID
				AND Dt_Period_Start <= @dtReceiptDate
				AND Dt_Period_End >= @dtReceiptDate
				AND I_Status = 1
		END
		ELSE
		BEGIN
			IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_Master 
					WHERE I_Fee_Component_ID = @iFeeComponentID
					AND I_Course_ID IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1 )
			BEGIN
				SELECT @nCompanyShare = N_Company_Share
					FROM dbo.T_Fee_Sharing_Master 
					WHERE I_Fee_Component_ID = @iFeeComponentID
					AND I_Course_ID IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1
			END
			ELSE
			BEGIN
				IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_Master 
					WHERE I_Fee_Component_ID IS NULL
					AND I_Course_ID IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID = @iCountryID
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1 )
				BEGIN
					SELECT @nCompanyShare = N_Company_Share
						FROM dbo.T_Fee_Sharing_Master 
						WHERE I_Fee_Component_ID IS NULL
						AND I_Course_ID IS NULL
						AND I_Center_ID IS NULL
						AND I_Country_ID = @iCountryID
						AND I_Brand_ID = @iBrandID
						AND Dt_Period_Start <= @dtReceiptDate
						AND Dt_Period_End >= @dtReceiptDate
						AND I_Status = 1
				END
				ELSE
				BEGIN
				IF EXISTS (SELECT * FROM dbo.T_Fee_Sharing_Master 
					WHERE I_Fee_Component_ID IS NULL
					AND I_Course_ID IS NULL
					AND I_Center_ID IS NULL
					AND I_Country_ID IS NULL
					AND I_Brand_ID = @iBrandID
					AND Dt_Period_Start <= @dtReceiptDate
					AND Dt_Period_End >= @dtReceiptDate
					AND I_Status = 1 )
				BEGIN
					SELECT @nCompanyShare = N_Company_Share
						FROM dbo.T_Fee_Sharing_Master 
						WHERE I_Fee_Component_ID IS NULL
						AND I_Course_ID IS NULL
						AND I_Center_ID IS NULL
						AND I_Country_ID IS NULL
						AND I_Brand_ID = @iBrandID
						AND Dt_Period_Start <= @dtReceiptDate
						AND Dt_Period_End >= @dtReceiptDate
						AND I_Status = 1
				END
				ELSE
				BEGIN					
					SELECT @nCompanyShare = N_Company_Share
						FROM dbo.T_Fee_Sharing_Master 
						WHERE I_Fee_Component_ID IS NULL
						AND I_Course_ID IS NULL
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
	END

	DECLARE @iIsOwnCenter INT
	SELECT @iIsOwnCenter = ISNULL(I_Is_OwnCenter ,0) 
		FROM dbo.T_Centre_Master where I_Centre_Id = @iCenterID

	IF @iIsOwnCenter = 1
	BEGIN
		SET @nCompanyShare = 100
	END

	IF @nCompanyShare IS NULL
	BEGIN 
		SET @nCompanyShare = 0
	END
	
	RETURN @nCompanyShare

END