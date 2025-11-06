/*******************************************************
Description : Gets the list of Modules which contains EProject as one of its Exam under the Term
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetEProjectModuleList] 
(
	@iTermID int
)
AS
BEGIN TRY 
	-- getting records for Table [0]
	SELECT	DISTINCT	MM.I_Module_ID,
					MM.I_Brand_ID,
					MM.S_Module_Code,
					MM.S_Module_Name,
					MM.I_Status
	FROM dbo.T_Module_Master MM
	INNER JOIN dbo.T_Module_Term_Map MTM
	ON MM.I_Module_ID = MTM.I_Module_ID
	INNER JOIN dbo.T_Module_Eval_Strategy MES
	ON MM.I_Module_ID = MES.I_Module_ID
	INNER JOIN dbo.T_Exam_Component_Master ECM
	ON MES.I_Exam_Component_ID = ECM.I_Exam_Component_ID
	INNER JOIN dbo.T_Exam_Type_Master ETM
	ON ETM.I_Exam_Type_Master_ID = ECM.I_Exam_Type_Master_ID
	WHERE MTM.I_Term_ID = @iTermID
	AND ETM.I_Exam_Type_Master_ID = 1  --EPROJECTS
	AND MM.I_Status = 1
	AND MTM.I_Status = 1
	AND MES.I_Status = 1
	AND ECM.I_Status = 1
	AND GETDATE() >= ISNULL(MTM.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(MTM.Dt_Valid_To,GETDATE())

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
