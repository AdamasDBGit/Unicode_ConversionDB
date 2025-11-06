CREATE PROCEDURE Usp_Erp_GetAcademicSessionsByBrandId  
    @BrandId INT  
AS  
BEGIN  
    SELECT T_School_Academic_Session_Master.I_School_Session_ID,  
           T_School_Academic_Session_Master.S_Label  
    FROM T_School_Academic_Session_Master  
    WHERE T_School_Academic_Session_Master.I_Brand_ID = @BrandId  
      AND T_School_Academic_Session_Master.I_Status = 1;  
END;