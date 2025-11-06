CREATE PROCEDURE [dbo].[uspGetExaminableModule]   
(  
 @iModuleID int  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
   
 SELECT * FROM T_MODULE_TERM_MAP   
  WHERE C_Examinable = 'Y'   
  AND I_Module_ID = @iModuleID   
  AND I_Status <> 0   
  
END
