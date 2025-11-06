CREATE PROCEDURE [dbo].[uspGetTermExamComponentList]
  @iTermID INT
AS
BEGIN
		 SELECT DISTINCT ECM.I_Exam_Component_ID
					,ECM.S_Component_Name 
		 FROM T_Module_Eval_Strategy MES 
		 INNER JOIN T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID = MES.I_Exam_Component_ID 
		 WHERE I_Term_ID = @iTermID 
				AND MES.I_Status = 1
END
