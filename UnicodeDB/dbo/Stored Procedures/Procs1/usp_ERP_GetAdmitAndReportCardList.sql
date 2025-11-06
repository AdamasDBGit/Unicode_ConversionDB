-- =============================================
-- Author:		Qutub Haider
-- Create date: 15 Aug 2024
-- =============================================

CREATE PROCEDURE [dbo].[usp_ERP_GetAdmitAndReportCardList]
(
	@iClassID dbo.IntArray READONLY,
	@iSectionId dbo.IntArray READONLY,
	@inStreamId dbo.IntArray READONLY
)
AS
BEGIN
	  SET NOCOUNT ON;
	  	 
	  SELECT 
	  	AC.inAdmitCardAndReportCardTemplateId,		
	  	TC.I_Class_ID AS ClassId,
	  	TC.S_Class_Name+' - '+ s.S_Section_Name +' - '+ AC.stTemplateName  AS stTemplateName
	  FROM  
	  	T_ERP_AdmitCardAndReportCardTemplate AC
	  	JOIN [dbo].[T_ERP_Class_Section] CS ON CS.I_Class_ID = AC.inClassId
	  	JOIN [dbo].[T_Section] S ON AC.inSectionId = S.I_Section_ID
	  	JOIN T_Class TC ON TC.I_Class_ID = AC.inClassId
	  WHERE 
	  	AC.inClassId IN (SELECT Value FROM @iClassID) 
	  	AND CS.I_Section_ID IN (SELECT Value FROM @iSectionId)
	  	AND AC.inTemplateType = 1
		OR AC.inStreamId IN (SELECT Value FROM @inStreamId)
	  GROUP BY 
	  	S.S_Section_Name,cs.I_Section_ID,s.I_Section_ID,TC.S_Class_Name ,TC.I_Class_ID , AC.inAdmitCardAndReportCardTemplateId, AC.stTemplateName
	  
	  ORDER BY TC.I_Class_ID

END

