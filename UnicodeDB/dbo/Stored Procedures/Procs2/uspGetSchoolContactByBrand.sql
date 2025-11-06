CREATE PROCEDURE [dbo].[uspGetSchoolContactByBrand]   
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 SELECT   
    sc.[I_Brand_ID] BrandID  
      ,[S_Email] Email  
      ,[S_Mobile] Mobile  
      ,SC.[S_Description] Description  
   ,spch.N_Value LogoUrl  
      ,[I_Status] Status  
  FROM [dbo].[T_School_Contact]  SC
  Inner Join T_ERP_Saas_Pattern_Header SPH on sc.I_Brand_ID=SPH.I_Brand_ID
  Inner Join T_ERP_Saas_Pattern_Child_Header SPCH on SPCH.I_Pattern_HeaderID=SPH.I_Pattern_HeaderID
  where  I_Status = 1  and SPH.S_Property_Name='BRAND_LOGO' and SPH.Is_Active=1 
  and SPCH.Is_Active=1
  
  
      
END