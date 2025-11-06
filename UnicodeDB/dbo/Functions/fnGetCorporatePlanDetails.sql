CREATE FUNCTION [dbo].[fnGetCorporatePlanDetails]  
(  
	@I_Center_Corp_Plan_ID INT  
)  
RETURNS VARCHAR(MAX)  
AS  
BEGIN  
 DECLARE @nDetailsXML VARCHAR(MAX)  
  
 SET @nDetailsXML  = (SELECT	I_Center_Corp_Plan_Detail_ID,
		  I_Min_Students,
		  I_Max_Students,
		  Discount FROM dbo.T_Center_Corporate_Plan_Details
		  WHERE I_Center_Corp_Plan_ID = @I_Center_Corp_Plan_ID
		  FOR XML PATH('CorporatePlanDetails'))  
   
 RETURN @nDetailsXML  
END