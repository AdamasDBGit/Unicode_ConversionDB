CREATE PROCEDURE [SMManagement].[uspGetTrackingIDList]
AS

BEGIN

SELECT TSDSH.TrackingID FROM SMManagement.T_Stock_Dispatch_Student_Header AS TSDSH
INNER JOIN SMManagement.T_Courier_TrackingID AS TCTI2 ON TCTI2.TrackingID = TSDSH.TrackingID
WHERE TSDSH.TrackingID!='' AND ISNULL(TSDSH.IsDelivered,0)=0 AND TSDSH.TrackingID IS NOT NULL AND TCTI2.StatusID=1

END
