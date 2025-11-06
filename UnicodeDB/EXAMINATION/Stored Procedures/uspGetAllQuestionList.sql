/**************************************************************************************************************    
Created by  : Debarshi Basu    
Date  : 05.05.2007    
Description : This SP will retrieve the details of all questions associated with an exam component     
Parameters  : iExamComponentID    
Returns     : Dataset    
**************************************************************************************************************/    
    
CREATE PROCEDURE [EXAMINATION].[uspGetAllQuestionList]    --1198
(    
 @iExamComponentID INT = NULL    
)    
AS    
BEGIN    
 SET NOCOUNT ON;     
 SELECT QP.I_Question_ID,QP.I_Pool_ID,TCD.I_Competency_ID,QP.I_Answer_Type_ID,    
   QP.S_Question,QP.I_Question_Type,QP.I_Complexity_ID,    
   QP.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,    
   UD.S_Document_Path,UD.S_Document_URL    
 FROM EXAMINATION.T_Question_Pool QP    
 LEFT OUTER JOIN ASSESSMENT.T_Competency_Details AS TCD
 ON QP.I_Pool_ID = TCD.I_Pool_ID
 LEFT OUTER JOIN dbo.T_Upload_Document UD    
 ON QP.I_Document_ID = UD.I_Document_ID    
 AND UD.I_Status = 1    
 WHERE QP.I_Pool_ID IN (SELECT I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping    
       WHERE I_Question_Bank_ID IN (SELECT TQBM.I_Question_Bank_ID FROM  EXAMINATION.T_Question_Bank_Master TQBM WITH(NOLOCK)))    
    
 SELECT QP.I_Question_ID, QC.I_Question_Choice_ID,QC.S_Answer_Desc,    
  QC.B_Is_Answer,ISNULL(QC.N_Answer_Marks,0) AS N_Answer_Marks    
 FROM EXAMINATION.T_Question_Choices QC    
 INNER JOIN EXAMINATION.T_Question_Pool QP    
 ON QP.I_Question_ID = QC.I_Question_ID    
 WHERE QP.I_Pool_ID IN (SELECT I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping    
       WHERE I_Question_Bank_ID IN (SELECT TQBM.I_Question_Bank_ID FROM  EXAMINATION.T_Question_Bank_Master TQBM WITH(NOLOCK)))    
    
 SELECT QP.I_Question_ID, SQ.I_SubQuestion_ID,SQ.I_SubQuestion_Type,    
   SQ.S_SubQuestion_Desc,SQ.S_SubQuestion_Value,SQ.I_Document_ID,    
   UD.S_Document_Name,UD.S_Document_Type,    
   UD.S_Document_Path,UD.S_Document_URL    
 FROM EXAMINATION.T_SubQuestion SQ    
 INNER JOIN EXAMINATION.T_Question_Pool QP     
 ON QP.I_Question_ID = SQ.I_Question_ID    
 LEFT OUTER JOIN dbo.T_Upload_Document UD    
 ON SQ.I_Document_ID = UD.I_Document_ID    
 WHERE QP.I_Pool_ID IN (SELECT I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping    
       WHERE I_Question_Bank_ID IN (SELECT TQBM.I_Question_Bank_ID FROM  EXAMINATION.T_Question_Bank_Master TQBM WITH(NOLOCK)))    
    
 SELECT SQ.I_SubQuestion_ID , SQC.I_SubQuestion_Choice_ID,SQC.I_SubQuestion_Choice_Type,    
   SQC.S_SubAnswer_Value,SQC.S_SubAnswer_Desc,SQ.I_Document_ID,    
   SQC.B_Is_Answer,UD.S_Document_Name,UD.S_Document_Type,    
   UD.S_Document_Path,UD.S_Document_URL    
 FROM EXAMINATION.T_SubQuestion_Choice SQC    
 INNER JOIN EXAMINATION.T_SubQuestion SQ    
 ON SQC.I_SubQuestion_ID = SQ.I_SubQuestion_ID    
 INNER JOIN EXAMINATION.T_Question_Pool QP    
 ON SQ.I_Question_ID = QP.I_Question_ID    
 LEFT OUTER JOIN dbo.T_Upload_Document UD    
 ON SQC.I_Document_ID = UD.I_Document_ID    
 WHERE QP.I_Pool_ID IN (SELECT I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping    
       WHERE I_Question_Bank_ID IN (SELECT TQBM.I_Question_Bank_ID FROM  EXAMINATION.T_Question_Bank_Master TQBM WITH(NOLOCK)))    
  
 SELECT SM.S_Skill_Desc  
 FROM dbo.T_EOS_Skill_Master SM  
 INNER JOIN EOS.T_Skill_Exam_Map SEM ON SM.I_Skill_ID = SEM.I_Skill_ID  
 WHERE SEM.I_Exam_Component_ID = @iExamComponentID  
 AND SM.I_Status = 1  
 AND SEM.I_Status = 1  
  
END
