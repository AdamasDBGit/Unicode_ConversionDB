-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <17th Nov 2023>  
-- Description: <to get the list of currency>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetCurrency]  
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 select CM.I_Currency_ID as CurrencyID,  
 CM.S_Currency_Code as CurrencyCode,  
 CM.S_Currency_Name as CurrencyName  
 from  [dbo].[T_Currency_Master] as CM  
END
