/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By : 
-- Create date:07/16/2007 
-- Description:Select Unique Logistics Serial No. in T_Certificate_Logistic table 
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspGetUniqueLogisticsSrlNo]
(
	@sLogisticsSrl	VARCHAR(1000)

)
AS
BEGIN

   SELECT 
		COUNT(*)
     FROM [PSCERTIFICATE].T_Certificate_Logistic CL
     WHERE
			S_Logistic_Serial_No = @sLogisticsSrl
END
