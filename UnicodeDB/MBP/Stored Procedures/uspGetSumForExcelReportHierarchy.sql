--------------------------------------

CREATE PROCEDURE [MBP].[uspGetSumForExcelReportHierarchy] 
(	
	@iBrandID int,
	@iHierarchyDetailID int,
	@iYear int,
	@iBPType int = NULL --used as iCenterID
)
AS
BEGIN
DECLARE @tblHD TABLE
		(
			ID INT IDENTITY(1,1),
			I_Hierarchy_Detail_ID int,
			S_Hierarchy_Name VARCHAR(200)			
		)	
		INSERT INTO @tblHD
		SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name
		FROM dbo.T_Hierarchy_Mapping_Details HMD
		INNER JOIN dbo.T_Hierarchy_Details HD 
		ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
		WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1


	DECLARE @tblCenter TABLE
	(
		ID INT IDENTITY(1,1),
		I_Center_ID int,	
		S_Hierarchy_Name VARCHAR(200),
		I_Hierarchy_Detail_ID VARCHAR(200)
	)

	SELECT * FROM @tblHD

	DECLARE @iCount INT, @iRow INT
	DECLARE @iHierachyDetailID INT
	DECLARE @sHierarchyName VARCHAR(200)

	--INSERT INTO @tblCenter
	--SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierarchyDetailID,@iBrandID)	

DECLARE @sSearchCriteria varchar(20)
	

SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD)	
	WHILE @iCount <= @iRow
	BEGIN
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD WHERE ID = @iCount)						
		SET @sHierarchyName = (SELECT S_Hierarchy_Name FROM @tblHD WHERE ID = @iCount)

		SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iHierachyDetailID  

			INSERT INTO @tblCenter
				SELECT TCHD.I_Center_Id,@sHierarchyName,@iHierachyDetailID FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE
				TCHD.I_Hierarchy_Detail_ID IN 
			   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
				WHERE I_Status = 1
				AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
				AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
				AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
				TBCD.I_Brand_ID=@iBrandId AND
				TBCD.I_Centre_Id = TCHD.I_Center_Id 
	
	SET @iCount = @iCount + 1
	END

--SELECT * FROM @tblCenter --COMMENT THIS CODE


--============================
BEGIN
DECLARE @CenterName VARCHAR(200)
DECLARE @sHierachyChains VARCHAR(200)
DECLARE @iRowCount INT
DECLARE @iRowCount1 INT
DECLARE @iRowCount2 INT
DECLARE @iRowCount3 INT
DECLARE @iCounter INT
DECLARE @Hierarchy_ID INT
DECLARE @Hierarchy_Name VARCHAR(200)
SET @iRowCount=0;
SET @iRowCount1=0;
SET @iRowCount2=0;
SET @iRowCount3=0;
SET @iCounter=0;

DECLARE @MSG VARCHAR(200)



SET @iHierachyDetailID = @iHierarchyDetailID
DECLARE @tblHDW TABLE
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

	INSERT INTO @tblHDW
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
		I_Parent_ID INT,
		Hierarchy_ID INT,
		Hierarchy_Name VARCHAR(200)	
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHDW)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHDW WHERE ID = @iCount)	
		SET @Hierarchy_ID = (SELECT I_Hierarchy_Detail_ID FROM @tblHDW WHERE ID = @iCount)						
		SET @Hierarchy_Name = (SELECT S_Hierarchy_Name FROM @tblHDW WHERE ID = @iCount)						
		INSERT INTO @tblHD1	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID,
			@Hierarchy_ID,
			@Hierarchy_Name
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
		I_Parent_ID INT,
		Hierarchy_ID INT,	
		Hierarchy_Name VARCHAR(200)		
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD1)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD1 WHERE ID = @iCount)	
		SET @Hierarchy_ID = (SELECT Hierarchy_ID FROM @tblHD1 WHERE ID = @iCount)
		SET @Hierarchy_Name = (SELECT Hierarchy_Name FROM @tblHD1 WHERE ID = @iCount)							
		INSERT INTO @tblHD2	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID,
			@Hierarchy_ID,
			@Hierarchy_Name
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
		I_Parent_ID INT,
		Hierarchy_ID INT,
		Hierarchy_Name VARCHAR(200)		
	)	

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD2)
	WHILE @iCount <= @iRow
	BEGIN
		
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD2 WHERE ID = @iCount)	
		SET @Hierarchy_ID = (SELECT Hierarchy_ID FROM @tblHD2 WHERE ID = @iCount)
		SET @Hierarchy_Name = (SELECT Hierarchy_Name FROM @tblHD2 WHERE ID = @iCount)		
				
		INSERT INTO @tblHD3	
			SELECT	HMD.I_Hierarchy_Detail_ID,
			HD.S_Hierarchy_Name,
			HMD.S_Hierarchy_Chain,
			HMD.S_Hierarchy_Level_Chain,
			HD.I_Hierarchy_Level_Id,
			HD.I_Hierarchy_Master_ID,
			HD.I_Status,
			HMD.I_Parent_ID,
			@Hierarchy_ID,
			@Hierarchy_Name
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID

	WHERE HMD.I_Parent_ID =@iHierachyDetailID AND HMD.I_Status = 1

	SET @iCount = @iCount + 1
	END

SET @iRowCount =(SELECT COUNT(*) FROM @tblHDW)
IF @iRowCount > 0
BEGIN
UPDATE @tblHDW
SET I_Hierarchy_Detail_ID = CONVERT(VARCHAR(50),I_Hierarchy_Detail_ID)--+'01'
--select * from @tblHDW
SET @iCounter= 0;
END

SET @iRowCount1 =(SELECT COUNT(*) FROM @tblHD1)
IF @iRowCount1 > 0
BEGIN
--select * from @tblHD1
SET @iCounter= 1;
END

SET @iRowCount2 =(SELECT COUNT(*) FROM @tblHD2)
IF @iRowCount2 > 0
BEGIN
SET @iCounter= 2;
--select * from @tblHD2
END

SET @iRowCount3 =(SELECT COUNT(*) FROM @tblHD3)
IF @iRowCount3 > 0
BEGIN
--select * from @tblHD3
SET @iCounter= 3;
END


DECLARE @tblCenterArea TABLE
	(
		ID INT IDENTITY(1,1),
		I_Center_ID INT,		
		S_Hierarchy_Name VARCHAR(200),
		I_Hierarchy_Detail_ID INT
		
	)


IF @iCounter = 3
BEGIN
INSERT INTO @tblCenterArea
SELECT DISTINCT CONVERT(VARCHAR(50),tblHD2.I_Hierarchy_Detail_ID)+'01',tblHD2.Hierarchy_Name,tblHD2.Hierarchy_ID
FROM @tblHD2 tblHD2
--INNER JOIN MBP.T_MBP_Detail MD 
--ON MD.I_Center_ID = tblHD2.I_Hierarchy_Detail_ID

END

IF @iCounter = 2
BEGIN
INSERT INTO @tblCenterArea
SELECT DISTINCT CONVERT(VARCHAR(50),tblHD1.I_Hierarchy_Detail_ID)+'01',tblHD1.Hierarchy_Name,tblHD1.Hierarchy_ID
FROM @tblHD1 tblHD1
--INNER JOIN MBP.T_MBP_Detail MD 
--ON MD.I_Center_ID = tblHD1.I_Hierarchy_Detail_ID
END

IF @iCounter = 1
BEGIN
INSERT INTO @tblCenterArea
SELECT DISTINCT CONVERT(VARCHAR(50),tblHDW.I_Hierarchy_Detail_ID)+'01' ,tblHDW.S_Hierarchy_Name,tblHDW.I_Hierarchy_Detail_ID
FROM @tblHDW tblHDW
--INNER JOIN MBP.T_MBP_Detail MD 
--ON MD.I_Center_ID = tblHDW.I_Hierarchy_Detail_ID
END


--SELECT * FROM @tblCenterArea

END
--=============



INSERT INTO @tblCenter
SELECT DISTINCT tblCenterArea.I_Center_ID,tblCenterArea.S_Hierarchy_Name,tblCenterArea.I_Hierarchy_Detail_ID
FROM @tblCenterArea tblCenterArea
				

--SELECT * FROM @tblCenter
--ORDER BY I_Hierarchy_Detail_ID

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
		SET @sCenterHierarchyID = (SELECT I_Hierarchy_Detail_ID FROM @tblCenter WHERE ID = @iCount2)


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
		--I_Month,SUM(I_Target_Enquiry) AS I_Target_Enquiry,SUM(I_Target_Booking) AS I_Target_Booking,SUM(I_Target_Enrollment)AS I_Target_Enrollment,SUM(I_Target_Billing) as I_Target_Billing,SUM(I_Target_RFF) AS I_Target_RFF
		I_Month,I_Target_Enquiry,I_Target_Booking,I_Target_Enrollment,I_Target_Billing,I_Target_RFF
		,@sCenterHierarchyID
		FROM MBP.T_MBP_Detail MD		
		WHERE MD.I_Month =@iCount1
		AND MD.I_Year = @iYear 
		AND	MD.I_Center_ID = @iCenterID --IN (SELECT I_Center_ID FROM @tblCenter)
		--GROUP BY I_Month,I_Hierarchy_Detail_ID,I_Product_ID,I_MBP_Detail_ID,I_Year,I_Status_ID,I_Center_ID
		SET @iCount1 = @iCount1 + 1
END
	
SET @iCount2 = @iCount2 + 1
END
	
SELECT 
		I_Product_ID ,
		I_Hierarchy_Detail_ID ,
		I_Year ,
		I_Status_ID ,
		I_Month ,
		Sum(I_Target_Enquiry) as I_Target_Enquiry ,		
		Sum(I_Target_Booking) as I_Target_Booking ,		
		Sum(I_Target_Enrollment) as I_Target_Enrollment ,		
		Sum(I_Target_Billing) as I_Target_Billing ,
		Sum(I_Target_RFF) as I_Target_RFF,	
		S_Remarks as I_Center_Id FROM @tblSUM
		where S_Remarks = @iBPType
--where S_remarks=259 And I_Product_Id =1
Group By I_Product_ID,
		S_Remarks ,
		I_Month ,        
		I_Hierarchy_Detail_ID ,
		I_Year ,
		I_Status_ID Order By I_Product_ID,S_Remarks,I_Month
		
		


	
END
