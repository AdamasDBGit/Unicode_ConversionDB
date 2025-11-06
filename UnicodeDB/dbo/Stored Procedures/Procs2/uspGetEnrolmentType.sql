CREATE PROCEDURE [dbo].[uspGetEnrolmentType]   
 
  
AS  
BEGIN  
  
 SELECT I_Enrolment_Type_ID, S_Enrolment_Type,S_Crtd_By,S_Updt_By,Dt_Crtd_On,Dt_Updt_On,I_Status  
 FROM dbo.T_Enrolment_Type_Master  
 WHERE I_Status <> 0  
 ORDER BY S_Enrolment_Type  
  
END
