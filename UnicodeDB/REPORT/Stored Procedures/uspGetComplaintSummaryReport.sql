/*
-- =================================================================
-- Author: Shankha Roy
-- Create date: 13/07/2007 
-- Description: This sp used  Query Detailed Summary Reports of Customer care
-- Returns : DataSet
-- =================================================================
*/

CREATE PROCEDURE [REPORT].[uspGetComplaintSummaryReport]
(
	@iBrandID		INT		,
	@sHierarchyList 	varchar(MAX)	,
	@DtFrmDate		DATETIME=NULL	
	--@DtToDate		DATETIME=NULL	

)
AS
BEGIN TRY
	
DECLARE @VarType VARCHAR(50)
DECLARE @sVar VARCHAR(100)
DECLARE @tempTable TABLE
(
Topic VARCHAR (100),
TopicValue INT,
CenterName VARCHAR(250),
InstanceChain  VARCHAR(300),
Brand VARCHAR(100),
VARTYPE VARCHAR(50)
)

--Opening Balance - Beginning of the week
--No. of complaints recd for the Week
--No. of complaints redressed for the Week
--NO of Complaints Classified as suspended
--No. of complaints pending [Last day of the week]
--Complaints pending for over 14 days
--Complaints pending for over 7 days


DECLARE @OpeningBalance INT
DECLARE @ComplaintRecd INT
DECLARE @ComplaintsRedressed INT
DECLARE @ComplaintSuspended INT
DECLARE @PendingBalanceWeek INT
DECLARE @ComplaintsPending7 INT
DECLARE @ComplaintsPending14 INT
DECLARE @sChain VARCHAR(200)
DECLARE @sBrand VARCHAR(50)

DECLARE @dtCalculate DATETIME
DECLARE @dtCalculateEnd DATETIME

DECLARE @iCount1 INT
DECLARE @iCount2 INT
DECLARE @Total INT


--SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)

SET @sChain =( SELECT instanceChain FROM dbo.fnGetInstanceNameChainForReports (@sHierarchyList,@iBrandID))
SET @sBrand = (SELECT S_Brand_Code FROM dbo.T_Brand_Master WHERE I_Brand_ID = @iBrandID)
--Opening Balance - Beginning of the week


SET @dtCalculate = DATEADD(dd,-7,@DtFrmDate)

-- Count from Audit Table 
SET @iCount1 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate and I_Status_ID NOT IN (6,7,10)
AND I_Complaint_Audit_ID IN(select MAX(I_Complaint_Audit_ID) from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
GROUP BY I_Complaint_Req_ID )
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
AND I_Complaint_Req_ID NOT IN (
select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
))
-- Count in Complaint Current table 
SET @iCount2 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
)

SET @OpeningBalance = @iCount1 +@iCount2

IF(@OpeningBalance IS NULL)
BEGIN
	SET @OpeningBalance =0
END



SET @sVar = 'Opening Balance - Beginning of the week'--'OpeningBalance'
SET @VarType = 'Query' 
INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@OpeningBalance,@sChain,@sBrand,@VarType

--No. of complaints recd for the Week


IF EXISTS(SELECT COUNT(CRD.I_Complaint_Req_ID) AS ComplaintRecd	
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
	AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
) )
BEGIN
 SET @ComplaintRecd=(SELECT COUNT(CRD.I_Complaint_Req_ID) AS ComplaintRecd	
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
    AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
))
END
ELSE
BEGIN
	SET @ComplaintRecd=0
END
SET @sVar ='No. of Complaints received for the Week'
SET @VarType = 'Query' 
INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@ComplaintRecd,@sChain,@sBrand,@VarType


--No. of complaints redressed for the Week


	IF EXISTS(SELECT 
	COUNT(CRD.I_Complaint_Req_ID) AS ComplaintsRedressed
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	INNER JOIN dbo.T_Status_Master SM
	ON SM.I_Status_Value = CRD.I_Status_ID
	AND SM.S_Status_Type = 'CustomerCareStatus'	
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<=7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
	AND( SM.S_Status_Desc= 'ClosedByStudent' OR SM.S_Status_Desc='ClosedByCustomerCare')
    AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
))
	BEGIN
		SET	@ComplaintsRedressed=(SELECT 
		COUNT(CRD.I_Complaint_Req_ID) AS ComplaintsRedressed
		FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
		INNER JOIN dbo.T_Status_Master SM
		ON SM.I_Status_Value = CRD.I_Status_ID
		AND SM.S_Status_Type = 'CustomerCareStatus'	
		WHERE
		(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<=7
		AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
		AND( SM.S_Status_Desc= 'ClosedByStudent' OR SM.S_Status_Desc='ClosedByCustomerCare')
		AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
))
	END
	ELSE
	BEGIN
	 SET @ComplaintsRedressed=0 
	END 
SET @sVar ='No. of Complaints redressed for the Week'
SET @VarType = 'Query' 

INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@ComplaintsRedressed,@sChain,@sBrand,@VarType

--NO of Complaints Classified as suspended
IF EXISTS(SELECT 	COUNT(CRD.I_Complaint_Req_ID) AS ComplaintSuspended	
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	LEFT OUTER JOIN dbo.T_Status_Master SM
	ON SM.I_Status_Value = CRD.I_Status_ID
	AND SM.S_Status_Type = 'CustomerCareStatus'	
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
	AND SM.S_Status_Desc= 'Suspended' 
	AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
) )
  BEGIN
	SET @ComplaintSuspended=(SELECT 	COUNT(CRD.I_Complaint_Req_ID) AS ComplaintSuspended	
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	LEFT OUTER JOIN dbo.T_Status_Master SM
	ON SM.I_Status_Value = CRD.I_Status_ID
	AND SM.S_Status_Type = 'CustomerCareStatus'	
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
	AND SM.S_Status_Desc= 'Suspended' 
	AND CRD.I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID)
))
  END
	ELSE
	BEGIN
		SET @ComplaintSuspended=0
	END

SET @sVar ='No. of Complaints Classified as suspended'
SET @VarType = 'Query' 

INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@ComplaintSuspended,@sChain,@sBrand,@VarType

--No. of complaints pending [Last day of the week]
SET @PendingBalanceWeek = ((@OpeningBalance +@ComplaintRecd)-(@ComplaintsRedressed +@ComplaintSuspended))

SET @sVar ='No. of Complaints pending [Last day of the week]'
SET @VarType = 'Query' 

INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@PendingBalanceWeek,@sChain,@sBrand,@VarType

--Complaints pending for over 7 days
-- NEW CODE STRAT --

--------------7 DAYS------------------
SET @iCount1 =0
SET @iCount2 = 0

SET @dtCalculate = DATEADD(dd,-14,@DtFrmDate)
SET @dtCalculateEnd =DATEADD(dd,-21,@DtFrmDate)

SET @iCount1 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate and I_Status_ID NOT IN (6,7,10)
AND Dt_Upd_On >@dtCalculateEnd
AND I_Complaint_Audit_ID IN(select MAX(I_Complaint_Audit_ID) from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
GROUP BY I_Complaint_Req_ID )
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
AND I_Complaint_Req_ID NOT IN (
select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
))

SET @iCount2 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  
AND Dt_Upd_On >@dtCalculateEnd
and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
)

SET @ComplaintsPending7 = @iCount1 +@iCount2

IF(@ComplaintsPending7 IS NULL)
	BEGIN
		SET @ComplaintsPending7 = 0
	END


-- END --


SET @sVar ='Complaints pending for over 7 days'
SET @VarType = 'Query' 
INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@ComplaintsPending7,@sChain,@sBrand,@VarType

--Complaints pending for over 14 days
-------NEW CODE -----

SET @iCount1 =0
SET @iCount2 = 0
SET @dtCalculate = DATEADD(dd,-21,@DtFrmDate)

SET @iCount1 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate and I_Status_ID NOT IN (6,7,10)
AND I_Complaint_Audit_ID IN(select MAX(I_Complaint_Audit_ID) from CUSTOMERCARE.T_Complaint_Audit_Trail 
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
GROUP BY I_Complaint_Req_ID )
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
AND I_Complaint_Req_ID NOT IN (
select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
))

SET @iCount2 =(select COUNT(I_Complaint_Req_ID) AS OPENCurrent from CUSTOMERCARE.T_Complaint_Request_Detail
where Dt_Upd_On <= @dtCalculate  and I_Status_ID NOT IN (6,7,10)
AND I_Center_ID IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@sHierarchyList,@iBrandID))
)

SET @ComplaintsPending14 = @iCount1 +@iCount2

	IF(@ComplaintsPending14 IS NULL)
	BEGIN
		SET @ComplaintsPending14= 0
	END
----END NEW CODE-----

SET @sVar ='Complaints pending for over 14 days'
SET @VarType = 'Query' 

INSERT INTO @tempTable (Topic,TopicValue,InstanceChain,Brand,VARTYPE)
SELECT @sVar,@ComplaintsPending14,@sChain,@sBrand,@VarType


------FOR MODE---------------------
SET @VarType = 'Mode' 
INSERT INTO @tempTable 
SELECT CMM.S_Complaint_Mode_Value,COUNT(CRD.I_Complaint_Req_ID)AS Mode1,
	'' ,
	 @sChain,
	 @sBrand,
	 @VarType
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	INNER JOIN CUSTOMERCARE.T_Complaint_Mode_Master CMM
	ON CMM.I_Complaint_Mode_ID = CRD.I_Complaint_Mode_ID	
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
	ON CRD.I_Center_Id=FN1.CenterID	
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
    GROUP BY CMM.S_Complaint_Mode_Value
--------FRO CATEGORY -----------------

SET @VarType = 'Category'
INSERT INTO @tempTable 
    SELECT CCM.S_Complaint_Desc, COUNT(CRD.I_Complaint_Req_ID)AS Mode1,
	'',
	 @sChain,
	 @sBrand,
	 @VarType
	FROM CUSTOMERCARE.T_Complaint_Request_Detail CRD
	INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM
	ON CCM.I_Complaint_Category_ID = CRD.I_Complaint_Category_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
	ON CRD.I_Center_Id=FN1.CenterID
	WHERE
	(DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate))<= 7
	AND (DATEDIFF(DD,CRD.Dt_Complaint_Date,@DtFrmDate)) > 0
    GROUP BY CCM.S_Complaint_Desc

UPDATE @tempTable SET CenterName = 'CenterName' 

SELECT Topic ,TopicValue ,CenterName ,InstanceChain  ,Brand,VARTYPE  FROM  @tempTable

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
