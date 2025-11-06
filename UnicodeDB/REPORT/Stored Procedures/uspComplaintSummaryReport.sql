/*
-- =================================================================
-- Author: Shankha Roy
-- Create date: 10/07/2007 
-- Description: This sp used Query SummaryDetailed Reports of Customer care
-- Returns : DataSet
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspComplaintSummaryReport]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(MAX)	,
	@iStatus INT =NULL,
	@iRootCauseID INT =NULL,
	@iCategory INT = NULL,
	@DtFrmDate		DATETIME=NULL	,
	@DtToDate		DATETIME=NULL,
	@sStatusName varchar(50)= NULL,
	@sRootCauseName varchar(20) = NULL,
	@sCategoryName varchar(30) = NULL,
	@iDateDiff INT = NULL
)
AS
BEGIN TRY


DECLARE @SQL VARCHAR(8000)
DECLARE @Dynamic VARCHAR(8000)

-- BUILDING THE QUERY FOR DYNAMIC FILTER
SET @SQL ='SELECT DISTINCT CR.I_Complaint_Req_ID,
			CR.S_Complaint_Code	,
			CONVERT(VARCHAR(12),CR.Dt_Complaint_Date,106) AS Dt_Complaint_Date,
			CONVERT(VARCHAR(12),[REPORT].fnGetComplaintLoggedDate(CR.I_Complaint_Req_ID),106) AS LoggedDate,
			CR.I_Complaint_Mode_ID,CM.S_Complaint_Mode_Value,CT.S_Complaint_Desc AS Category,FN1.CenterCode,
			FN1.CenterName,FN2.InstanceChain,TBM.S_Brand_Name AS Product,TBM.S_Brand_Code,
			ISNULL(TUM.S_Login_ID,'+CHAR(39)+' '+CHAR(39)+') AS ProcessOwner,
			ISNULL((TUM.S_Title + '+CHAR(39)+' '+CHAR(39)+'+TUM.S_First_Name + '+CHAR(39)+' '+CHAR(39)+'+TUM.S_Middle_Name+'+CHAR(39)+' '+CHAR(39)+'+TUM.S_Last_Name),'+CHAR(39)+' '+CHAR(39)+') AS UserName,
  			ISNULL(TUM.S_Email_ID, '+CHAR(39)+' '+CHAR(39)+') AS S_Email_ID,
			ISNULL((SD.S_Title + '+CHAR(39)+' '+CHAR(39)+ '+SD.S_First_Name + '+CHAR(39)+' '+CHAR(39)+ '+SD.S_Middle_Name+'+CHAR(39)+' '+CHAR(39)+ '+SD.S_Last_Name),'+CHAR(39)+' '+CHAR(39)+') AS StudentName,
			CR.S_Complaint_Details,	ISNULL(([REPORT].fnGetCycleTimeForCustomerCare(2,CR.I_Status_ID,CR.I_Complaint_Req_ID)),0) AS CycleTimeNew,
			SM.S_Status_Desc AS Status,TCAT1.S_Remarks AS Feedback1,TCAT2.S_Remarks AS Feedback2,TCAT3.S_Remarks AS Feedback3,			
			RCM.S_Root_Cause_Desc AS RootCauseDescripton,RCM.S_Root_Cause_Code AS RootCauseCode	FROM [CUSTOMERCARE].T_Complaint_Request_Detail CR
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail CAR
			ON CR.I_Complaint_Req_ID = CAR.I_Complaint_Req_ID
			AND CAR.I_Status_ID = 2	INNER JOIN 
			[CUSTOMERCARE].T_Complaint_Mode_Master CM
			ON CM.I_Complaint_Mode_ID = CR.I_Complaint_Mode_ID
			INNER JOIN [CUSTOMERCARE].T_Complaint_Category_Master CT
			ON CT.I_Complaint_Category_ID = CR.I_Complaint_Category_ID
				LEFT OUTER JOIN	[CUSTOMERCARE].T_Complaint_Feedback CF
			ON CF.I_Complaint_Req_ID = CR.I_Complaint_Req_ID	INNER JOIN
			[dbo].[fnGetCentersForReports]('+@sHierarchyList+','+ CAST(@iBrandID AS VARCHAR(20)) +') FN1
			ON CR.I_Center_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports]('+@sHierarchyList+','+  CAST(@iBrandID AS VARCHAR(20))+') FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON CR.I_Center_Id=BCD.I_Centre_Id			
			INNER JOIN dbo.T_Brand_Master TBM
			ON BCD.I_Brand_ID = TBM.I_Brand_ID				
			LEFT OUTER JOIN dbo.T_User_Master TUM
			ON TUM.I_User_ID = CR.I_User_ID
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT1
			ON TCAT1.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT1.I_Complaint_Audit_ID = (SELECT MIN(T1.I_Complaint_Audit_ID) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T1 WHERE T1.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T1.I_Status_ID IN(4,12)	AND T1.S_Remarks IS NOT NULL)
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT2
			ON TCAT2.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT2.I_Complaint_Audit_ID = (SELECT (MIN(T2.I_Complaint_Audit_ID)+1) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T2 WHERE T2.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T2.I_Status_ID IN (4,5,10,12) AND T2.S_Remarks IS NOT NULL)
			LEFT OUTER JOIN CUSTOMERCARE.T_Complaint_Audit_Trail TCAT3
			ON TCAT3.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND TCAT3.I_Complaint_Audit_ID = (SELECT (MIN(T3.I_Complaint_Audit_ID)+2) FROM 
			CUSTOMERCARE.T_Complaint_Audit_Trail T3 WHERE T3.I_Complaint_Req_ID = CR.I_Complaint_Req_ID
			AND T3.I_Status_ID IN (5,10,12) AND T3.S_Remarks IS NOT NULL )	
			INNER JOIN dbo.T_Student_Detail SD
			ON SD.I_Student_Detail_ID = CR.I_Student_Detail_ID
			INNER JOIN dbo.T_Status_Master SM
			ON SM.I_Status_Value = CR.I_Status_ID
			AND SM.S_Status_Type = '+CHAR(39)+'CustomerCareStatus'+CHAR(39)+'
			LEFT OUTER JOIN CUSTOMERCARE.T_Root_Cause_Master RCM
			ON RCM.I_Root_Cause_ID = CR.I_Root_Cause_ID
			WHERE CR.I_Status_ID != 0 '	


IF (@iStatus IS NOT NULL)
 BEGIN
	IF(@iStatus = 13)
		BEGIN
			SET @SQL = @SQL + 'AND CR.I_Status_ID NOT IN(6,7)'
		END
	ELSE
		BEGIN
		    SET @SQL = @SQL + 'AND CR.I_Status_ID = '+CAST(@iStatus AS VARCHAR(10))
		END
 END 
IF (@iCategory IS NOT NULL)
	BEGIN
		SET @SQL = @SQL + ' AND CR.I_Complaint_Category_ID = '+CAST(@iCategory AS VARCHAR(10))
	END	   

IF( @iRootCauseID IS NOT NULL OR @iRootCauseID!= 0)
BEGIN	
	SET @SQL=@SQL+' AND CR.I_Root_Cause_ID ='+CAST(@iRootCauseID AS VARCHAR(10))
END
-- THIS CEHCK IF DATE RANGE IS SET OR DATE DIFFERANCE IS CHECK
IF(@iDateDiff IS NOT NULL)
BEGIN
	SET @SQL=@SQL + ' AND DATEDIFF(dd,[REPORT].fnGetComplaintLoggedDate(CR.I_Complaint_Req_ID),GETDATE())<= '+ CAST(@iDateDiff AS VARCHAR(10))
END
ELSE
BEGIN
	SET @SQL=@SQL + ' AND CR.Dt_Complaint_Date BETWEEN '+CHAR(39)+CAST(@DtFrmDate AS VARCHAR(20))+CHAR(39)+' 
    AND '+CHAR(39)+CAST(DATEADD(dd,1,@DtToDate) AS VARCHAR(20))+CHAR(39) 
END

EXEC (@SQL)
		 


END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
