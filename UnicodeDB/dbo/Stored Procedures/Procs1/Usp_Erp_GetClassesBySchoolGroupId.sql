CREATE PROCEDURE Usp_Erp_GetClassesBySchoolGroupId  
    @SchoolGroupId INT  
AS  
BEGIN  
    SELECT T_Class.I_Class_ID, T_Class.S_Class_Name  
    FROM T_School_Group_Class  
    JOIN T_Class ON T_School_Group_Class.I_Class_ID = T_Class.I_Class_ID  
    WHERE T_School_Group_Class.I_School_Group_ID = @SchoolGroupId  
      AND T_Class.I_Status = 1;  
END;