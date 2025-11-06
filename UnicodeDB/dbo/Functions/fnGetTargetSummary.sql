CREATE FUNCTION [dbo].[fnGetTargetSummary]    
(    
 @iBrandID int,          
 @iHierarchyDetailID int,          
 @iProductID int,          
 @iYear int,          
 @iMonth int,          
 @iCenterID int,          
 @sDefaultProduct varchar(2000) = null,
 @sCurrency varchar(100) 
)    
RETURNS  @TempResult TABLE    
 (     
  I_Hierarchy_Detail_ID int,          
  S_Hierarchy_Name VARCHAR(200),          
  I_Product_ID INT,          
  I_Year INT,          
  I_Month INT,          
  I_Target_Enquiry int,          
  I_Actual_Enquiry int,          
  I_Target_Booking numeric(18,2),          
  I_Actual_Booking numeric(18,2),          
  I_Target_Enrollment int,          
  I_Actual_Enrollment int,          
  I_Target_Billing numeric(18,2),          
  I_Actual_Billing numeric(18,2),      
  I_Target_RFF numeric(18,2),      
  I_Actual_RFF numeric(18,2)  
 )    
 
AS     
BEGIN  
--SET NOCOUNT ON;          
  DECLARE @CenterConversion TABLE   
  ( I_Center_Id int,   
    N_Conversion_Rate numeric(18,2)  
  )         
  DECLARE @tblHD TABLE          
 (          
  ID INT IDENTITY(1,1),          
  I_Hierarchy_Detail_ID int,          
  S_Hierarchy_Name VARCHAR(200)          
 )          
 declare @tblTarget table
(
 I_Hierarchy_Detail_Id int
,I_Target_Enquiry int
,I_Target_Enrollment int
,I_Target_Booking numeric(18,2)
,I_Target_Billing numeric(18,2)
,I_Target_RFF numeric(18,2)
)
declare @tblActual table
(
 I_Hierarchy_Detail_Id int
,I_Actual_Enquiry int
,I_Actual_Enrollment int
,I_Actual_Booking numeric(18,2)
,I_Actual_Billing numeric(18,2)
,I_Actual_RFF numeric(18,2)
) 
 declare @tblTargetNew table
(
 I_Hierarchy_Detail_Id int
,I_Target_Enquiry int
,I_Target_Enrollment int
,I_Target_Booking numeric(18,2)
,I_Target_Billing numeric(18,2)
,I_Target_RFF numeric(18,2)
)
declare @tblActualNew table
(
 I_Hierarchy_Detail_Id int
,I_Actual_Enquiry int
,I_Actual_Enrollment int
,I_Actual_Booking numeric(18,2)
,I_Actual_Billing numeric(18,2)
,I_Actual_RFF numeric(18,2)
)       
 DECLARE @iDefaultProductID INT          
 DECLARE @iCount INT, @iRow INT          
 DECLARE @iHierachyDetailID INT          
 DECLARE @sHierarchyName VARCHAR(200)                
           
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
  AND PM.I_Brand_ID  =@iBrandID
  )          
 END          
  
 IF(@iCenterID = 0)          
 BEGIN          
  INSERT INTO @tblHD          
  SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name           
  FROM dbo.T_Hierarchy_Mapping_Details HMD          
  INNER JOIN dbo.T_Hierarchy_Details HD           
  ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID          
  WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1 AND HD.I_Status = 1         
 END          
 ELSE          
 BEGIN          
  INSERT INTO @tblHD          
  SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name           
  FROM dbo.T_Hierarchy_Mapping_Details HMD          
  INNER JOIN dbo.T_Hierarchy_Details HD           
  ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID          
  WHERE HMD.I_Hierarchy_Detail_ID = @iHierarchyDetailID AND HMD.I_Status = 1 AND HD.I_Status = 1         
 END          
          
 --SELECT * FROM @tblHD          
          
 SET @iCount = 1          
 SET @iRow = (SELECT COUNT(*) FROM @tblHD)          
          
 WHILE @iCount <= @iRow          
 BEGIN 
	--------------------------------------------------------------------------------------         
	SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD WHERE ID = @iCount)          
    --------------------------------------------------------------------------------------    
	INSERT INTO @CenterConversion  
	select CM.I_Centre_Id  
	,CR.N_Conversion_Rate  
	from T_Centre_Master CM  
	inner join dbo.T_Country_Master CMM on CM.I_Country_Id = CMM.I_Country_Id  
	inner join dbo.T_Currency_Rate CR on CMM.I_Currency_Id = CR.I_Currency_Id  
	where CM.I_Status = 1  
	AND CMM.I_Status = 1  
	AND CR.I_Status = 1  
	AND CM.I_Centre_Id in  
	(select * from dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))  
    --------------------------------------------------------------------------------------    
	IF ( @iBrandID <> 55 and @sCurrency <> 'USD')  
	BEGIN  
	 UPDATE @CenterConversion SET N_Conversion_Rate = 1  
	END  
    -------------------------------------------------------------------------------------- 
	DECLARE @cnv_rate int
	SET @cnv_rate = 1
	IF ( @iBrandID <> 55 and @sCurrency = 'USD')  
	BEGIN  
	 SET @cnv_rate = 40
	END 
	-------- Target Records --------------------------------------------------------------- 
		insert into @tblTarget(I_Hierarchy_Detail_Id,I_Target_Enquiry,I_Target_Billing,I_Target_RFF)
		select
		 @iHierachyDetailID 
		,sum(MD.I_Target_Enquiry)
		,sum(MD.I_Target_Billing/@cnv_rate)
		,sum(MD.I_Target_RFF/@cnv_rate)
--		,sum(MD.I_Target_Billing/CC.N_Conversion_Rate)  -- target billing is uploaded in USD
--		,sum(MD.I_Target_RFF/CC.N_Conversion_Rate)		-- target Company Share is uploaded in USD
		From MBP.T_MBP_Detail MD
--		inner join @CenterConversion CC on CC.I_Center_Id = MD.I_Center_Id
		where MD.I_Product_Id = @iDefaultProductID
		and MD.I_Year = @iYear
		and MD.I_Month = @iMonth
		and MD.I_Center_Id in
		(
			SELECT * FROM 
			dbo.fnGetCenterIDFromHierarchy
			(@iHierachyDetailID,@iBrandID)  
		)

		insert into @tblTarget(I_Hierarchy_Detail_Id, I_Target_Enrollment,I_Target_Booking) 
		select
		 @iHierachyDetailID 
		,sum(MD.I_Target_Enrollment)
		,sum(MD.I_Target_Booking/@cnv_rate)	-- target booking is uploaded in USD
--		,sum(MD.I_Target_Booking/CC.N_Conversion_Rate)
		From MBP.T_MBP_Detail MD
--		inner join @CenterConversion CC on CC.I_Center_Id = MD.I_Center_Id
		where MD.I_Product_Id = @iProductID
		and MD.I_Year = @iYear
		and MD.I_Month = @iMonth
		and MD.I_Center_Id in
		(
			SELECT * FROM 
			dbo.fnGetCenterIDFromHierarchy
			(@iHierachyDetailID,@iBrandID)  
		)     
	-------- Actual Records ---------------------------------------------------------------
		insert into @tblActual(I_Hierarchy_Detail_Id,I_Actual_Enrollment,I_Actual_Booking)
		select
		 @iHierachyDetailID 		
		,sum(MP.I_Actual_Enrollment)
		,sum(MP.I_Actual_Booking/CC.N_Conversion_Rate)		
		From MBP.T_MBPerformance MP
		inner join @CenterConversion CC on CC.I_Center_Id = MP.I_Center_Id
		where MP.I_Product_Id = @iProductID
		and MP.I_Year = @iYear
		and MP.I_Month = @iMonth
		and MP.I_Center_Id in
		(
			SELECT * FROM 
			dbo.fnGetCenterIDFromHierarchy
			(@iHierachyDetailID,@iBrandID)  
		)

		insert into @tblActual(I_Hierarchy_Detail_Id, I_Actual_Enquiry, I_Actual_Billing, I_Actual_RFF) 
		select
			@iHierachyDetailID
			,sum(MP.I_Actual_Enquiry)
			,sum(MP.I_Actual_Billing/CC.N_Conversion_Rate)
			,sum(I_Actual_RFF/CC.N_Conversion_Rate)
		From MBP.T_MBPerformance MP
		inner join @CenterConversion CC on CC.I_Center_Id = MP.I_Center_Id
		where MP.I_Product_Id = @iDefaultProductID
		and MP.I_Year = @iYear
		and MP.I_Month = @iMonth
		and MP.I_Center_Id in
		(
			SELECT * FROM 
			dbo.fnGetCenterIDFromHierarchy
			(@iHierachyDetailID,@iBrandID)  
		)

	SET @iCount = @iCount + 1          
 END 
         
--select * From @tblTarget
--select * From @tblActual
	---------------------------------------------------------------------------------------
	insert into @tblTargetNew
	select I_Hierarchy_Detail_Id
		,sum(I_Target_Enquiry)
		,sum(I_Target_Enrollment)
		,sum(I_Target_Booking)
		,sum(I_Target_Billing)
		,sum(I_Target_RFF) 
	from @tblTarget group by I_Hierarchy_Detail_Id

	insert into @tblActualNew
	select I_Hierarchy_Detail_Id
		,sum(I_Actual_Enquiry)
		,sum(I_Actual_Enrollment)
		,sum(I_Actual_Booking)
		,sum(I_Actual_Billing)
		,sum(I_Actual_RFF) 
	from @tblActual group by I_Hierarchy_Detail_Id
	---------------------------------------------------------------------------------------
--select * From @tblTargetNew
--select * From @tblActualNew
INSERT INTO @TempResult
select 
HD.I_Hierarchy_Detail_Id
,HD.S_Hierarchy_Name
,@iProductID
,@iYear
,@iMonth
,TN.I_Target_Enquiry
,TA.I_Actual_Enquiry
,TN.I_Target_Booking
,TA.I_Actual_Booking
,TN.I_Target_Enrollment
,TA.I_Actual_Enrollment
,TN.I_Target_Billing
,TA.I_Actual_Billing
,TN.I_Target_RFF
,TA.I_Actual_RFF

from @tblHD HD
inner join @tblTargetNew TN on HD.I_Hierarchy_Detail_Id = TN.I_Hierarchy_Detail_Id
inner join @tblActualNew TA on TN.I_Hierarchy_Detail_Id = TA.I_Hierarchy_Detail_Id
RETURN ;   
END