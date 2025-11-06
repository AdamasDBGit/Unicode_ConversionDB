CREATE PROCEDURE [SMManagement].[uspUpdateUndeliveredTracking](@TrackingID VARCHAR(20))
AS
BEGIN

UPDATE SMManagement.T_Courier_TrackingID SET StatusID=3 WHERE TrackingID=@TrackingID 

END
