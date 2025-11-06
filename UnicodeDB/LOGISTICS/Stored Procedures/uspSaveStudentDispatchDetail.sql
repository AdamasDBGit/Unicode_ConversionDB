CREATE PROCEDURE [LOGISTICS].[uspSaveStudentDispatchDetail] 
(
	@iStudentDetailID   INT,
	@iCentreID			INT,
	@iKitID		        INT,	
	@DtDispatchDate		DATETIME,	
	@sDocketNo		    VARCHAR(50),
    @sTransporterName   VARCHAR(50),
	@iStatus			INT,
	@iInstallmentNO		INT,
	@sCrtdBy			VARCHAR(20),
	@dtCrtdOn			DATETIME,
	@sUpdBy				VARCHAR(20),
	@dtUpdOn			DATETIME        
)
AS
BEGIN TRY
SET NOCOUNT OFF;
DECLARE @iStudentID INT
SET @iStudentID = 0


IF EXISTS(SELECT I_Student_Detail_ID FROM [LOGISTICS].T_Student_Despatch_Detailed WHERE I_Student_Detail_ID=@iStudentDetailID AND I_Installment_No = @iInstallmentNO AND ISNULL(I_Kit_ID, 0)=0)
BEGIN
DELETE FROM [LOGISTICS].T_Student_Despatch_Detailed WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Installment_No = @iInstallmentNO AND ISNULL(I_Kit_ID, 0)=0
END

IF EXISTS(SELECT I_Student_Detail_ID FROM [LOGISTICS].T_Student_Despatch_Detailed WHERE I_Student_Detail_ID=@iStudentDetailID AND I_Installment_No = @iInstallmentNO)
BEGIN
	UPDATE [LOGISTICS].T_Student_Despatch_Detailed
	SET
	I_Student_Detail_ID = COALESCE(@iStudentDetailID,I_Student_Detail_ID)
	,I_Center_ID = COALESCE(@iCentreID,I_Center_ID)
	,I_Kit_ID = COALESCE(@iKitID ,I_Kit_ID)
	,Dt_Dispatch_Date = COALESCE(@DtDispatchDate , Dt_Dispatch_Date)
	,S_Docket_No = COALESCE(@sDocketNo,S_Docket_No)
	,S_Transporter_Name =  COALESCE(@sTransporterName ,S_Transporter_Name)
	,I_Status =  COALESCE(@iStatus ,I_Status)
	,I_Installment_No =  COALESCE(@iInstallmentNO ,I_Installment_No)
	,S_Crtd_By =  COALESCE(@sCrtdBy ,S_Crtd_By)
	,Dt_Crtd_On =  COALESCE(@dtCrtdOn ,Dt_Crtd_On)
	,S_Upd_By =  COALESCE(@sUpdBy ,S_Upd_By)
	,Dt_Upd_On =  COALESCE(@dtUpdOn ,Dt_Upd_On)
	 WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Installment_No = @iInstallmentNO AND ISNULL(I_Kit_ID, 0)=0
END
ELSE
BEGIN
	INSERT INTO [LOGISTICS].T_Student_Despatch_Detailed
	(
		I_Student_Detail_ID,
		I_Center_ID,
		I_Kit_ID,
		Dt_Dispatch_Date,						
	    S_Docket_No,
		S_Transporter_Name,
		I_Status,
		I_Installment_No,
		S_Crtd_By, 
		Dt_Crtd_On,
		S_Upd_By, 
		Dt_Upd_On				
	)
	VALUES
	(
		@iStudentDetailID,
		@iCentreID,
		@iKitID,	
		@DtDispatchDate,	
		@sDocketNo,
		@sTransporterName,
		@iStatus,
		@iInstallmentNO,
		@sCrtdBy,
		@dtCrtdOn,
		@sUpdBy,
		@dtUpdOn	
	)
	           
	END	
	
								
END TRY

BEGIN CATCH
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
