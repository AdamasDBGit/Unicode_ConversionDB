CREATE PROCEDURE [dbo].[uspGetFTReceipts]    
(    
 @sReceiptID VARCHAR(1000)    
)    
    
AS    
BEGIN    
    
SELECT I_FTD_Fund_Transfer_Header_ID FROM dbo.T_Fund_Transfer_Details AS TFTD  
WHERE I_FTD_Receipt_Header_ID IN (Select val from dbo.fnString2Rows(@sReceiptID,','))  
   
    
END
