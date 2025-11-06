CREATE PROC [dbo].[ValCenterNameExists]
(
	@sCenterName VARCHAR(100),
	@sCNC VARCHAR(100),
	@iCentreID INT = NULL
)
 
AS
BEGIN

if @iCentreID IS NULL
	BEGIN
		SELECT DISTINCT 'True' FROM T_Centre_Master
		WHERE (S_Center_Name = @sCenterName OR S_Center_Code = @sCNC)
		AND I_Status <>0
	END
	ELSE
	BEGIN
	SELECT DISTINCT 'True' FROM T_Centre_Master
		WHERE (S_Center_Name = @sCenterName or S_Center_Code = @sCNC)
		AND I_Centre_Id NOT IN (@iCentreID) and I_Status <> 0
	END
END
