CREATE PROCEDURE [dbo].[usp_GetToMigrateFeeStructureDetails] (@BrandID int=null)     
AS      
BEGIN      
    SELECT       
        fs.I_Fee_Structure_ID FeeStructureID,       
        fsm.I_Fee_Structure_AcademicSession_Map_ID,       
        7 AS SessionID      
    FROM       
        T_ERP_Fee_Structure fs      
          
    LEFT JOIN       
        T_ERP_Fee_Structure_AcademicSession_Map fsm       
        ON fsm.I_Fee_Structure_ID = fs.I_Fee_Structure_ID      
  where fs.S_Fee_Structure_Name like '%2025%'  and fsm.I_Fee_Structure_ID is null  
  
    ORDER BY       
        fs.I_Fee_Structure_ID;      
END; 