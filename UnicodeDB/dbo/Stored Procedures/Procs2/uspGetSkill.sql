-- =============================================  
-- Author:  Soumya Sikder  
-- Create date: 17/01/2007  
-- Description: Fetches all the Skill Master Table Details  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[uspGetSkill]   
AS  
BEGIN  
  
 SELECT A.I_Skill_ID,  
   A.I_Brand_ID,  
   A.S_Skill_Desc,  
   A.S_Skill_No,  
   ISNULL(A.S_Skill_Type,'')as S_Skill_Type,  
   A.S_Crtd_By,  
   A.I_Status,  
   A.S_Upd_By,  
   A.Dt_Crtd_On,  
   A.Dt_Upd_On,  
   B.S_Brand_Name,  
   B.S_Brand_Code  
 FROM dbo.T_EOS_Skill_Master A  
 INNER JOIN dbo.T_Brand_Master B  
 ON A.I_Brand_ID = B.I_Brand_ID  
 ORDER BY A.S_Skill_No  
END
