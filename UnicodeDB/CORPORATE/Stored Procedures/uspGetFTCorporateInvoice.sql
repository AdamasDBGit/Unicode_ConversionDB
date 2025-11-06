CREATE PROCEDURE [CORPORATE].[uspGetFTCorporateInvoice] --1,1,'1/1/2011','1/1/2012'                                    
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
  
  
SELECT tci1.I_Corporate_Invoice_Id,SUM(tip1.N_Invoice_Amount) TotalAmt ,SUM(tip1.N_Tax_Amount) AS TTax,tcd.I_Corporate_ID ,tci1.I_Corporate_Plan_ID,
tci1.N_Excess_Amt,tci1.Dt_Crtd_On
INTO #temp         
FROM CORPORATE.T_Corporate_Invoice AS tci1          
INNER JOIN CORPORATE.T_CorporateInvoice_StudentInvoice_Map AS tcisim        
ON tci1.I_Corporate_Invoice_Id = tcisim.I_Corporate_Invoice_Id        
INNER JOIN dbo.T_Invoice_Parent AS tip1        
ON tcisim.I_Invoice_Header_ID = tip1.I_Invoice_Header_ID  
INNER JOIN CORPORATE.T_Corporate_Plan AS tcp1  
ON tci1.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID  
INNER JOIN CORPORATE.T_Corporate_Details AS tcd  
ON tcp1.I_Corporate_ID = tcd.I_Corporate_ID  
WHERE tcd.I_Corporate_ID = @iCorporateID  
AND tci1.I_Corporate_Plan_ID = COALESCE(@iCorporatePlanID,tci1.I_Corporate_Plan_ID)  
AND CAST(CONVERT(VARCHAR(10), tci1.Dt_Crtd_On, 101) AS DATETIME) >= ISNULL(@dtStartDate,tci1.Dt_Crtd_On)                                         
AND CAST(CONVERT(VARCHAR(10), tci1.Dt_Crtd_On, 101) AS DATETIME) <= ISNULL(@dtEndDate, tci1.Dt_Crtd_On)           
GROUP BY tci1.I_Corporate_Invoice_Id  ,tcd.I_Corporate_ID ,  tci1.I_Corporate_Plan_ID ,tci1.N_Excess_Amt,tci1.Dt_Crtd_On

SELECT I_Corporate_Invoice_Id ,
        TotalAmt ,
        TTax ,
        t.I_Corporate_ID ,
        t.I_Corporate_Plan_ID ,
        tcd2.S_Corporate_Name,
        tcp2.S_Corporate_Plan_Name,
        N_Excess_Amt ,
        t.Dt_Crtd_On FROM #temp AS t
        INNER JOIN CORPORATE.T_Corporate_Plan AS tcp2
        ON t.I_Corporate_Plan_ID = tcp2.I_Corporate_Plan_ID
        INNER JOIN CORPORATE.T_Corporate_Details AS tcd2  
        ON t.I_Corporate_ID = tcd2.I_Corporate_ID
 
  DROP TABLE #temp        

---'1/1/2011','1/1/2012'  
END
