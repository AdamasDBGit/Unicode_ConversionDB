-- =============================================    
-- Author:  <ANIRBAN PAHARI>    
-- Create date: <08/03/2007>    
-- Description: <TO GET ALL EXAM COMPONENT.EXEC uspGetExamMaster>    
-- =============================================    
CREATE PROCEDURE [dbo].[uspGetExam]     
 -- Add the parameters for the stored procedure here    
AS 
    BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT ON ;    
    
    -- Insert statements for procedure here    
        SELECT  I_Exam_Component_ID ,
                I_Exam_Type_Master_ID ,
                S_Component_Name ,
                I_Status ,
                S_Component_Type ,
                Dt_Admission_Test ,
                S_Crtd_By ,
                S_Upd_By ,
                Dt_Crtd_On ,
                Dt_Upd_On ,
                I_Brand_ID ,
                I_Course_ID ,
                ISNULL(B_Is_Subject,0)
                [I_Exam_Type_Master_ID]
        FROM    T_Exam_Component_Master
        WHERE   I_Status <> 0    
    END
