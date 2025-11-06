-- =============================================
-- Author:		<Rajesh>
-- Create date: <29-12-2006>
-- Description:	<To modify T_Region_Master>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyRegionMaster]
	-- Add the parameters for the stored procedure here
	@iRegionID int,
	@vRegionCode varchar(20),
	@vRegionName varchar(100),
	@vRegionBy varchar(20),
	@dRegionOn datetime,
	@iFlag int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Region_Master
				  (
						S_RGM_Rgn_Code,
						S_RGM_Rgn_Name, 
						C_RGM_Status, 
						S_RGM_Upd_By, 
						Dt_RGM_Crtd_On
				   )
			VALUES(
					@vRegionCode, 
					@vRegionName, 
					'A', 
					@vRegionBy, 
					@dRegionOn
				)
		END

		ELSE IF(@iFlag=2)
			BEGIN
					UPDATE dbo.T_Region_Master
					SET S_RGM_Rgn_Code = @vRegionCode,
					S_RGM_Rgn_Name = @vRegionName,
					S_RGM_Upd_By = @vRegionBy,
					Dt_RGM_Crtd_On = @dRegionOn
					where I_RGM_Rgn_ID = @iRegionID	
			END

		ELSE IF(@iFlag = 3)
			BEGIN
					UPDATE dbo.T_Region_Master
					SET C_RGM_Status = 'D',
					S_RGM_Upd_By = @vRegionBy,
					Dt_RGM_Upd_On = @dRegionOn
					where I_RGM_Rgn_ID = @iRegionID	
			END
	END
