-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:11/06/2007 
-- Description:Insert new Certificate Despatch record in T_Certificate_Despatch_Info table	
-- =================================================================
CREATE PROCEDURE [PSCERTIFICATE].[uspAddCertificateDespatchInfo] 
(

	@iLogisticID		int         ,
	@iCourierID		int         ,
	@sDespatchSerialno	varchar(20) =null ,
	@DtDispatchDate		datetime    ,
	--@DtExpDeliveryDate	datetime = null   ,
	@iDocketNo		VARCHAR(20)	    ,
    @SCrtdBy		varchar(20) ,
    @DtCrtdOn 		datetime ,
	@iStatus		int
)
AS
BEGIN TRY
DECLARE @iStudentCertificateid INT
DECLARE @iDespatchID INT
SET @iDespatchID = 0

    SET NOCOUNT OFF;
			BEGIN TRANSACTION trnAddCertificateDespatch

				INSERT INTO [PSCERTIFICATE].T_Certificate_Despatch_Info
				  (
				I_Logistic_ID		,
				I_Courier_ID		,
				S_Despatch_Serialno	,
				Dt_Dispatch_Date	,
				--Dt_Exp_Delivery_Date	,
			    S_Docket_No,
				S_Crtd_By		,
				Dt_Crtd_On
				  )
				VALUES
				  (
				@iLogisticID 	,
				@iCourierID		,
				@sDespatchSerialno	,
				@DtDispatchDate		,
				--@DtExpDeliveryDate	,
				@iDocketNo,
				@SCrtdBy		,
				@DtCrtdOn 
				)

	SET @iDespatchID = SCOPE_IDENTITY();

	IF(@iDespatchID > 0)
	BEGIN
		-- Select student certificate id using logistic id
		SET @iStudentCertificateid=(SELECT DISTINCT (A.I_Student_Certificate_ID) FROM 
									[PSCERTIFICATE].T_Student_PS_Certificate A,
									[PSCERTIFICATE].T_Certificate_Despatch_Info B ,
									[PSCERTIFICATE].T_Certificate_Logistic C
									WHERE B.I_Logistic_ID = C.I_Logistic_ID
									AND A.I_Student_Certificate_ID = C.I_Student_Certificate_ID
									AND B.I_Logistic_ID = @iLogisticID)

			IF(@iStudentCertificateid > 0)
				-- Update T_Student_PS_Certificate table status to despatch
				--The status of certificate Despatch - 3
				 BEGIN
					UPDATE [PSCERTIFICATE].T_Student_PS_Certificate 
					SET 
						I_Status = @iStatus,
						Dt_Upd_On = Getdate()
					WHERE I_Student_Certificate_ID = @iStudentCertificateid
					IF(@@ERROR > 0)
					 ROLLBACK TRANSACTION trnAddCertificateDespatch
					ELSE
					  COMMIT TRANSACTION trnAddCertificateDespatch
				
				 END
	
	END
SELECT @iDespatchID 
								
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
