-- =============================================      
-- Author:  <Qutub>      
-- Create date: <03-July-2024>      
-- Description: 
-- =============================================      
    
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetExamDropdownList]     
(    
   @iBrandID INT = NULL,
   @iClassId INT = NULL,
   @iSubjectId  INT = NULL,
   @inSubjectTypeID INT,
   @inSubjectComponentID INT,
   @iFacultyId INT = NULL
)      
AS      
BEGIN      
    SELECT 
		DISTINCT
		ES.inExamScheduleDetailId,
		ES.stExamName
    FROM T_ERP_Exam_SchedulesDetails ES
	LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SSD ON SSD.inExamScheduleDetailId = ES.inExamScheduleDetailId
	JOIN T_ERP_Exam_Type_Master ET ON ET.inExamTypeID = ES.inExamTypeId AND ET.IsMainExam = 0
	LEFT JOIN T_ERP_Faculty_Subject FS ON FS.I_Subject_ID = SSD.inSubjectID 
    WHERE
		ES.inBrandID = @iBrandID     
		AND SSD.inClassId = @iClassId
		AND SSD.inSubjectID = @iSubjectId 
		AND SSD.inSubjectTypeID = @inSubjectTypeID
		AND SSD.inSubjectComponentID = @inSubjectComponentID
		OR FS.I_Faculty_Subject_ID = @iFacultyId
END   