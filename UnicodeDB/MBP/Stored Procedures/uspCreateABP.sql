-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp use for save ABP data  in MBP.T_MBP_Detail Table 
-- =============================================
CREATE PROCEDURE [MBP].[uspCreateABP]
(  
@sABPDetails			XML				,
@iYear		INT	,
@iStatus				INT,
@iDocumentID INT,
@sCrtdBy					VARCHAR(20)		,
@sUpdBy						VARCHAR(20)		,
@dtCrtdOn					DATETIME		,
@dtUpdOn					DATETIME		,
@iTypeID					INT,
@sRemarks					VARCHAR(2000) = null			
)
AS
BEGIN TRY

DECLARE @temABP TABLE
(
ID INT IDENTITY(1,1),
I_Product_ID INT,
I_Center_ID INT,
I_Year INT,
I_Status_ID INT,
I_Month INT,
I_Target_Enquiry INT,
I_Target_Booking NUMERIC(18,2),
I_Target_Enrollment NUMERIC(18,2),
I_Target_Billing NUMERIC(18,2),
I_Target_RFF NUMERIC(18,2),
I_Document_ID INT,
S_Crtd_By VARCHAR(20),
S_Upd_By VARCHAR(20),
Dt_Crtd_On DATETIME,
Dt_Upd_On DATETIME,
I_Type_ID INT,
S_Remarks VARCHAR(2000)
)

DECLARE @iRows INT
DECLARE @iCount INT
DECLARE @iMonth INT
--DECLARE @iTypeID INT
DECLARE @iProductID INT
DECLARE @iCenterID INT
DECLARE @iDocument INT
DECLARE @iTarget_Booking NUMERIC(18,2)
DECLARE @iTarget_Enquiry NUMERIC(18,2)
DECLARE @iTarget_Enrollment NUMERIC(18,2)
DECLARE @iTarget_Billing NUMERIC(18,2)
DECLARE @iTarget_RFF NUMERIC(18,2)

---BEGIN TRANSACTION Trn_Add_ABP

IF NOT EXISTS(SELECT DISTINCT(I_Document_ID) FROM MBP.T_MBP_Detail WHERE I_Year = @iYear AND I_Type_ID=@iTypeID)
BEGIN	


    INSERT INTO MBP.T_MBP_Detail
	(I_Product_ID,I_Center_ID,I_Year,I_Status_ID,I_Month,I_Target_Enquiry,
	I_Target_Booking ,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,I_Document_ID,
	S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_Type_ID,S_Remarks)
	SELECT
	T.c.value('@ProductID','varchar(100)'),
	T.c.value('@CenterID','varchar(100)'),
	@iYear,
	@iStatus,
	T.c.value('@Month','varchar(100)'),
	T.c.value('@Enquiry','varchar(100)'),
	T.c.value('@Booking','varchar(100)'),
	T.c.value('@Admission','varchar(100)'),
	T.c.value('@Billing','varchar(100)'),
	T.c.value('@CompanyShare','varchar(100)'),
	@iDocumentID,
	@sCrtdBy,
	@sUpdBy,
	@dtCrtdOn,
	@dtUpdOn,
	@iTypeID,
	@sRemarks
	FROM @sABPDetails.nodes('/BusinessPlan/Product')T(c)
END 

ELSE 
	BEGIN
		INSERT INTO @temABP
		(I_Product_ID,I_Center_ID,I_Year,I_Status_ID,I_Month,I_Target_Enquiry,
		I_Target_Booking ,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,I_Document_ID,
		S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_Type_ID,S_Remarks)
		SELECT
		T.c.value('@ProductID','varchar(100)'),
		T.c.value('@CenterID','varchar(100)'),
		@iYear,
		@iStatus,
		T.c.value('@Month','varchar(100)'),
		T.c.value('@Enquiry','varchar(100)'),
		T.c.value('@Booking','varchar(100)'),
		T.c.value('@Admission','varchar(100)'),
		T.c.value('@Billing','varchar(100)'),
		T.c.value('@CompanyShare','varchar(100)'),
		@iDocumentID,
		@sCrtdBy,
		@sUpdBy,
		@dtCrtdOn,
		@dtUpdOn,
		@iTypeID,
		@sRemarks
		FROM @sABPDetails.nodes('/BusinessPlan/Product')T(c)

      SET @iRows =( SELECT COUNT(*) FROM @temABP)

	  SET @iCount = 1
	WHILE(@iCount <= @iRows)
		BEGIN
			SELECT @iProductID =I_Product_ID,
				   @iCenterID=I_Center_ID ,
				   @iMonth= I_Month ,
				   @iTarget_Booking = I_Target_Booking,
				   @iTarget_Enquiry = I_Target_Enquiry,
				   @iTarget_Enrollment = I_Target_Enrollment,
				   @iTarget_Billing = I_Target_Billing,
				   @iTarget_RFF = I_Target_RFF
			FROM @temABP WHERE ID = @iCount
			-- CHECK IF DATA IS PRESENT IN T_MBP_Detail Table or not
				IF EXISTS (SELECT DISTINCT(I_Document_ID) FROM MBP.T_MBP_Detail 
				WHERE I_Year = @iYear 
				AND I_Type_ID=@iTypeID
				AND I_Product_ID =@iProductID
				AND I_Center_ID = @iCenterID
				AND I_Month = @iMonth) 
					BEGIN
						-- Update the existing data
							UPDATE MBP.T_MBP_Detail SET 
							I_Target_Booking = COALESCE(@iTarget_Booking,I_Target_Booking),
							I_Target_Enquiry = COALESCE(@iTarget_Enquiry,I_Target_Enquiry),
							I_Target_Enrollment = COALESCE(@iTarget_Enrollment ,I_Target_Enrollment),
							I_Target_Billing= COALESCE(@iTarget_Billing,I_Target_Billing),
							I_Target_RFF= COALESCE(@iTarget_RFF,I_Target_RFF)
							WHERE I_Year = @iYear 
							AND I_Type_ID=@iTypeID
							AND I_Product_ID =@iProductID
							AND I_Center_ID = @iCenterID
							AND I_Month = @iMonth						
							
							-- Delete Data from T_MBP_Detail_Audit table
--							DELETE MBP.T_MBP_Detail_Audit 
--							WHERE I_Year = @iYear 
--							AND I_Type_ID=@iTypeID
--							AND I_Product_ID =@iProductID
--							AND I_Center_ID = @iCenterID
--							AND I_Month = @iMonth
					END
				ELSE
					BEGIN
					IF EXISTS (SELECT DISTINCT(I_Document_ID) FROM MBP.T_MBP_Detail_Audit 
							WHERE I_Year = @iYear 
							AND I_Type_ID=@iTypeID
							AND I_Product_ID =@iProductID
							AND I_Center_ID = @iCenterID
							AND I_Month = @iMonth)
						BEGIN
							UPDATE MBP.T_MBP_Detail_Audit SET 
							I_Target_Booking = COALESCE(@iTarget_Booking,I_Target_Booking),
							I_Target_Enquiry = COALESCE(@iTarget_Enquiry,I_Target_Enquiry),
							I_Target_Enrollment = COALESCE(@iTarget_Enrollment ,I_Target_Enrollment),
							I_Target_Billing= COALESCE(@iTarget_Billing,I_Target_Billing) ,
							I_Target_RFF=COALESCE(@iTarget_RFF,I_Target_RFF)
							WHERE I_Year = @iYear 
							AND I_Type_ID=@iTypeID
							AND I_Product_ID =@iProductID
							AND I_Center_ID = @iCenterID
							AND I_Month = @iMonth
						END
				ELSE
					BEGIN
					-- Insert new set of data 
						INSERT INTO MBP.T_MBP_Detail
						(I_Product_ID,I_Center_ID,I_Year,I_Status_ID,I_Month,I_Target_Enquiry,
						I_Target_Booking ,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,I_Document_ID,
						S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_Type_ID,S_Remarks)
						SELECT I_Product_ID,I_Center_ID,I_Year,I_Status_ID,I_Month,I_Target_Enquiry,
						I_Target_Booking ,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,I_Document_ID,
						S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_Type_ID,S_Remarks
						FROM @temABP WHERE ID = @iCount

					END
			
				END
			
			SET @iCount = @iCount+1;
		END



	END


END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
