CREATE   PROCEDURE [dbo].[usp_ERP_GetCompanyName] ---738    
    
 @iCentreID INT    
    
AS    
BEGIN    
    
 SET NOCOUNT OFF;    
    
  select distinct t2.S_Brand_Name  AS CompanyName  
  from T_Centre_Master t1
  inner join T_Brand_Center_Details BCD ON BCD.I_Centre_Id=t1.I_Centre_Id
  inner join T_Brand_Master t2 
  on t2.I_Brand_ID=BCD.I_Brand_ID
  where t1.I_Centre_Id = @iCentreID and t2.I_Status=1  

  
  
     
END  
  