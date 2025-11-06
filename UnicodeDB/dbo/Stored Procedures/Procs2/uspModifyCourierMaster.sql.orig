CREATE PROCEDURE [dbo].[uspModifyCourierMaster] 
(
	@iCourierID int,
	@sCourierCode varchar(20),
    @sCourierName varchar(200),
    @dtCourierStateDate datetime,
    @dtCourierEndDate datetime,
    @sCourierAddress1 varchar(20),
    @sCourierAddress2 varchar(20),
    @iCourierCountry int,
    @iCourierState int,
    @iCourierCity int,
    @sCourierPincode varchar(20),
    @sCourierTelephone varchar(20),
    @sCourierContactPerson varchar(20),
	@sUpdatedBy varchar(20),
	@dtUpdatedOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @iCourierState = 0 SET @iCourierState = null
	IF @iCourierCity = 0 SET @iCourierCity = null
	
    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Courier_Master
		(S_Courier_Code,
		S_Courier_Name,
		Dt_Start_Date,
		Dt_End_Date,
		S_Address_Line1,
		S_Address_Line2,
		I_Country_ID,	
		I_State_ID,
		I_City_ID,	
		S_Pincode,
		S_Telephone_No,
		S_Contact_Person,
		I_Status,
		S_Crtd_By,
		Dt_Crtd_On)
		VALUES(@sCourierCode,
		@sCourierName,
		@dtCourierStateDate,
		@dtCourierEndDate,
		@sCourierAddress1,
		@sCourierAddress2,
		@iCourierCountry,
		@iCourierState,
		@iCourierCity,
		@sCourierPincode,
		@sCourierTelephone,
		@sCourierContactPerson,
		1,
		@sUpdatedBy,
		@dtUpdatedOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Courier_Master
		SET S_Courier_Code = @sCourierCode,
		S_Courier_Name = @sCourierName,
		Dt_Start_Date = @dtCourierStateDate,
		Dt_End_Date = @dtCourierEndDate,
		S_Address_Line1 = @sCourierAddress1,
		S_Address_Line2 = @sCourierAddress2,
		I_Country_ID = @iCourierCountry,	
		I_State_ID = @iCourierState,
		I_City_ID = @iCourierCity,	
		S_Pincode = @sCourierPincode,
		S_Telephone_No = @sCourierTelephone,
		S_Contact_Person = @sCourierContactPerson,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @dtUpdatedOn
		where I_Courier_ID = @iCourierID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Courier_Master
		SET I_Status = 0,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @dtUpdatedOn
		where I_Courier_ID = @iCourierID
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
