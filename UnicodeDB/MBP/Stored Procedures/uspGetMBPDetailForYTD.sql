-- =============================================
-- Author:		Shankha Roy
-- Create date: '14/02/2008'
-- Description:	This store procedure 
-- constains YTD For Enquiry, Enrollmet, Booking and Billing
-- Return: Table
-- =============================================



CREATE PROCEDURE [MBP].[uspGetMBPDetailForYTD]
(  
 @iYear INT = NULL,
 @iMonth INT = NULL,
 @iCenterID VARCHAR(8000)  = NULL,
 --@iProduct VARCHAR(2000)	 = NULL,
 @iProduct INT	 = NULL,
 @iStatus INT = NULL
 --,@iMBPPlanType INT = NULL
)
AS

BEGIN TRY 

SELECT	MBP.I_Center_ID,
		ISNULL(MBP.I_Target_Enquiry,0) AS 'YTD_T_Enq',
		ISNULL(MBP.I_Target_Booking,0) AS 'YTD_T_Book',
		ISNULL(MBP.I_Target_Enrollment,0) AS 'YTD_T_Enrol',
		ISNULL(MBP.I_Target_Billing ,0) AS 'YTD_T_Bill',
		ISNULL(MBP.I_Target_RFF ,0) AS 'YTD_T_RFF',		

		ISNULL(MBP.I_Actual_Enquiry,0) AS 'YTD_A_Enq',
		ISNULL(MBP.I_Actual_Booking,0) AS 'YTD_A_Book',
		ISNULL(MBP.I_Actual_Enrollment,0) AS 'YTD_A_Enrol',
		ISNULL(MBP.I_Actual_Billing,0) AS 'YTD_A_Bill',
		ISNULL(MBP.I_Actual_Billing,0) AS 'YTD_A_RFF',

		ISNULL(((MBP.I_Actual_Enquiry)/@iMonth),0) AS 'YTD_Avg_Enq', 
		ISNULL(((MBP.I_Actual_Booking)/@iMonth),0) AS 'YTD_Avg_Book',
		ISNULL(((MBP.I_Actual_Enrollment)/@iMonth),0) AS 'YTD_Avg_Enrol',
		ISNULL(((MBP.I_Actual_Billing)/@iMonth),0) AS 'YTD_Avg_Bill',
		ISNULL(((MBP.I_Actual_Billing)/@iMonth),0) AS 'YTD_Avg_RFF'		

 FROM [MBP].[fnGetYTDFORMBP](@iMonth,@iYear,@iCenterID,@iProduct)  MBP




	END TRY
	BEGIN CATCH
	--Error occurred:  
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
