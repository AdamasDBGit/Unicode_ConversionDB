--uspGetTermModuleExamComponentList @iTermID = 370

CREATE PROCEDURE [dbo].[uspGetTermModuleExamComponentList]
	@iTermID INT
AS
BEGIN
	SELECT   MES.I_Module_Strategy_ID
			,ECM.I_Exam_Component_ID
			,ECM.S_Component_Name
			,MM.I_Module_ID
			,MM.S_Module_Name
			,MES.N_Weightage
			,MES.I_TotMarks 
	 FROM T_Module_Eval_Strategy MES 
	 INNER JOIN T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID = MES.I_Exam_Component_ID 
	 INNER JOIN T_Module_Master MM ON MM.I_Module_ID = MES.I_Module_ID 
	 WHERE I_Term_ID = @iTermID 
	 AND MES.I_Status = 1

END
