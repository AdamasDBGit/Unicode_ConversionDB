-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Service Tax master table
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyServiceTaxMaster]
	@iCountryServiceTaxID int,
	@iCountryID int,
	@dServiceTax varchar(50),
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int			
AS
BEGIN
	SET NOCOUNT OFF;

	if(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Service_Tax_Master(
												I_Country_Id,
												N_ServiceTax_Percent,
												I_Status, 
												S_Crtd_By,
												Dt_Crtd_On
										   )
			VALUES(
					@iCountryID,
					@dServiceTax, 
					1, 
					@sCreatedBy, 
					@dtCreatedOn
				)
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Service_Tax_Master
				SET  I_Country_Id = @iCountryID,
				N_ServiceTax_Percent = @dServiceTax,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Country_ServiceTax_Id = @iCountryServiceTaxID	
		END

	ELSE IF(@iFlag = 3)
		BEGIN
				UPDATE dbo.T_Service_Tax_Master
				SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Country_ServiceTax_Id = @iCountryServiceTaxID
		END
END
