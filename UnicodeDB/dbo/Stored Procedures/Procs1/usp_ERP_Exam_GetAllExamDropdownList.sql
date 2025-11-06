CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetAllExamDropdownList]     
(    
   @iBrandID INT = NULL,
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
	JOIN T_ERP_Exam_Type_Master ET ON ET.inExamTypeID = ES.inExamTypeId
	LEFT JOIN T_ERP_Faculty_Subject FS ON FS.I_Subject_ID = SSD.inSubjectID 
    WHERE
		ES.inBrandID = @iBrandID   
		OR FS.I_Faculty_Subject_ID = @iFacultyId
END 
