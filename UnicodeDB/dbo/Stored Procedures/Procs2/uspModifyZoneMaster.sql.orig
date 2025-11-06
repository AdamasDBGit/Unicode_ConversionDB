-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyZoneMaster] 
	-- Add the parameters for the stored procedure here
	@iZoneID int,
	@vZoneCode varchar(20),
	@vZoneName varchar(100),
	@vZoneBy varchar(20),
	@dZoneOn datetime,
	@iFlag int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Zone_Master
				  (
						S_ZNM_Zone_Code,
						S_ZNM_Zone_Name, 
						C_ZNM_Status, 
						S_ZNM_Upd_By, 
						Dt_ZNM_Crtd_On
				   )
			VALUES(
					@vZoneCode, 
					@vZoneName, 
					'A', 
					@vZoneBy, 
					@dZoneOn
				)
		END

		ELSE IF(@iFlag=2)
			BEGIN
					UPDATE dbo.T_Zone_Master
					SET S_ZNM_Zone_Code = @vZoneCode,
					S_ZNM_Zone_Name = @vZoneName,
					S_ZNM_Upd_By = @vZoneBy,
					Dt_ZNM_Crtd_On = @dZoneOn
					where I_ZNM_Zone_Id = @iZoneID	
			END

		ELSE IF(@iFlag = 3)
			BEGIN
					UPDATE dbo.T_Zone_Master
					SET C_ZNM_Status = 'D',
					S_ZNM_Upd_By = @vZoneBy,
					Dt_ZNM_Upd_On = @dZoneOn
					where I_ZNM_Zone_Id = @iZoneID
			END
END
