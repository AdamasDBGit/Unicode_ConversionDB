-- =============================================
-- Author:		Shankha Roy
-- Create date: '14/02/2008'
-- Description:	This Function return a table 
-- constains YTD For Enquiry, Enrollmet, Booking and Billing
-- Return: Table
-- =============================================
CREATE FUNCTION [MBP].[fnGetYTDFORMBP]
(
	@iMonth INT,
	@iYear INT,
	@iCenterID VARCHAR(2000),
	@iProductID INT
)
RETURNS  @TempYTDMBP TABLE
	( 
		I_Center_ID int,
		I_Target_Enquiry INT,
		I_Target_Booking NUMERIC(18,2),
		I_Target_Enrollment INT,
		I_Target_Billing NUMERIC(18,2),
		I_Target_RFF NUMERIC(18,2),
		I_Actual_Enquiry INT,
		I_Actual_Booking NUMERIC(18,2),
		I_Actual_Enrollment INT,
		I_Actual_Billing NUMERIC(18,2),
		I_Actual_RFF NUMERIC(18,2)			
		
	)

AS 
BEGIN
		DECLARE @I_Center_ID int
		DECLARE @I_Target_Enquiry INT
		DECLARE @I_Target_Booking NUMERIC(18,2)
		DECLARE @I_Target_Enrollment INT
		DECLARE @I_Target_Billing NUMERIC(18,2)
		DECLARE @I_Target_RFF NUMERIC(18,2)
		DECLARE @I_Target_Enquiry_Audit INT
		DECLARE @I_Target_Booking_Audit NUMERIC(18,2)
		DECLARE @I_Target_Enrollment_Audit INT
		DECLARE @I_Target_Billing_Audit NUMERIC(18,2)
		DECLARE @I_Target_RFF_Audit NUMERIC(18,2)
		DECLARE @I_Actual_Enquiry INT
		DECLARE @I_Actual_Booking NUMERIC(18,2)
		DECLARE @I_Actual_Enrollment INT
		DECLARE @I_Actual_Billing NUMERIC(18,2)
		DECLARE @I_Actual_RFF NUMERIC(18,2)	
	

DECLARE @temTable TABLE
(
ID INT IDENTITY(1,1),
I_Center_ID INT
)

DECLARE @iCount INT
DECLARE @iRow INT
DECLARE @iNewCenterID INT

INSERT INTO @temTable
SELECT ID FROM [dbo].[fnSplitter](@iCenterID)

SET @iCount = 1
SET @iRow = (SELECT COUNT(ID) FROM @temTable)

WHILE(@iCount <= @iRow)
 BEGIN
	SET @iNewCenterID = (SELECT I_Center_ID FROM @temTable WHERE ID = @iCount)

		-- FOR TARGET DATA
		SELECT @I_Target_Enquiry=SUM(ISNULL(MBP.I_Target_Enquiry,0)),@I_Target_Booking =SUM(ISNULL(MBP.I_Target_Booking,0)),
		 @I_Target_Enrollment = SUM(ISNULL(MBP.I_Target_Enrollment,0)) ,@I_Target_Billing =SUM(ISNULL(MBP.I_Target_Billing,0)),
		 @I_Target_RFF = SUM(ISNULL(MBP.I_Target_RFF,0))
		FROM MBP.T_MBP_Detail MBP
		WHERE MBP.I_Center_ID =@iNewCenterID
		AND MBP.I_Product_ID =@iProductID
		AND I_Month <= @iMonth
		AND MBP.I_Year = @iYear
		AND MBP.I_Type_ID = 4

		-- GETTING TARGET DATA FROM AUDIT TABLE 

			SELECT @I_Target_Enquiry_Audit=SUM(ISNULL(MDA.I_Target_Enquiry,0)),@I_Target_Booking_Audit =SUM(ISNULL(MDA.I_Target_Booking,0)),
			 @I_Target_Enrollment_Audit =  SUM(ISNULL(MDA.I_Target_Enrollment,0)) ,@I_Target_Billing_Audit =SUM(ISNULL(MDA.I_Target_Billing,0)),
			 @I_Target_RFF_Audit =SUM(ISNULL(MDA.I_Target_RFF,0))
			FROM MBP.T_MBP_Detail_Audit MDA
			WHERE MDA.I_MBP_Detail_ID IN (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail MBP WHERE
			 MBP.I_Center_ID =@iNewCenterID
			AND MBP.I_Product_ID =@iProductID
			AND I_Month <= @iMonth
			AND MBP.I_Year = @iYear
			AND MBP.I_Type_ID = 5)
			AND MDA.I_Type_ID = 4

			IF(@I_Target_Enquiry_Audit IS NOT NULL)
			 BEGIN
					SET @I_Target_Enquiry = (@I_Target_Enquiry + @I_Target_Enquiry_Audit)
			 END
			IF(@I_Target_Booking_Audit IS NOT NULL)
			 BEGIN
				SET @I_Target_Booking  = (@I_Target_Booking + @I_Target_Booking_Audit )
			 END
			IF(@I_Target_Enrollment_Audit IS NOT NULL)
			 BEGIN
				SET @I_Target_Enrollment=(@I_Target_Enrollment +@I_Target_Enrollment_Audit)
			 END
			IF(@I_Target_Billing_Audit IS NOT NULL)
			 BEGIN
				SET @I_Target_Billing =(@I_Target_Billing +@I_Target_Billing_Audit)
			 END
			IF(@I_Target_RFF_Audit IS NOT NULL)
			 BEGIN
				SET @I_Target_RFF =(@I_Target_RFF +@I_Target_RFF_Audit)
			 END

	

		-- FOR ACTUAL DATA
		SELECT @I_Actual_Enquiry=SUM(ISNULL(PER.I_Actual_Enquiry,0)),@I_Actual_Booking =SUM(ISNULL(PER.I_Actual_Booking,0)),
		@I_Actual_Enrollment = SUM(ISNULL(PER.I_Actual_Enrollment,0)) ,@I_Actual_Billing =SUM(ISNULL(PER.I_Actual_Billing,0)),
		@I_Actual_RFF =SUM(ISNULL(PER.I_Actual_RFF,0))
		FROM  MBP.T_MBPerformance PER
		WHERE PER.I_Center_ID =@iNewCenterID
		AND PER.I_Product_ID =@iProductID
		AND I_Month <= @iMonth
		AND PER.I_Year = @iYear
	
		INSERT INTO @TempYTDMBP(I_Center_ID,I_Target_Enquiry,I_Target_Booking,I_Target_Enrollment,I_Target_Billing,I_Target_RFF,I_Actual_Enquiry,I_Actual_Booking,I_Actual_Enrollment,I_Actual_Billing,I_Actual_RFF)
		SELECT @iNewCenterID,@I_Target_Enquiry,@I_Target_Booking,@I_Target_Enrollment,@I_Target_Billing,@I_Target_RFF,@I_Actual_Enquiry,@I_Actual_Booking,@I_Actual_Enrollment,@I_Actual_Billing,@I_Actual_RFF

SET @iCount = @iCount+1 
	
END

	
 RETURN ;
END