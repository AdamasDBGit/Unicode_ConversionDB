-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <9th Nov>  
-- Description: <to get Fee components>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_Get_Fee_Component]  
 -- Add the parameters for the stored procedure here  
 @FeeHeadId int null,  
 @iBrand int,  
 @isindividual bit = NULL,  
 @isadhoc bit =NULL  
AS  
BEGIN  
   
 SET NOCOUNT ON;  
  Select FC.I_Fee_Component_ID as FeeHeadID,  
  FC.S_Fee_Component_Name as FeeComponent  
      ,ISNULL(FC.I_is_refundable,0) as IsRefundable  
      ,ISNULL(FC.I_Is_Special_Fee,0) as SpecialFee  
      ,ISNULL(FC.I_is_adhoc,0) as IsAdhoc  
      ,FC.S_financial_account_code as FinancialAccount  
  from [dbo].[T_ERP_Fee_Component] as FC  
  where FC.I_Fee_Component_ID= ISNULL(@FeeHeadId,FC.I_Fee_Component_ID)  
  and FC.I_Brand_ID = @iBrand  
  and ISNULL(FC.Is_individual,0)=ISNULL(@isindividual,ISNULL(FC.Is_individual,0))  
  and ISNULL(FC.I_Is_Adhoc,0)=ISNULL(@isadhoc,ISNULL(FC.I_Is_Adhoc,0))  
END  