-- =============================================  
-- Author:  Arunava Mitra  
-- Create date: 22/12/2006  
-- Description: Selects All the Countries   
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetEOSStatus]   
AS  
BEGIN  
  
 SELECT I_ESM_Status_ID,S_ESM_Status_Code  
 FROM dbo.T_EOS_Status_Master  
  
END
