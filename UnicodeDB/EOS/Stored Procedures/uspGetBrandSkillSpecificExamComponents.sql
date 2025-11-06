/*******************************************************
Description : This SP will retrieve the exam components for which the skill exam mapping has been performed
for the seected brand
Author	:  Swagata De  
Date	:	 
*********************************************************/

CREATE PROCEDURE [EOS].[uspGetBrandSkillSpecificExamComponents] 
(
	@iBrandID int
	
)
AS
BEGIN 
select distinct A.I_Exam_Component_ID,
A.S_Component_Name,A.I_Status,
A.S_Component_Type,
A.I_Exam_Type_Master_ID
from dbo.T_Exam_Component_Master A
WHERE A.S_Component_Type IN ('O','A')
and A.I_status<>0
and A.I_Brand_ID = @iBrandID

END
