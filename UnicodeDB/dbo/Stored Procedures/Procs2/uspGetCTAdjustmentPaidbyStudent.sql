CREATE PROCEDURE [dbo].[uspGetCTAdjustmentPaidbyStudent]      
(          
 @iStudentDetailId INT      
,@iSourceCenterID INT         
)          
AS          
BEGIN       
      
SELECT ISNULL(SUM(ISNULL(RH.N_Receipt_Amount,0)) + SUM(ISNULL(RH.N_Tax_Amount,0)),0) AS N_Receipt_Amount
FROM T_Receipt_Header RH      
INNER JOIN T_Student_Center_Detail SCD     
 ON RH.I_Student_Detail_ID = SCD.I_Student_Detail_ID  AND RH.I_Centre_Id = SCD.I_Centre_Id    
WHERE SCD.I_Status = 1   
AND RH.I_Centre_Id = @iSourceCenterID       
AND SCD.I_Centre_Id = @iSourceCenterID      
AND RH.I_Student_Detail_Id = @iStudentDetailId      
AND RH.I_Receipt_Type = 24 -- RECEIPT TYPE IS 6 FOR Center Transfer Adjustment Fee     
      
END
