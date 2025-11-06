CREATE PROCEDURE [dbo].[usp_ERP_Get_Grade_Master]  
(  
  @inExamGradeHederId INT = NULL  
)  
AS  
BEGIN  
 SELECT   
  inExamGradeHederId,  
  stGradeHederName  
 FROM T_ERP_Exam_Grade_Master_Header  
 where inExamGradeHederId = ISNULL(@inExamGradeHederId,inExamGradeHederId)  
 AND IsActive = 1  
END