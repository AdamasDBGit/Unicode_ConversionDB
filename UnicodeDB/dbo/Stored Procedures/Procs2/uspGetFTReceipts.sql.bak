CREATE PROCEDURE [dbo].[uspGetFTReceipts]    
(    
 @sReceiptID NVARCHAR(MAX)    
)    
    
AS    
BEGIN    
    
SELECT I_FTD_Fund_Transfer_Header_ID FROM dbo.T_Fund_Transfer_Details AS TFTD  
WHERE I_FTD_Receipt_Header_ID IN (Select val from dbo.fnString2Rows(@sReceiptID,','))  
   
    
END

