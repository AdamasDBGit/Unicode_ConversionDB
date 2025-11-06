CREATE PROCEDURE [dbo].[uspGetCourseTreeStructure] -- [dbo].[uspGetCourseTreeStructure] 20    
    (
      -- Add the parameters for the stored procedure here    
      @IBatchID INT ,
      @dtCurrentDate DATETIME = NULL    
    )
AS 
    BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT OFF    
        DECLARE @ICourseID INT    
        SET @dtCurrentDate = ISNULL(@dtCurrentDate, GETDATE())    
     
        SELECT  @ICourseID = I_Course_ID
        FROM    dbo.T_Student_Batch_master
        WHERE   I_Batch_ID = @IBatchID    
     
     
        
        SELECT DISTINCT
                ROW_NUMBER() OVER ( ORDER BY D.I_Sequence, C.I_Sequence, A.I_Sequence ) AS Row ,
                A.I_Session_Module_ID ,
                A.I_Session_ID ,
                B.S_Session_Code ,
                B.S_Session_Name ,
                ISNULL(B.I_Skill_ID, ISNULL(G.I_Skill_ID,0)) AS I_Skill_ID ,
                CASE WHEN B.I_Skill_ID IS NOT NULL THEN E.S_Skill_Desc
                     ELSE ISNULL(G.S_Skill_Desc,'Others')
                END AS S_Skill_Desc ,
                A.I_Module_ID ,
                A.I_Sequence ,
                B.N_Session_Duration ,
                C.I_Sequence AS Module_Term_Seq ,
                D.I_Sequence AS Term_Course_Seq ,
                C.I_Term_ID ,
                B.S_Session_Topic ,
                H.S_Term_Name
        FROM    dbo.T_Session_Module_Map A
                INNER JOIN dbo.T_Session_Master B ON A.I_Session_ID = B.I_Session_ID
                LEFT OUTER JOIN T_EOS_Skill_Master E ON B.I_Skill_ID = E.I_Skill_ID
                INNER JOIN dbo.T_Module_Term_Map C ON A.I_Module_ID = C.I_Module_ID
                INNER JOIN T_Module_Master F ON C.I_Module_ID = F.I_Module_ID
                LEFT OUTER JOIN T_EOS_Skill_Master G ON F.I_Skill_ID = G.I_Skill_ID
                INNER JOIN dbo.T_Term_Course_Map D ON C.I_Term_ID = D.I_Term_ID
                INNER JOIN dbo.T_Term_Master H ON C.I_Term_ID = H.I_Term_ID
                                                  AND D.I_Course_ID = @ICourseID
                                                  AND @dtCurrentDate >= ISNULL(A.Dt_Valid_From,
                                                              @dtCurrentDate)
                                                  AND @dtCurrentDate <= ISNULL(A.Dt_Valid_To,
                                                              @dtCurrentDate)
                                                  AND A.I_Status <> 0
                                                  AND B.I_Status <> 0
                                                  AND C.I_Status <> 0
                                                  AND D.I_Status <> 0
        ORDER BY D.I_Sequence ,
                C.I_Sequence ,
                A.I_Sequence    
     
    END
