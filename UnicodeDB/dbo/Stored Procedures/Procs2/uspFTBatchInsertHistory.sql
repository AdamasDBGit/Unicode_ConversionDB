CREATE PROCEDURE [dbo].[uspFTBatchInsertHistory]
	@iFTSAPID INT,
	@iFTID INT,
	@dtNow DATETIME,
	@iCenterID INT,
	@iCenterFTID INT

AS
BEGIN

	INSERT INTO dbo.T_FT_History
	(I_FT_SAP_ID,I_FT_ID,Dt_FT_Date,I_Center_ID,I_Center_FT_ID)
	VALUES
	(@iFTSAPID,@iFTID,@dtNow,@iCenterID,@iCenterFTID)
END
