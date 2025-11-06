CREATE PROCEDURE [dbo].[uspGetResidance]     
   
    
AS    
BEGIN    
    
 SELECT I_Residence_Area_ID, S_Residence_Area_Name,S_Crtd_By,S_Updt_By,Dt_Crtd_On,Dt_Updt_On,I_Status    
 FROM dbo.T_Residence_Area_Master    
 WHERE I_Status <> 0    
 ORDER BY S_Residence_Area_Name    
    
END
