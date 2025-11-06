CREATE PROCEDURE [dbo].[usp_ERP_Get_Grade_Master_With_Pattern]  
    @inExamGradeHederId INT   
AS  
BEGIN  
 SELECT   
 GM.stRemarks,
 GM.stSymbol,
        GM.inLowerLimit,  
  GM.inUpperLimit,  
  GM.inExamGradeID,  
  GH.inExamGradeHederId,  
  GH.stGradeHederName  
    FROM   
        T_ERP_Exam_Grade_Master_Header GH   
  LEFT JOIN T_ERP_Exam_Grade_Master GM  ON GH.inExamGradeHederId = GM.inExamGradeHederId  
 WHERE   
  GH.inExamGradeHederId = @inExamGradeHederId AND GM.IsActive = 1  
END  