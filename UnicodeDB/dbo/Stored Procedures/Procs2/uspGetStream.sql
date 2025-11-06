CREATE PROCEDURE [dbo].[uspGetStream]     
AS    
BEGIN    
    
 SELECT I_Stream_ID,S_Stream_Name,I_Status ,I_Qualification_Name_ID   
 FROM T_Stream_Master    
 ORDER BY S_Stream_Name    
    
END
