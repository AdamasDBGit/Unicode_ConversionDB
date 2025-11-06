--*********************
--Created By: Abhisek Bhattacharya 19/04/2007
--**********************

CREATE PROCEDURE [dbo].[uspUpdateFeePlan] 
(
	-- Add the parameters for the stored procedure here
	@iCourseFeePlanID int,
	@iCourseID int,
	@iCourseDeliveryID int,
	@iCurrencyID int,
	@sFeePlanName varchar(40),
	@iTotalLumpSum int,
	@iTotalInstallment int,
	@sFeePlanDetailXml text,
	@sUpdatedBy varchar(20)
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DECLARE @iDocHandle int
	DECLARE @iCourseDeliveryMapID int
	
	IF NOT EXISTS(SELECT I_Course_Center_Delivery_ID FROM dbo.T_Course_Center_Delivery_FeePlan
			WHERE I_Course_Fee_Plan_ID = @iCourseFeePlanID 
			AND I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE()))
	BEGIN
		SELECT @iCourseDeliveryMapID = I_Course_Delivery_ID
		FROM dbo.T_Course_Delivery_Map
		WHERE I_Course_ID = @iCourseID
		AND I_Delivery_Pattern_ID = @iCourseDeliveryID
		AND I_Status = 1
	
		BEGIN TRANSACTION
		UPDATE dbo.T_Course_Fee_Plan
		SET S_Fee_Plan_Name = @sFeePlanName,
		I_Currency_ID = @iCurrencyID,
		N_TotalLumpSum = @iTotalLumpSum,
		N_TotalInstallment = @iTotalInstallment,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = GETDATE()
		WHERE I_Course_Fee_Plan_ID = @iCourseFeePlanID
		AND I_Status = 1
	
		UPDATE dbo.T_Course_Fee_Plan_Detail
		SET I_Status = 0,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = GETDATE()
		WHERE I_Course_Fee_Plan_ID = @iCourseFeePlanID
		AND I_Status = 1 
	
		EXEC sp_xml_preparedocument @iDocHandle output, @sFeePlanDetailXml

		INSERT INTO dbo.T_Course_Fee_Plan_Detail
		(
			I_Fee_Component_ID,
			N_CompanyShare,
			I_Installment_No,
			I_Sequence,
			C_Is_LumpSum,
			I_Item_Value,
			I_Display_Fee_Component_ID, 
			I_Status,
			I_Course_Fee_Plan_ID,
			S_Crtd_By,
			Dt_Crtd_On
		)
		SELECT *,1,@iCourseFeePlanID,@sUpdatedBy,GETDATE() FROM OPENXML(@iDocHandle, '/FeePlanDetail/Installments',2)
		WITH 
		(	I_Fee_Component_ID int,
			N_CompanyShare numeric,
			I_Installment_No int,
			I_Sequence int,
			C_Is_LumpSum char(1),
			I_Item_Value numeric,
			I_Display_Fee_Component_ID int
		)
		COMMIT TRANSACTION
	END
		
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
