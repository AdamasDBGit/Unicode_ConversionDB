CREATE PROCEDURE Usp_ERP_GetSchoolGroupByBrandId  
    @BrandId INT  
AS  
BEGIN  
    SELECT I_School_Group_ID, S_School_Group_Name   
    FROM T_School_Group  
    WHERE I_Brand_Id = @BrandId;  
END;