-- =============================================  
-- Author:  Abhisek Bhattacharya  
-- Create date: 12/03/2007  
-- Description: Get the Session detail  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetSessionDetails] ( -- Add the parameters for the stored procedure here  
                                                @iSessionID INT )
AS 
    BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
        SET NOCOUNT OFF  
  
    -- Insert statements for procedure here  
        SELECT  MASTER.I_Session_ID ,
                MASTER.I_Session_Type_ID ,
                MASTER.I_Brand_ID ,
                MASTER.S_Session_Code ,
                MASTER.S_Session_Name ,
                MASTER.S_Session_Topic ,
                MASTER.N_Session_Duration ,
                I_Skill_ID,
                MASTER.S_Crtd_By ,
                MASTER.S_Upd_By ,
                MASTER.Dt_Crtd_On ,
                MASTER.Dt_Upd_On ,
                BM.S_Brand_Code ,
                BM.S_Brand_Name ,
                ( SELECT    COUNT(A.I_Course_Center_ID)
                  FROM      dbo.T_Course_Center_Detail A
                            INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = A.I_Centre_Id
                            INNER JOIN dbo.T_Term_Course_Map B ON A.I_Course_ID = B.I_Course_ID
                            INNER JOIN dbo.T_Module_Term_Map C ON B.I_Term_ID = C.I_Term_ID
                            INNER JOIN dbo.T_Session_Module_Map D ON C.I_Module_ID = D.I_Module_ID
                            INNER JOIN dbo.T_Session_Master E ON D.I_Session_ID = E.I_Session_ID
                  WHERE     D.I_Session_ID = @iSessionID
                            AND A.I_Status = 1
                            AND B.I_Status = 1
                            AND C.I_Status = 1
                            AND D.I_Status = 1
                            AND E.I_Status = 1
                            AND CM.I_Status = 1
                            AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(D.Dt_Valid_From, GETDATE())
                            AND GETDATE() <= ISNULL(D.Dt_Valid_To, GETDATE())
                            AND GETDATE() >= ISNULL(CM.Dt_Valid_From,
                                                    GETDATE())
                            AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())
                ) AS I_Is_Editable ,
                MASTER.I_Status
        FROM    dbo.T_Session_Master MASTER
                INNER JOIN dbo.T_Brand_Master BM ON MASTER.I_Brand_ID = BM.I_Brand_ID
        WHERE   MASTER.I_Session_ID = @iSessionID
                AND MASTER.I_Status <> 0
                AND BM.I_Status <> 0  
   
    END
