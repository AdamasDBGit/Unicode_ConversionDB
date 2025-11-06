-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 30/12/2006
-- Description:	Modifies the Brand Country Mapping List
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyBrandCountryMapping] 
(
	@iBrandID int,
	@iCountryID int,
	@vModifiedBy varchar(20),
	@dModifiedOn datetime,
	@iFlag int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    
	IF @iFlag = 1
	BEGIN
		IF NOT EXISTS (SELECT I_BCD_Brand_Country_Detail_ID FROM dbo.T_Brand_Country_Details WHERE I_BCD_Brand_ID = @iBrandID AND I_BCD_Country_ID = @iCountryID)
		BEGIN
			INSERT INTO dbo.T_Brand_Country_Details(I_BCD_Country_ID, I_BCD_Brand_ID, S_BCD_Crtd_By, Dt_BCD_Crtd_On)
			VALUES(@iCountryID, @iBrandID, @vModifiedBy, @dModifiedOn)   
		END 
	END
END
