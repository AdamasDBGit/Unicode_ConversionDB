-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 22/03/2007  
-- Description: Get the Payment Modes  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[uspGetPaymentMode]
AS 
    BEGIN  
  
        SELECT  I_PaymentMode_ID ,
                S_PaymentMode_Name ,
                I_Status,
                I_Brand_ID
        FROM    dbo.T_PaymentMode_Master
        WHERE   I_Status = 1 and  IsOffline=1
  
    END




