-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp return the detail of upload document
-- =============================================
CREATE PROCEDURE [MBP].[uspGetMBPPerformanceDetail]
(  
 @iYear INT = NULL,
 @iMonth INT = NULL,
 @iCenterID VARCHAR(8000)  = NULL,
 @iProduct VARCHAR(2000)	 = NULL
-- @iProduct INT	 = NULL
)
AS
	BEGIN TRY
	
	DECLARE @tblProduct TABLE
	(
		ID INT IDENTITY(1,1),
		I_Product_ID INT
	)
	
	DECLARE @tblCenter TABLE
	(
		ID INT IDENTITY(1,1),
		I_Center_ID INT
	)
	
	DECLARE @tblMBPPerformance TABLE
	(
		I_Product_ID INT,
		I_Center_ID INT,
		I_Year INT,
		I_Month INT,
		I_Actual_Enquiry INT,
		I_Actual_Booking NUMERIC(18,2),
		I_Actual_Enrollment INT,
		I_Actual_Billing NUMERIC(18,2),
		I_Actual_RFF NUMERIC(18,2),
		S_Remarks VARCHAR(2000)
	)
	
	
	INSERT INTO @tblProduct( [I_Product_ID] )
	SELECT ID FROM [dbo].[fnSplitter](@iProduct)
	
	INSERT INTO @tblCenter( [I_Center_ID] )
	SELECT ID FROM [dbo].[fnSplitter](@iCenterID)
	
	DECLARE @iIndexCenter INT, @iIndexProduct INT, @iRowCountCenter INT, @iRowCountProduct INT
	DECLARE @iCntID INT, @iPrdID INT
	
	SELECT @iIndexCenter = 1, @iRowCountCenter = COUNT([TC].[I_Center_ID]) FROM @tblCenter AS TC	
	SELECT @iIndexProduct = 1, @iRowCountProduct = COUNT([TP].[I_Product_ID]) FROM @tblProduct AS TP
	
	WHILE (@iIndexCenter <= @iRowCountCenter)	
	BEGIN
		SELECT @iCntID = [TC].[I_Center_ID] FROM @tblCenter AS TC WHERE [TC].[ID] = @iIndexCenter
		SET @iIndexProduct = 1	
			
		WHILE (@iIndexProduct <= @iRowCountProduct)
		BEGIN
			SELECT @iPrdID = [TP].[I_Product_ID] FROM @tblProduct AS TP WHERE [TP].[ID] = @iIndexProduct
			
			IF EXISTS (SELECT * FROM MBP.T_MBPerformance
			WHERE I_Year = COALESCE( @iYear,I_Year)	AND I_Month = COALESCE(@iMonth,I_Month)
			AND I_Center_ID = @iCntID AND I_Product_ID = @iPrdID)
			BEGIN
				INSERT INTO @tblMBPPerformance
					( [I_Product_ID] ,[I_Center_ID] ,[I_Year] ,[I_Month] ,[I_Actual_Enquiry] ,
					  [I_Actual_Booking] ,[I_Actual_Enrollment] ,[I_Actual_Billing] ,[I_Actual_RFF] ,[S_Remarks])
				SELECT 
				I_Product_ID,I_Center_ID,I_Year,I_Month,ISNULL(I_Actual_Enquiry,0) AS I_Actual_Enquiry,
				ISNULL(I_Actual_Booking,0) AS I_Actual_Booking,
				ISNULL(I_Actual_Enrollment,0) AS I_Actual_Enrollment,
				ISNULL(I_Actual_Billing,0) AS I_Actual_Billing,
				ISNULL(I_Actual_RFF,0) AS I_Actual_RFF,
				ISNULL(S_Remarks,'') AS S_Remarks
				FROM MBP.T_MBPerformance
				WHERE 
				I_Year = COALESCE( @iYear,I_Year)
				AND I_Month = COALESCE(@iMonth,I_Month)
				AND I_Center_ID = @iCntID
				AND I_Product_ID = @iPrdID
			END
			ELSE
			BEGIN
				INSERT INTO @tblMBPPerformance
				        ( [I_Product_ID] ,
				          [I_Center_ID] ,
				          [I_Year] ,
				          [I_Month] ,
				          [I_Actual_Enquiry] ,
				          [I_Actual_Booking] ,
				          [I_Actual_Enrollment] ,
				          [I_Actual_Billing] ,
				          [I_Actual_RFF] ,
				          [S_Remarks]
				        )
				VALUES  ( @iPrdID , -- I_Product_ID - int
				          @iCntID , -- I_Center_ID - int
				          @iYear , -- I_Year - int
				          @iMonth , -- I_Month - int
				          0 , -- I_Actual_Enquiry - int
				          0 , -- I_Actual_Booking - int
				          0 , -- I_Actual_Enrollment - int
				          0 , -- I_Actual_Billing - numeric
				          0 , -- I_Actual_RFF - numeric
				          ''  -- S_Remarks - varchar(2000)
				        )
			END
			
			SET @iIndexProduct = @iIndexProduct + 1
		END
		
		SET @iIndexCenter = @iIndexCenter + 1
	END
	
	SELECT * FROM @tblMBPPerformance AS TMP

END TRY
BEGIN CATCH
--Error occurred:  
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
