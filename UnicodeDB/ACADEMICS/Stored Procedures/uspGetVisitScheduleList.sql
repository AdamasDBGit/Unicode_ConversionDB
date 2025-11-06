/*******************************************************
Description : Gets the list of Visitors visiting the Center within the specified Date Range
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetVisitScheduleList]   
( 
 @iHierarchyDetailID int = null, 
 @iBrandID int = null,
 @iCenterID int = null,  
 @dFromDate datetime,  
 @dToDate datetime  
)  
AS  
BEGIN TRY 
IF @iCenterID IS NULL
BEGIN
DECLARE @sSearchCriteria VARCHAR(100)

DECLARE @TempCenter TABLE
( 
	I_Center_ID int
)

SELECT @sSearchCriteria= S_Hierarchy_Chain 
FROM T_Hierarchy_Mapping_Details 
WHERE I_Hierarchy_detail_id = @iHierarchyDetailID  

IF @iBrandID = 0 
	BEGIN
		INSERT INTO @TempCenter 
		SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
		TCHD.I_Hierarchy_Detail_ID IN 
		(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
		WHERE I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%'
		) 
	END
ELSE
	BEGIN
		INSERT INTO @TempCenter 
		SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD 
		WHERE TBCD.I_Brand_ID= @iBrandID 
		AND TBCD.I_Centre_Id = TCHD.I_Center_Id 
		AND TCHD.I_Hierarchy_Detail_ID IN 
	   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
		WHERE I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%'
		) 
					 
	END 

  SELECT A.I_Center_Id,  
   A.I_User_ID,  
   A.I_Academics_Visit_ID,   
   A.Dt_Planned_Visit_From_Date,   
   A.Dt_Planned_Visit_To_Date,  
   A.Dt_Actual_Visit_From_Date,  
   A.Dt_Actual_Visit_To_Date,  
   A.S_Remarks,  
   A.S_Purpose,  
   A.I_Status,  
   A.C_Academic_Parameter,  
   A.C_Faculty_Approval,  
   A.C_Infrastructure,  
   A.S_Crtd_By,  
   A.Dt_Crtd_On,  
   U.S_Login_ID,  
   U.S_Title,  
   U.S_First_Name,  
   U.S_Middle_Name,  
   U.S_Last_Name,  
   U.S_Email_ID,  
   U.S_Forget_Pwd_Answer,  
   U.Dt_Crtd_On  
 FROM dbo.T_User_Master U, ACADEMICS.T_Academics_Visit A  
 WHERE A.I_User_ID = U.I_User_ID  
 AND A.Dt_Planned_Visit_From_Date >= @dFromDate  
 AND A.Dt_Planned_Visit_To_Date <= @dToDate  
 AND A.I_Center_Id in ( select I_Center_ID from   @TempCenter)
 AND U.I_Status = 1   
 ORDER BY A.Dt_Planned_Visit_From_Date DESC 
END
ELSE
BEGIN
SELECT A.I_Center_Id,  
   A.I_User_ID,  
   A.I_Academics_Visit_ID,   
   A.Dt_Planned_Visit_From_Date,   
   A.Dt_Planned_Visit_To_Date,  
   A.Dt_Actual_Visit_From_Date,  
   A.Dt_Actual_Visit_To_Date,  
   A.S_Remarks,  
   A.S_Purpose,  
   A.I_Status,  
   A.C_Academic_Parameter,  
   A.C_Faculty_Approval,  
   A.C_Infrastructure,  
   A.S_Crtd_By,  
   A.Dt_Crtd_On,  
   U.S_Login_ID,  
   U.S_Title,  
   U.S_First_Name,  
   U.S_Middle_Name,  
   U.S_Last_Name,  
   U.S_Email_ID,  
   U.S_Forget_Pwd_Answer,  
   U.Dt_Crtd_On  
 FROM dbo.T_User_Master U, ACADEMICS.T_Academics_Visit A  
 WHERE A.I_User_ID = U.I_User_ID  
 AND A.Dt_Planned_Visit_From_Date >= @dFromDate  
 AND A.Dt_Planned_Visit_To_Date <= @dToDate  
 AND A.I_Center_Id = @iCenterID
 AND U.I_Status = 1   
 ORDER BY A.Dt_Planned_Visit_From_Date DESC 	
END 
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
