-- =============================================  
-- Author:  Swagata De  
-- Create date: 12/03/2007  
-- Description: Gets the Module List  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetModuleMaster]   
 -- Add the parameters for the stored procedure here  
    @iBrandID INT = NULL ,
    @iSkillId INT = NULL
AS 
    BEGIN  
   
        SET NOCOUNT OFF  
  
    -- Insert statements for procedure here  
        SELECT  MASTER.I_Module_ID ,
                MASTER.I_Skill_ID ,
                MASTER.I_Brand_ID ,
                MASTER.S_Module_Code ,
                MASTER.S_Module_Name ,
                BM.S_Brand_Code ,
                BM.S_Brand_Name ,
                ( SELECT    COUNT(A.I_Course_Center_ID)
                  FROM      dbo.T_Course_Center_Detail A
                            INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = A.I_Centre_Id
                            INNER JOIN dbo.T_Term_Course_Map B ON A.I_Course_ID = B.I_Course_ID
                            INNER JOIN dbo.T_Module_Term_Map C ON B.I_Term_ID = C.I_Term_ID
                            INNER JOIN dbo.T_Module_Master D ON C.I_Module_ID = D.I_Module_ID
                  WHERE     C.I_Module_ID = MASTER.I_Module_ID
                            AND A.I_Status = 1
                            AND B.I_Status = 1
                            AND C.I_Status = 1
                            AND D.I_Status = 1
                            AND CM.I_Status = 1
                            AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(CM.Dt_Valid_From,
                                                    GETDATE())
                            AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())
                ) AS I_Is_Editable ,
                MASTER.I_Status
        FROM    dbo.T_Module_Master MASTER
                INNER JOIN dbo.T_Brand_Master BM ON MASTER.I_Brand_ID = BM.I_Brand_ID
        WHERE   MASTER.I_Status <> 0
                AND MASTER.I_Brand_ID = ISNULL(@iBrandID, MASTER.I_Brand_ID)
                AND (MASTER.I_Skill_ID = ISNULL(@iSkillId, MASTER.I_Skill_ID) OR MASTER.I_Skill_ID IS NULL)
                AND BM.I_Status <> 0
        ORDER BY MASTER.S_Module_Name  
   
    END
