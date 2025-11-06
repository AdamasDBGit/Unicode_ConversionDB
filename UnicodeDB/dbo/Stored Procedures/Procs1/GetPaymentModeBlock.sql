CREATE PROCEDURE [dbo].[GetPaymentModeBlock]  
@paymentmodeid int  
--@ischequedraft bit OUT,  
--@blockname nvarchar(50) OUT  
AS  
BEGIN  
 SELECT IsCheque_Draft as IsCheckDraft,ISNULL(S_Cheque_DraftName,'') AS BlockName FROM T_PaymentMode_Master  
 WHERE I_PaymentMode_ID=@paymentmodeid  
END


