CREATE PROCEDURE [MBP].[uspGetSumForExcelReportHierarchyNewCenter]
(	
	@iBrandID int,
	@iHierarchyDetailID int,
	@iYear int	
)
AS
BEGIN
DECLARE @iCount INT, @iRow INT
DECLARE @iHierachyDetailID INT
DECLARE @CenterName VARCHAR(200)
DECLARE @sHierachyChains VARCHAR(200)
DECLARE @iRowCount INT
DECLARE @iRowCount1 INT
DECLARE @iRowCount2 INT
DECLARE @iRowCount3 INT
DECLARE @iCounter INT
SET @iRowCount=0;
SET @iRowCount1=0;
SET @iRowCount2=0;
SET @iRowCount3=0;
SET @iCounter=0;

DECLARE @MSG VARCHAR(200)

SET @iHierachyDetailID = @iHierarchyDetailID
DECLARE @tblHD TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,	
		S_Hierarchy_Name VARCHAR(200),
		S_Hierarchy_Chain VARCHAR(200),	
		S_Hierarchy_Level_Chain VARCHAR(200),
		I_Hierarchy_Level_Id int,
		I_Hierarchy_Master_ID int,
		I_Status VARCHAR(2),
		I_Parent_ID INT			
	)

	INSERT INTO @tblHD
	SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
	WHERE HMD.I_Parent_ID = @iHierachyDetailID AND HMD.I_Status = 1


	DECLARE @tblHD1 TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,	
		S_Hierarchy_Name VARCHAR(200),
		S_Hierarchy_Chain VARCHAR(200),	
		S_Hierarchy_Level_Chain VARCHAR(200),
		I_Hierarchy_Level_Id int,
		I_Hierarchy_Master_ID int,
		I_Status VARCHAR(2),
		I_Parent_ID INT			
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD WHERE ID = @iCount)						
		INSERT INTO @tblHD1	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID

	WHERE HMD.I_Parent_ID =@iHierachyDetailID AND HMD.I_Status = 1

	SET @iCount = @iCount + 1
	END



	DECLARE @tblHD2 TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,	
		S_Hierarchy_Name VARCHAR(200),
		S_Hierarchy_Chain VARCHAR(200),	
		S_Hierarchy_Level_Chain VARCHAR(200),
		I_Hierarchy_Level_Id int,
		I_Hierarchy_Master_ID int,
		I_Status VARCHAR(2),
		I_Parent_ID INT			
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD1)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD1 WHERE ID = @iCount)						
		INSERT INTO @tblHD2	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID

	WHERE HMD.I_Parent_ID =@iHierachyDetailID AND HMD.I_Status = 1

	SET @iCount = @iCount + 1
	END

DECLARE @tblHD3 TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,	
		S_Hierarchy_Name VARCHAR(200),
		S_Hierarchy_Chain VARCHAR(200),	
		S_Hierarchy_Level_Chain VARCHAR(200),
		I_Hierarchy_Level_Id int,
		I_Hierarchy_Master_ID int,
		I_Status VARCHAR(2),
		I_Parent_ID INT			
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD2)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD2 WHERE ID = @iCount)						
		INSERT INTO @tblHD3	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID

	WHERE HMD.I_Parent_ID =@iHierachyDetailID AND HMD.I_Status = 1

	SET @iCount = @iCount + 1
	END



SET @iRowCount =(SELECT COUNT(*) FROM @tblHD)
IF @iRowCount > 0
BEGIN
UPDATE @tblHD
SET I_Hierarchy_Detail_ID = CONVERT(VARCHAR(50),I_Hierarchy_Detail_ID)+'01'
--select * from @tblHD
SET @iCounter= 0;
END

SET @iRowCount1 =(SELECT COUNT(*) FROM @tblHD1)
IF @iRowCount1 > 0
BEGIN
UPDATE @tblHD1
SET I_Hierarchy_Detail_ID = CONVERT(VARCHAR(50),I_Hierarchy_Detail_ID)+'01'
--select * from @tblHD1
SET @iCounter= 1;
END

SET @iRowCount2 =(SELECT COUNT(*) FROM @tblHD2)
IF @iRowCount2 > 0
BEGIN
SET @iCounter= 2;
UPDATE @tblHD2
SET I_Hierarchy_Detail_ID = CONVERT(VARCHAR(50),I_Hierarchy_Detail_ID)+'01'
--select * from @tblHD2
END

SET @iRowCount3 =(SELECT COUNT(*) FROM @tblHD3)
IF @iRowCount3 > 0
BEGIN
UPDATE @tblHD3
SET I_Hierarchy_Detail_ID = CONVERT(VARCHAR(50),I_Hierarchy_Detail_ID)+'01'
--select * from @tblHD3
SET @iCounter= 3;
END

--SELECT @iCounter




DECLARE @tblCenter TABLE
	(
		ID INT IDENTITY(1,1),
		I_Center_ID int,	
		S_Hierarchy_Name VARCHAR(200)
	)


IF @iCounter = 3
BEGIN
INSERT INTO @tblCenter
SELECT DISTINCT MD.I_Center_ID,S_Hierarchy_Name 
FROM @tblHD2 tblHD2
INNER JOIN MBP.T_MBP_Detail MD 
ON MD.I_Center_ID = tblHD2.I_Hierarchy_Detail_ID

END

IF @iCounter = 2
BEGIN
INSERT INTO @tblCenter
SELECT DISTINCT MD.I_Center_ID,S_Hierarchy_Name 
FROM @tblHD1 tblHD1
INNER JOIN MBP.T_MBP_Detail MD 
ON MD.I_Center_ID = tblHD1.I_Hierarchy_Detail_ID
END

IF @iCounter = 1
BEGIN
INSERT INTO @tblCenter
SELECT DISTINCT MD.I_Center_ID,S_Hierarchy_Name 
FROM @tblHD tblHD
INNER JOIN MBP.T_MBP_Detail MD 
ON MD.I_Center_ID = tblHD.I_Hierarchy_Detail_ID
END


	
SELECT * FROM @tblCenter



DECLARE @tblSum TABLE
	(
		I_MBP_Detail_ID INT,
		I_Product_ID INT,
		I_Hierarchy_Detail_ID INT,
		I_Center_ID INT,
		I_Year INT,
		I_Status_ID INT,
		I_Month INT,
		I_Target_Enquiry INT,		
		I_Target_Booking INT,		
		I_Target_Enrollment INT,		
		I_Target_Billing INT,
		I_Target_RFF INT,	
		S_Remarks VARCHAR(200)	
	)



	DECLARE @iCount2 INT, @iRow2 INT
	DECLARE @iCenterID INT
	DECLARE @sCenterHierarchyID VARCHAR(200)

SET @iCount2 = 1
	SET @iRow2 = (SELECT COUNT(*) FROM @tblCenter)	
	WHILE @iCount2 <= @iRow2
	BEGIN

		SET @iCenterID = (SELECT I_Center_ID FROM @tblCenter WHERE ID = @iCount2)						
		


DECLARE @iCount1 INT
SET @iCount1 = 1
	
	WHILE @iCount1 <= 12
	BEGIN
		
		INSERT INTO @tblSUM
		(
			I_MBP_Detail_ID ,
			I_Product_ID ,
			I_Hierarchy_Detail_ID ,
			I_Center_ID ,
			I_Year ,
			I_Status_ID,
			I_Month ,
			I_Target_Enquiry ,		
			I_Target_Booking ,		
			I_Target_Enrollment ,		
			I_Target_Billing ,
			I_Target_RFF,
			S_Remarks	
		)
		SELECT I_MBP_Detail_ID,I_Product_ID,I_Hierarchy_Detail_ID,I_Center_ID,I_Year,I_Status_ID,		
		I_Month,I_Target_Enquiry,I_Target_Booking,I_Target_Enrollment,I_Target_Billing,I_Target_RFF
		,@iHierarchyDetailID
		FROM MBP.T_MBP_Detail MD		
		WHERE MD.I_Month =@iCount1
		AND MD.I_Year = @iYear 
		AND	MD.I_Center_ID = @iCenterID 		
		SET @iCount1 = @iCount1 + 1
END
	
SET @iCount2 = @iCount2 + 1
END
	
SELECT 
		I_Product_ID ,
		I_Hierarchy_Detail_ID ,
		--I_Center_Id,
		I_Year ,
		I_Status_ID ,
		I_Month ,
		Sum(I_Target_Enquiry) as I_Target_Enquiry ,		
		Sum(I_Target_Booking) as I_Target_Booking ,		
		Sum(I_Target_Enrollment) as I_Target_Enrollment ,		
		Sum(I_Target_Billing) as I_Target_Billing ,
		Sum(I_Target_RFF) as I_Target_RFF,
		S_Remarks as I_Center_Id
		FROM @tblSUM
Group By I_Product_ID,
		S_Remarks ,
		I_Month ,        
		I_Hierarchy_Detail_ID ,
		I_Year ,
		I_Status_ID Order By I_Product_ID,S_Remarks,I_Month	
END
