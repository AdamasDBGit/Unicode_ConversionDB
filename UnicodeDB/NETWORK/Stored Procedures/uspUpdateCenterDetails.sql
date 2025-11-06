CREATE PROCEDURE [NETWORK].[uspUpdateCenterDetails]
	@iCenterID int,	
	@sCenterCode varchar(20) = null,
	@sCenterName varchar(100),
	@sShortName varchar(50)= null,
	@sSAPCustomerId varchar(50) = null,
	@iCategory int,
	@iRFFType int,
	@iCountryID int,	
	@iStartUpInPlace bit = null,
	@iLibraryInPlace bit = null,
	@iExpiryStatus INT = NULL,
	@sCreatedBy varchar(20),
	@dtCreatedDt Datetime,
	@iStatus int
	
AS

BEGIN TRY
BEGIN TRAN T1

	SET NOCOUNT ON;

	Declare @iActualRowCount Int
	Declare @iCount Int
	Declare @I_Process_ID_Max Int
	Declare @Comments Varchar(2000)
	Declare @Center_Name Varchar(500)
	Select @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 From dbo.T_Batch_Log Where S_Batch_Process_Name='CENTER_RENEWAL_BATCH'

	Declare _Cursor CURSOR FOR
	SELECT S_Center_Name FROM dbo.T_Centre_Master WHERE I_Centre_Id = @iCenterID
	
	OPEN _Cursor
	FETCH NEXT FROM _Cursor INTO @Center_Name
	WHILE @@Fetch_Status=0
	BEGIN

		Set @Comments=@sCenterName+'('+cast(@iCenterID as varchar)+') - Updated'
		EXEC uspWriteBatchProcessLog @I_Process_ID_Max,'CENTER_RENEWAL_BATCH',@Comments,'Success'

		FETCH NEXT FROM _Cursor INTO @Center_Name
	END
	CLOSE _Cursor
	DEALLOCATE _Cursor

	INSERT INTO NETWORK.T_Center_Master_Audit		
	SELECT * FROM dbo.T_Centre_Master
		WHERE I_Centre_Id = @iCenterID

	UPDATE dbo.T_Centre_Master
	SET S_Center_Code = @sCenterCode,
		S_Center_Name = @sCenterName,
		S_Center_Short_Name = ISNULL(@sShortName,S_Center_Short_Name),
		S_SAP_Customer_Id = ISNULL(@sSAPCustomerId,S_SAP_Customer_Id),
		I_Center_Category = @iCategory,
		I_RFF_Type = @iRFFType,
		I_Country_ID = @iCountryID,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedDt,
		I_Is_Startup_Material_In_Place = @iStartUpInPlace,
		I_Is_Library_In_Place = @iLibraryInPlace,
		I_Status = @iStatus,
		I_Expiry_Status = @iExpiryStatus
	WHERE I_Centre_Id = @iCenterID

	UPDATE dbo.T_Hierarchy_Details
	SET S_Hierarchy_Name=@sCenterName
	WHERE I_Hierarchy_Detail_ID in 
	(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE i_center_id=@iCenterID)	

COMMIT TRAN T1
END TRY

BEGIN CATCH
--Error occurred:
	ROLLBACK  TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
