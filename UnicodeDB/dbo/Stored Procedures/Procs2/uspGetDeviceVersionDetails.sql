-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <21st August 2023>
-- Description:	<for adding guardian>
--exec uspGetDeviceVersionDetails
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDeviceVersionDetails]
	-- Add the parameters for the stored procedure here
	
AS
	select 
	S_Device_Name DeviceName
	,S_Version Version
	,S_VersionCode VersionCode
	,I_IsForsce IsForsce
	,I_IsForceLogOut IsForceLogOut

	from T_Device_Details
