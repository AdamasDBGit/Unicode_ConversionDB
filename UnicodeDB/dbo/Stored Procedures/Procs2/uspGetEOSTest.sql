-- =============================================  
-- Author:  Arunava Mitra  
-- Create date: 22/12/2006  
-- Description: Selects All the EOS tests   
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetEOSTest]   
AS  
BEGIN  
  
 SELECT I_ETM_Test_ID, I_ETM_Brand_ID,S_ETM_Test_Name,S_ETM_Crtd_By,S_ETM_Upd_By,Dt_ETM_Crtd_On,Dt_ETM_Upd_On,C_ETM_Status  
 FROM dbo.T_EOS_Test_Master  
 WHERE C_ETM_Status <>'D'  
  
END
