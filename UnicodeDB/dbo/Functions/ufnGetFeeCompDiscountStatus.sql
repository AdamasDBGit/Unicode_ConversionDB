CREATE FUNCTION [dbo].[ufnGetFeeCompDiscountStatus]  
(  
 @iFeeComponentId INT  
,@dtInviceDate DATETIME  
)  
RETURNS INT  
AS  
BEGIN  

DECLARE @iStatus INT  
DECLARE @TEMPTABLE TABLE ( Is_Discount_Applicable INT )

 INSERT INTO @TEMPTABLE 
 SELECT TOP 1 Is_Discount_Applicable
 FROM T_Fee_Component_Discount_Detail  
 WHERE I_Fee_Component_ID = @iFeeComponentId 
 AND Is_Invoice_Receipt = 1 AND Dt_Crtd_On <= @dtInviceDate
 ORDER BY Dt_Crtd_On DESC 

 SELECT @iStatus =  Is_Discount_Applicable FROM @TEMPTABLE
   
 RETURN @iStatus  
END