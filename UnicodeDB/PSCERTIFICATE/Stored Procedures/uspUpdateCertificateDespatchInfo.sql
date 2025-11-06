-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:11/06/2007 
-- Description:Update Certificate Despatch record in T_Certificate_Despatch_Info table	
-- =================================================================
CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateCertificateDespatchInfo] 
(
	@iDespatchID		int = NULL	    ,
	@iLogisticID		int         ,
	@iCourierID		int         ,
	@DtDispatchDate		datetime    ,
	--@DtExpDeliveryDate	datetime    ,
	@iDocketNo		VARCHAR(20)	    ,
    @SCrtdBy			varchar(20)   ,
    @DtCrtdOn 		datetime,
	@iStatus		int
)
AS
BEGIN TRY
    SET NOCOUNT OFF;

    UPDATE [PSCERTIFICATE].T_Certificate_Despatch_Info
      SET
	I_Logistic_ID		= @iLogisticID       ,	
	I_Courier_ID		= @iCourierID        ,
	S_Docket_No	= @iDocketNo ,
	Dt_Dispatch_Date	= @DtDispatchDate    ,
	--Dt_Exp_Delivery_Date	= @DtExpDeliveryDate ,	
	S_Upd_By		= @SCrtdBy            ,
    Dt_Crtd_On              = @DtCrtdOn
	where I_Despatch_ID = @iDespatchID
					
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
