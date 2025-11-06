CREATE PROCEDURE [CORPORATE].[uspGetFTCorporateReceipt] --1,7,'1/1/2011','1/1/2012'                                    
(                                      
 -- Add the parameters for the stored procedure here                                      
 @iCorporateID int = NULL,                                    
 @iCorporatePlanID int = NULL,                                    
 @dtStartDate datetime = NULL,                                      
 @dtEndDate datetime = NULL                              
)                                      
                                      
AS                                      
BEGIN                                      
 -- SET NOCOUNT ON added to prevent extra result sets from                                      
 -- interfering with SELECT statements.                                      
 SET NOCOUNT ON    
  
  
SELECT tcrsrm.I_Corporate_Receipt_Id ,
       SUM( N_Receipt_Amount) TotalAmt,
       SUM(  N_Tax_Amount ) TTax,
       tcd2.I_Corporate_ID ,tcr1.I_Corporate_Plan_ID,
        tcr1.Dt_Crtd_On
      
INTO #temp         
  FROM CORPORATE.T_CorporateReceipt_StudentReceipt_Map AS tcrsrm  
	   INNER JOIN dbo.T_Receipt_Header AS trh
	   ON tcrsrm.I_Receipt_Header_ID = trh.I_Receipt_Header_ID
       INNER JOIN CORPORATE.T_Corporate_Receipt AS tcr1   
       ON tcrsrm.I_Corporate_Receipt_Id = tcr1.I_Corporate_Receipt_Id
       INNER JOIN CORPORATE.T_Corporate_Plan AS tcp1
       ON tcr1.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID
       INNER JOIN CORPORATE.T_Corporate_Details AS tcd2
       ON tcp1.I_Corporate_ID = tcd2.I_Corporate_ID  
WHERE tcd2.I_Corporate_ID = @iCorporateID  
AND tcr1.I_Corporate_Plan_ID = COALESCE(@iCorporatePlanID,tcr1.I_Corporate_Plan_ID)  
AND CAST(CONVERT(VARCHAR(10), tcr1.Dt_Crtd_On, 101) AS DATETIME) >= ISNULL(@dtStartDate,tcr1.Dt_Crtd_On)                                         
AND CAST(CONVERT(VARCHAR(10), tcr1.Dt_Crtd_On, 101) AS DATETIME) <= ISNULL(@dtEndDate, tcr1.Dt_Crtd_On)           
 GROUP BY tcrsrm.I_Corporate_Receipt_Id,tcd2.I_Corporate_ID , tcr1.I_Corporate_Plan_ID ,tcr1.Dt_Crtd_On

SELECT I_Corporate_Receipt_Id,
        TotalAmt ,
        TTax ,
        t.I_Corporate_ID ,
        t.I_Corporate_Plan_ID ,
        tcd2.S_Corporate_Name,
        tcp2.S_Corporate_Plan_Name,
        t.Dt_Crtd_On FROM #temp AS t
        INNER JOIN CORPORATE.T_Corporate_Plan AS tcp2
        ON t.I_Corporate_Plan_ID = tcp2.I_Corporate_Plan_ID
        INNER JOIN CORPORATE.T_Corporate_Details AS tcd2  
        ON t.I_Corporate_ID = tcd2.I_Corporate_ID
 
  DROP TABLE #temp        

---'1/1/2011','1/1/2012'  
END
