-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp use for save ABP data  in MBP.T_MBP_Detail Table 
-- =============================================
CREATE PROCEDURE [MBP].[uspUpdateABP]
(  
@iABPDetailID		INT,
@iTargetEnquir		INT	=NULL,
@iTargetBooking     INT =NULL,
@iTargetEnrollment  INT =NULL,
@iTargetBilling     INT =NULL,
@iTargetRFF			INT =NULL,
@sUpdBy						VARCHAR(20)		,
@dtUpdOn					DATETIME		,
@iTypeID					INT =NULL,
@iStatus					INT =NULL
)
AS
BEGIN TRY
DECLARE @iID INT

IF(@iTypeID <>4)
	BEGIN
		--Update for MBP data
		BEGIN TRANSACTION Trn_Update_ABP
		
		INSERT INTO MBP.T_MBP_Detail_Audit (
		I_Product_ID,I_Center_ID,I_MBP_Detail_ID,I_Status_ID,I_Year,I_Month,
		I_Target_Enquiry,I_Target_Booking,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,
		I_Document_ID ,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Remarks ,I_Type_ID)

		SELECT I_Product_ID,I_Center_ID,I_MBP_Detail_ID,I_Status_ID,I_Year,I_Month,
		I_Target_Enquiry,I_Target_Booking,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,
		I_Document_ID ,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Remarks ,I_Type_ID
		FROM MBP.T_MBP_Detail

		WHERE I_MBP_Detail_ID = @iABPDetailID
		SET @iID = SCOPE_IDENTITY()
		IF(@iID > 0)
		 BEGIN 
			 UPDATE MBP.T_MBP_Detail 
				SET I_Target_Enquiry =COALESCE(@iTargetEnquir,I_Target_Enquiry),
					I_Target_Booking = COALESCE(@iTargetBooking,I_Target_Booking),
					I_Target_Enrollment =COALESCE(@iTargetEnrollment,I_Target_Enrollment),
					I_Target_Billing = COALESCE(@iTargetBilling,I_Target_Billing),
					I_Target_RFF = COALESCE(@iTargetRFF,I_Target_RFF),
					I_Status_ID = COALESCE(@iStatus,I_Status_ID),
					I_Type_ID = COALESCE(@iTypeID,I_Type_ID),
					S_Upd_By =  COALESCE(@sUpdBy,S_Upd_By),
					Dt_Upd_On = COALESCE(@dtUpdOn,Dt_Upd_On)
				WHERE I_MBP_Detail_ID = @iABPDetailID
				
			COMMIT TRANSACTION Trn_Update_ABP
		 END
		
		ELSE
			BEGIN 
				ROLLBACK TRANSACTION Trn_Update_ABP
			END
		
	END 
	ELSE -- For ABP Data Update 
		 BEGIN 




			 UPDATE MBP.T_MBP_Detail 
				SET I_Target_Enquiry =COALESCE(@iTargetEnquir,I_Target_Enquiry),
					I_Target_Booking = COALESCE(@iTargetBooking,I_Target_Booking),
					I_Target_Enrollment =COALESCE(@iTargetEnrollment,I_Target_Enrollment),
					I_Target_Billing = COALESCE(@iTargetBilling,I_Target_Billing),
					I_Target_RFF = COALESCE(@iTargetRFF,I_Target_RFF),
					I_Status_ID = COALESCE(@iStatus,I_Status_ID),
					--I_Type_ID = COALESCE(@iTypeID,I_Type_ID)
					S_Upd_By =  COALESCE(@sUpdBy,S_Upd_By),
					Dt_Upd_On = COALESCE(@dtUpdOn,Dt_Upd_On)
				WHERE I_MBP_Detail_ID = @iABPDetailID
					  AND I_Type_ID = @iTypeID
		-- Update in Audit table 

		UPDATE MBP.T_MBP_Detail_Audit 
				SET I_Target_Enquiry =COALESCE(@iTargetEnquir,I_Target_Enquiry),
					I_Target_Booking = COALESCE(@iTargetBooking,I_Target_Booking),
					I_Target_Enrollment =COALESCE(@iTargetEnrollment,I_Target_Enrollment),
					I_Target_Billing = COALESCE(@iTargetBilling,I_Target_Billing),
					I_Target_RFF = COALESCE(@iTargetRFF,I_Target_RFF),
					I_Status_ID = COALESCE(@iStatus,I_Status_ID),
					--I_Type_ID = COALESCE(@iTypeID,I_Type_ID)
					S_Upd_By =  COALESCE(@sUpdBy,S_Upd_By),
					Dt_Upd_On = COALESCE(@dtUpdOn,Dt_Upd_On)
				WHERE I_MBP_Detail_ID = @iABPDetailID
					   AND I_Type_ID = @iTypeID

			
						
		 END


END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
