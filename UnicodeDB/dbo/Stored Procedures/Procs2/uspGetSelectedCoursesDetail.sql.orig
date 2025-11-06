CREATE PROCEDURE [dbo].[uspGetSelectedCoursesDetail]  
(  
@sCourseList varchar(100),  
@iCenterID int  
)  
AS  
BEGIN  
  
SELECT  
DISTINCT  
CDF.I_Course_Delivery_ID,  
CDM.I_COURSE_ID,  
CM.S_COURSE_NAME,  
CDM.I_DELIVERY_PATTERN_ID,  
DPM.S_PATTERN_NAME  
FROM  
T_Course_Center_Detail CCD  
INNER JOIN T_Course_Center_Delivery_FeePlan CDF  
ON CCD.I_Course_Center_ID = CDF.I_Course_Center_ID  
INNER JOIN T_COURSE_DELIVERY_MAP CDM  
ON CDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID  
INNER JOIN T_COURSE_MASTER CM  
ON CDM.I_COURSE_ID = CM.I_COURSE_ID  
INNER JOIN T_DELIVERY_PATTERN_MASTER DPM  
ON CDM.I_DELIVERY_PATTERN_ID=DPM.I_DELIVERY_PATTERN_ID  
WHERE CCD.I_Course_ID IN(SELECT * from dbo.fnString2Rows(@sCourseList,','))  
AND CCD.I_Centre_ID = @iCenterID  
--AND CCD.I_Status<>0  
--AND CDF.I_Status<>0  
--AND CDM.I_Status<>0  
  
SELECT  
DISTINCT  
CFP.I_COURSE_DELIVERY_ID,  
CFP.I_COURSE_ID,  
CDM.I_DELIVERY_PATTERN_ID,  
CFP.I_Course_Fee_Plan_ID,  
CFP.S_FEE_PLAN_NAME,  
CFP.C_IS_LUMPSUM,  
CFP.N_TOTALLUMPSUM,  
CFP.N_TOTALINSTALLMENT  
FROM  
T_Course_Center_Detail CCD  
INNER JOIN T_Course_Center_Delivery_FeePlan CDF  
ON CCD.I_Course_Center_ID = CDF.I_Course_Center_ID  
INNER JOIN T_COURSE_DELIVERY_MAP CDM  
ON CDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID  
INNER JOIN T_Course_Fee_Plan CFP  
ON CDF.I_Course_Fee_Plan_ID = CFP.I_Course_Fee_Plan_ID  
WHERE CCD.I_Course_ID IN(SELECT * from dbo.fnString2Rows(@sCourseList,','))  
AND CCD.I_Centre_ID = @iCenterID  
--AND CCD.I_Status<>0  
--AND CDF.I_Status<>0  
--AND CDM.I_Status<>0  
--AND CFP.I_Status<>0  
--AND GETDATE() >= ISNULL(CDF.Dt_Valid_From, GETDATE())  
--AND GETDATE() <= ISNULL(CDF.Dt_Valid_To, GETDATE())  
  
  
SELECT COU.I_Currency_ID  
FROM dbo.T_Country_Master COU  
INNER JOIN dbo.T_Centre_Master CM  
ON CM.I_Country_ID = COU.I_Country_ID  
WHERE CM.I_Centre_Id = @iCenterID  
  
END
