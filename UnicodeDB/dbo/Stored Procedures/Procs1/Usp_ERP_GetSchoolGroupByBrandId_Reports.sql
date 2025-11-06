CREATE PROCEDURE Usp_ERP_GetSchoolGroupByBrandId_Reports    
    @BrandId INT    
AS    
BEGIN    
    SELECT I_School_Group_ID, S_School_Group_Name     
    FROM T_School_Group    
    WHERE I_Brand_Id = @BrandId
	UNION ALL
	Select Null as I_School_Group_ID,'ALL' as S_School_Group_Name
	Order by I_School_Group_ID
END;