CREATE PROCEDURE Usp_Erp_GetSectionsByClassAndSessionAndGroup  
    @ClassId INT,  
    @SchoolSessionId INT,  
    @SchoolGroupId INT  
AS  
BEGIN  
    SELECT T_Section.I_Section_ID, T_Section.S_Section_Name  
    FROM T_Section  
    JOIN T_ERP_Class_Section ON T_Section.I_Section_ID = T_ERP_Class_Section.I_Section_ID  
    WHERE T_ERP_Class_Section.I_Class_ID = @ClassId  
      AND T_ERP_Class_Section.I_School_Session_ID = @SchoolSessionId  
      AND T_ERP_Class_Section.I_School_Group_ID = @SchoolGroupId;  
END;