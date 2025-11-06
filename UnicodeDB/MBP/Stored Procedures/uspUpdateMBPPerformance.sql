-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp use for save Booking details in MBP.T_MBPerformance table
-- =============================================
--[MBP].[uspUpdateMBPPerformance] 2008,5,11
CREATE PROCEDURE [MBP].[uspUpdateMBPPerformance]
( 
 @iYear			 INT,
 @iMonth		 INT,
 @iCenterID INT

)
AS
BEGIN TRY

SET NOCOUNT ON;

DECLARE @MaxDateInMBPPerformance DATETIME 

IF EXISTS (SELECT 'TRUE' FROM MBP.T_MBPerformance)
BEGIN
	SELECT @MaxDateInMBPPerformance = MAX(Dt_Upd_On) 
	FROM MBP.T_MBPerformance
END
ELSE
BEGIN
	SELECT @MaxDateInMBPPerformance = MIN(Dt_Crtd_On) 
	FROM DBO.T_Enquiry_Regn_Detail
END

IF @MaxDateInMBPPerformance IS NOT NULL
BEGIN
--	SELECT 'HI'
	EXEC MBP.uspGetBilling @iYear,@iMonth,@iCenterID, @MaxDateInMBPPerformance
	EXEC MBP.uspGetBooking @iYear,@iMonth,@iCenterID, @MaxDateInMBPPerformance
	EXEC MBP.uspGetEnquiry @iYear,@iMonth,@iCenterID, @MaxDateInMBPPerformance
	EXEC MBP.uspGetEnroll @iYear,@iMonth,@iCenterID, @MaxDateInMBPPerformance
END

END TRY

BEGIN CATCH
--Error occurred:  
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH




--==================================================



--------------------------DROP MBP FUNCTION IF EXIST------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MBP].[fnGetProductIDFromCenterID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [MBP].[fnGetProductIDFromCenterID]
