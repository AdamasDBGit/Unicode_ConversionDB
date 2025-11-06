CREATE PROCEDURE [CORPORATE].[uspGetCourseFeePlanDetails] --'2481,2482' 
 (
  -- Add the parameters for the stored procedure here    
   @sCourseIDs VARCHAR(MAX)    
 )
 AS    
BEGIN    
  -- SET NOCOUNT ON added to prevent extra result sets from    
  -- interfering with SELECT statements.    
  SET NOCOUNT OFF    
  
  --DECLARE @sCenterName VARCHAR(MAX)
  --dbo.fnString2Rows(
  --SELECT * FROM dbo.fnString2Rows(@sCourseIDs,',') AS fsr
  
 SELECT TCDM.I_Course_ID ,
S_Course_Name,
TCDM.I_Delivery_Pattern_ID ,
TDPM.S_Pattern_Name,
TDPM.S_DaysOfWeek,
I_Course_Fee_Plan_ID ,
S_Fee_Plan_Name ,
I_Currency_ID ,
N_TotalLumpSum ,
N_TotalInstallment
FROM dbo.T_Course_Delivery_Map AS TCDM
INNER JOIN dbo.T_Course_Fee_Plan AS TCFP
ON TCDM.I_Course_Delivery_ID = TCFP.I_Course_Delivery_ID
INNER JOIN dbo.T_Course_Master AS TCM
ON TCFP.I_Course_ID = TCM.I_Course_ID
INNER JOIN dbo.T_Delivery_Pattern_Master AS TDPM
ON TCDM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
WHERE TCDM.I_Status = 1
AND TCFP.I_Status = 1
AND TDPM.I_Status = 1
AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
AND TCDM.I_Course_ID IN (SELECT * FROM dbo.fnString2Rows(@sCourseIDs,','))

END
