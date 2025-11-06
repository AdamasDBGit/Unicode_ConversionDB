-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Stream Master table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyEnquiryType] 
(
	@iEnquiryTypeID int,
	@sEnquiryTypeDescription varchar(50),    
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 
    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Enquiry_Type(S_Enquiry_Type_Desc,I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@sEnquiryTypeDescription, 1, @sCreatedBy, @dtCreatedOn)    
		SET @iResult = 1  -- Insertion successful
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Enquiry_Type
		SET S_Enquiry_Type_Desc = @sEnquiryTypeDescription,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedOn
		where I_Enquiry_Type_ID = @iEnquiryTypeID
		SET @iResult = 1  -- Updation successful
	END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF @iFlag = 3
	BEGIN
		IF NOT EXISTS(SELECT I_Enquiry_Type_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Enquiry_Type_ID=@iEnquiryTypeID)
			BEGIN
				UPDATE dbo.T_Enquiry_Type
				SET I_Status = 0 ,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Enquiry_Type_ID = @iEnquiryTypeID
				SET @iResult = 1  -- Deletion successful
			END
		ELSE
			BEGIN
				SET @iResult = 2  -- Deletion not allowed due to Foreign Key Constraint
			END
	END
	SELECT @iResult Result
END TRY


BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
