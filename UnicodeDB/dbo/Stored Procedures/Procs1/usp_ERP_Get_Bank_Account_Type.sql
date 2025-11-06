CREATE   PROCEDURE [dbo].[usp_ERP_Get_Bank_Account_Type]                
       
AS                
BEGIN                
     SELECT ID,Type FROM T_Bank_Account_Type     
 END