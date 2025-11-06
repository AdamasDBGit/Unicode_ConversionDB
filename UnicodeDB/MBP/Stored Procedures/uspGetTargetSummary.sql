/*
-- =================================================================
-- Author : Swagatam Sarkar
-- Create date : 12/Feb/2007 
-- Description : 
-- =================================================================
*/

 CREATE PROCEDURE [MBP].[uspGetTargetSummary] --22, 6, NULL, 2008, 3, 1, 'MBP_DUMMY_PRODUCT_FOR_ENQUIRY'
(
	@iBrandID int,
	@iHierarchyDetailID int,
	@iProductID int = null,
	@iYear int,
	@iMonth int,
	@iCenterID int,
	@sDefaultProduct varchar(2000) = null
)
AS

BEGIN

	SET NOCOUNT ON;
	
		DECLARE @tblHD TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,
		S_Hierarchy_Name VARCHAR(200)
	)
	DECLARE @tblSum TABLE
	(
		I_Hierarchy_Detail_ID int,
		S_Hierarchy_Name VARCHAR(200),
		I_Product_ID INT,
		I_Year INT,
		I_Month INT,
		I_Target_Enquiry int,
		I_Actual_Enquiry int,
		I_Target_Booking int,
		I_Actual_Booking int,
		I_Target_Enrollment int,
		I_Actual_Enrollment int,
		I_Target_Billing int,
		I_Actual_Billing int
	)
	DECLARE @tblEnquirySum TABLE
	(
		I_Hierarchy_Detail_ID int,
		I_Year INT,
		I_Month INT,
		I_Target_Enquiry int,
		I_Actual_Enquiry int
	)
	DECLARE @iDefaultProductID INT
	DECLARE @iCount INT, @iRow INT
	DECLARE @iHierachyDetailID INT
	DECLARE @sHierarchyName VARCHAR(200)
	DECLARE @iMBPType INT
	
	-- determining the Default Product ID
	IF(@sDefaultProduct IS NOT NULL)
	BEGIN
		SET @iDefaultProductID = (SELECT DISTINCT(PM.I_Product_ID) FROM MBP.T_Product_Master PM
		INNER JOIN MBP.T_Product_Component PC
		ON PM.I_Product_ID=PC.I_Product_ID 
		LEFT OUTER JOIN dbo.T_Course_Master CM
		ON CM.I_Course_ID = PC.I_Course_ID
		LEFT OUTER JOIN dbo.T_CourseFamily_Master CFM
		ON CFM.I_CourseFamily_ID = PC.I_Course_Family_ID
		WHERE PM.S_Product_Name = @sDefaultProduct
		AND CM.I_Brand_ID  =@iBrandID)
	END
	
	IF(@iCenterID = 0)
	BEGIN
		INSERT INTO @tblHD
		SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name 
		FROM dbo.T_Hierarchy_Mapping_Details HMD
		INNER JOIN dbo.T_Hierarchy_Details HD 
		ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
		WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1
	END
	ELSE
	BEGIN
		INSERT INTO @tblHD
		SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name 
		FROM dbo.T_Hierarchy_Mapping_Details HMD
		INNER JOIN dbo.T_Hierarchy_Details HD 
		ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
		WHERE HMD.I_Hierarchy_Detail_ID = @iHierarchyDetailID AND HMD.I_Status = 1
	END

	SELECT * FROM @tblHD

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD)

	WHILE @iCount <= @iRow
	BEGIN
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD WHERE ID = @iCount)
		SET @sHierarchyName = (SELECT S_Hierarchy_Name FROM @tblHD WHERE ID = @iCount)
		SET @iMBPType = (SELECT DISTINCT(I_Type_ID) FROM MBP.T_MBP_Detail 
						 WHERE I_Product_ID = @iProductID
						 AND I_Center_ID IN (SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
						 AND I_Year = @iYear
						 AND I_Month = @iMonth)
		
		IF (@iMBPType = 5)
		BEGIN
		-- Inserting Taget and Actual Values other than Enquiry from Audit table 
		INSERT INTO @tblSUM
		(
			I_Hierarchy_Detail_ID,
			S_Hierarchy_Name,
			I_Product_ID,
			I_Year,
			I_Month,
			I_Target_Enquiry,
			I_Actual_Enquiry,
			I_Target_Booking,
			I_Actual_Booking,
			I_Target_Enrollment,
			I_Actual_Enrollment,
			I_Target_Billing,
			I_Actual_Billing
		)
		SELECT @iHierachyDetailID, 
			   @sHierarchyName, 
			   @iProductID,
			   @iYear,
			   @iMonth,
			   NULL, 
			   NULL,
			   SUM(MDA.I_Target_Booking),
			   SUM(MP.I_Actual_Booking), 
			   SUM(MDA.I_Target_Enrollment), 
			   SUM(MP.I_Actual_Enrollment),
			   SUM(MDA.I_Target_Billing),
			   SUM(MP.I_Actual_Billing)
		FROM MBP.T_MBP_Detail MD
		INNER JOIN MBP.T_MBP_Detail_Audit MDA
		ON MDA.I_MBP_Detail_ID = MD.I_MBP_Detail_ID
		LEFT OUTER JOIN MBP.T_MBPerformance MP
		ON MP.I_Product_ID = MD.I_Product_ID
		AND MP.I_Center_ID = MD.I_Center_ID
		AND MP.I_Year = MD.I_Year
		AND MP.I_Month = MD.I_Month
		WHERE MD.I_Product_ID = ISNULL(@iProductID,MD.I_Product_ID)
		AND MD.I_Year = @iYear
		AND MD.I_Month = @iMonth
		AND MD.I_Center_ID IN
		(SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
		AND MD.I_Status_ID = 1
		AND MDA.I_Status_ID = 1
		
		INSERT INTO @tblEnquirySum
		(
			I_Hierarchy_Detail_ID,
			I_Year,
			I_Month,
			I_Target_Enquiry,
			I_Actual_Enquiry
		)
		SELECT @iHierachyDetailID,
			   @iYear,
			   @iMonth,
			   SUM(MD.I_Target_Enquiry),
			   SUM(MP.I_Actual_Enquiry)
		FROM MBP.T_MBP_Detail MD
		--INNER JOIN MBP.T_MBP_Detail_Audit MDA
		--ON MDA.I_MBP_Detail_ID = MD.I_MBP_Detail_ID
		LEFT OUTER JOIN MBP.T_MBPerformance MP
		ON MP.I_Product_ID = MD.I_Product_ID
		AND MP.I_Center_ID = MD.I_Center_ID
		AND MP.I_Year = MD.I_Year
		AND MP.I_Month = MD.I_Month
		WHERE MD.I_Product_ID = ISNULL(@iDefaultProductID,MD.I_Product_ID)
		AND MD.I_Year = @iYear
		AND MD.I_Month = @iMonth
		AND MD.I_Center_ID IN
		(SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
		AND MD.I_Status_ID = 1
		--AND MDA.I_Status_ID = 1 

		--Updating the Enquiry Target and Actual Value from audit table
		UPDATE @tblSUM
		SET I_Target_Enquiry = ES.I_Target_Enquiry,
			I_Actual_Enquiry = ES.I_Actual_Enquiry
		FROM @tblEnquirySum ES
		WHERE ES.I_Hierarchy_Detail_ID = @iHierachyDetailID
		AND ES.I_Year = @iYear
		AND ES.I_Month = @iMonth
		
		END
		ELSE
		BEGIN
		--Inserting Target and Actual Values other than Enquiry from Detail Table
		INSERT INTO @tblSUM
		(
			I_Hierarchy_Detail_ID,
			S_Hierarchy_Name,
			I_Product_ID,
			I_Year,
			I_Month,
			I_Target_Enquiry,
			I_Actual_Enquiry,
			I_Target_Booking,
			I_Actual_Booking,
			I_Target_Enrollment,
			I_Actual_Enrollment,
			I_Target_Billing,
			I_Actual_Billing
		)
		SELECT @iHierachyDetailID, 
			   @sHierarchyName, 
			   @iProductID,
			   @iYear,
			   @iMonth,
			   NULL, 
			   NULL,
			   SUM(MD.I_Target_Booking),
			   SUM(MP.I_Actual_Booking), 
			   SUM(MD.I_Target_Enrollment), 
			   SUM(MP.I_Actual_Enrollment),
			   SUM(MD.I_Target_Billing),
			   SUM(MP.I_Actual_Billing)
		FROM MBP.T_MBP_Detail MD
		LEFT OUTER JOIN MBP.T_MBPerformance MP
		ON MP.I_Product_ID = MD.I_Product_ID
		AND MP.I_Center_ID = MD.I_Center_ID
		AND MP.I_Year = MD.I_Year
		AND MP.I_Month = MD.I_Month
		WHERE MD.I_Product_ID = ISNULL(@iProductID,MD.I_Product_ID)
		AND MD.I_Year = @iYear
		AND MD.I_Month = @iMonth
		AND MD.I_Center_ID IN
		(SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
		AND MD.I_Status_ID = 1

		INSERT INTO @tblEnquirySum
		(
			I_Hierarchy_Detail_ID,
			I_Year,
			I_Month,
			I_Target_Enquiry,
			I_Actual_Enquiry
		)
		SELECT @iHierachyDetailID,
			   @iYear,
			   @iMonth,
			   SUM(MD.I_Target_Enquiry),
			   SUM(MP.I_Actual_Enquiry)
		FROM MBP.T_MBP_Detail MD
		LEFT OUTER JOIN MBP.T_MBPerformance MP
		ON MP.I_Product_ID = MD.I_Product_ID
		AND MP.I_Center_ID = MD.I_Center_ID
		AND MP.I_Year = MD.I_Year
		AND MP.I_Month = MD.I_Month
		WHERE MD.I_Product_ID = ISNULL(@iDefaultProductID,MD.I_Product_ID)
		AND MD.I_Year = @iYear
		AND MD.I_Month = @iMonth
		AND MD.I_Center_ID IN
		(SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
		AND MD.I_Status_ID = 1

		--Updating the Enquiry Target and Actual Value from audit table
		UPDATE @tblSUM
		SET I_Target_Enquiry = ES.I_Target_Enquiry,
			I_Actual_Enquiry = ES.I_Actual_Enquiry
		FROM @tblEnquirySum ES
		WHERE ES.I_Hierarchy_Detail_ID = @iHierachyDetailID
		AND ES.I_Year = @iYear
		AND ES.I_Month = @iMonth

		END

		SET @iCount = @iCount + 1
	END
	SELECT * FROM @tblSUM
	
END
