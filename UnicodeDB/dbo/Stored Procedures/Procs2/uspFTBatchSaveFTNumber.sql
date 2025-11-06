CREATE PROCEDURE [dbo].[uspFTBatchSaveFTNumber]
	@iFTID INT,
	@dtCurrentDate DATETIME
 
AS
BEGIN

	INSERT INTO dbo.T_FT_History
	(I_FT_SAP_ID,Dt_FT_Date)
	VALUES
	(@iFTID,@dtCurrentDate)
END
