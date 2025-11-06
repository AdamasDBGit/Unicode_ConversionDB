CREATE PROCEDURE [REPORT].[uspGetCenterCollectionDetail]
(
@iCenterID AS INT,
@dtStart DATETIME,
@dtEnd DATETIME
)

AS
BEGIN

SELECT	
		SUM(N_Receipt_Amount) AS "Amount",
		SUM(N_Tax_Amount) AS "Tax",
		CAST(Dt_Crtd_On AS DATE)

 FROM T_Receipt_Header 

WHERE 
		I_Status=1
AND		DATEDIFF(dd,@dtStart,Dt_Crtd_On)>=0 
AND		DATEDIFF(dd,@dtEnd,Dt_Crtd_On)<=0
AND		I_Centre_Id=@iCenterID
		
GROUP BY CAST(Dt_Crtd_On AS DATE)
		
END
