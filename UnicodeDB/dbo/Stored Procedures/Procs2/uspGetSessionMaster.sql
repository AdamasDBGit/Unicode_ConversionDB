-- =============================================      
-- Author:  Abhisek Bhattacharya      
-- Create date: 08/03/2007      
-- Description: Gets the Session List      
-- =============================================      
CREATE PROCEDURE [dbo].[uspGetSessionMaster]
    (
      -- Add the parameters for the stored procedure here      
      @iBrandID INT = NULL ,
      @iSessionType INT = NULL ,
      @iSkillId INT = NULL     
    )
AS 
    BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
        SET NOCOUNT OFF      
      
    -- Insert statements for procedure here      
        SELECT  MASTER.I_Session_ID ,
                MASTER.I_Session_Type_ID ,
                MASTER.I_Brand_ID ,
                BM.S_Brand_Code ,
                BM.S_Brand_Name ,
                MASTER.S_Session_Code ,
                MASTER.S_Session_Name ,
                ISNULL(MASTER.I_Skill_ID, 0) AS I_Skill_ID ,
                ISNULL(TESM.S_Skill_Desc, '') AS SkillName ,
                MASTER.I_Status
        FROM    dbo.T_Session_Master MASTER
                INNER JOIN dbo.T_Brand_Master BM ON MASTER.I_Brand_ID = BM.I_Brand_ID
                LEFT OUTER JOIN dbo.T_EOS_Skill_Master AS TESM ON MASTER.I_Skill_ID = TESM.I_Skill_ID
        WHERE   MASTER.I_Status = 1
                AND MASTER.I_Brand_ID = ISNULL(@iBrandID, MASTER.I_Brand_ID)
                AND MASTER.I_Session_Type_ID = ISNULL(@iSessionType,
                                                      MASTER.I_Session_Type_ID)
                AND BM.I_Status = 1
                AND ( ( MASTER.I_Skill_ID = ISNULL(@iSkillId,
                                                   MASTER.I_Skill_ID) )
                      OR ( MASTER.I_Skill_ID IS NULL )
                    )
        ORDER BY MASTER.I_Session_ID DESC     
    END
