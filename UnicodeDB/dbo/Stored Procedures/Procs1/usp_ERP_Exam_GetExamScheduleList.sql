


--EXEC [usp_ERP_Exam_GetExamScheduleList] 35,null,null,'23',null,null,null,1,'DESC',1,10,1,null

-- =============================================
-- Author:  Md Qutubuddin Haider
-- Create date: 26th July 2024
-- Description: Get Exam Schedule List with Filters and Tab Types
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetExamScheduleList] 
(
    @SessionId INT = NULL,
    @SchoolGroupId INT = NULL,  
    @SchoolClassId NVARCHAR(200) = NULL,  
    @ExamName NVARCHAR(200) = NULL,  
    @ExamScheduleStatus INT = NULL,  
    @ExamTypeId NVARCHAR(200) = NULL,  
    @ExamCategoryId NVARCHAR(200) = NULL,  
    @inSortColumn INT = 1,  
    @stSortOrder NVARCHAR(4) = 'DESC',  
    @inPageNo INT = 1,   
    @inPageSize INT = 10,
    @tabtype INT,
    @inUserId INT = NULL
)
AS
BEGIN


    SET NOCOUNT ON;

	--DECLARE @SessionId INT = NULL;
 --   DECLARE @SchoolGroupId INT = NULL;
 --   DECLARE @SchoolClassId INT = NULL;
 --   DECLARE @ExamName NVARCHAR(200) = NULL; 
 --   DECLARE @ExamScheduleStatus INT = NULL; 
 --   DECLARE @ExamTypeId INT = NULL; 
 --   DECLARE @ExamCategoryId INT = NULL;  
 --   DECLARE @inSortColumn INT = 1;
 --   DECLARE @stSortOrder NVARCHAR(4) = 'DESC';
 --   DECLARE @inPageNo INT = 1;   
 --   DECLARE @inPageSize INT = 10;
 --   DECLARE @tabtype INT;
 --   DECLARE @inUserId INT = NULL;

	--SET @tabtype = 2;
    
    DECLARE @stSort NVARCHAR(100) = 'inExamScheduleDetailId';
    DECLARE @inStart INT = (@inPageNo - 1) * @inPageSize + 1;
    DECLARE @inEnd INT = @inPageNo * @inPageSize;

    -- Determine sorting column
    IF @inSortColumn = 2 SET @stSort = 'stExamName';
    IF @inSortColumn = 3 SET @stSort = 'inExamTypeId';
    IF @inSortColumn = 4 SET @stSort = 'inExamCategoryId';
    IF @inSortColumn = 5 SET @stSort = 'ScheduleStartDate';
    IF @inSortColumn = 6 SET @stSort = 'ScheduleEndDate';

    WITH ScheduleDateRange AS (
        SELECT 
            SD.inExamScheduleDetailId,  
            SD.unExamScheduleDetailId,  
            SD.stExamName,  
            SD.inExamTypeId,  
            SD.inExamCategoryId,  
            SD.inStatus,  
            SD.inScheduleStatus,  
            SD.inSaveType,  
            SD.inSchoolProgramId,
			SD.inAcademicSessionId,
			MIN(SSD.dtStartDate) AS ScheduleStartDate,
			MAX(SSD.dtEndDate) AS ScheduleEndDate,
			COUNT(SSD.dtStartDate) AS StartDateCount,
			COUNT(SSD.dtEndDate) AS EndDateCount
			
        FROM 
            T_ERP_Exam_SchedulesDetails SD
        INNER JOIN 
            T_ERP_Exam_ScheduleSubjects SSD 
            ON SD.inExamScheduleDetailId = SSD.inExamScheduleDetailId
        WHERE 
		(
            (@ExamName IS NULL OR SD.inExamScheduleDetailId IN (SELECT Value FROM dbo.SplitString(@ExamName, ',')))
            AND (@ExamTypeId IS NULL OR SD.inExamTypeId IN (SELECT Value FROM dbo.SplitString(@ExamTypeId, ',')))
            AND (@ExamCategoryId IS NULL OR SD.inExamCategoryId IN (SELECT Value FROM dbo.SplitString(@ExamCategoryId, ',')))
            AND (@SessionId IS NULL OR SD.inAcademicSessionId = @SessionId)
            AND (@SchoolGroupId IS NULL OR SD.inSchoolProgramId = @SchoolGroupId)
			AND (@SchoolClassId IS NULL OR SSD.inClassId in (SELECT Value FROM dbo.SplitString(@SchoolClassId, ',')))
			AND (@ExamScheduleStatus IS NULL OR SD.inSaveType = @ExamScheduleStatus)
		)
        GROUP BY 
            SD.inExamScheduleDetailId, 
            SD.unExamScheduleDetailId,  
            SD.stExamName,  
            SD.inExamTypeId,  
            SD.inExamCategoryId,  
            SD.inStatus,  
            SD.inScheduleStatus,  
            SD.inSaveType,  
            SD.inSchoolProgramId,
			SD.inAcademicSessionId
    )
	--SELECT * FROM ScheduleDateRange
	,
	 FilteredExams AS (
		SELECT * 
		FROM ScheduleDateRange SDR
		WHERE 
			-- Apply the filter based on @tabtype
			(
				-- Upcoming Exams (tabtype = 1)
				(@tabtype = 1 AND (SDR.StartDateCount = 0 AND SDR.EndDateCount = 0 OR GETDATE() < SDR.ScheduleStartDate))
				OR 
				-- Ongoing Exams (tabtype = 3)
				(@tabtype = 3 AND GETDATE() BETWEEN SDR.ScheduleStartDate AND SDR.ScheduleEndDate)
				OR 
				-- Previous Exams (tabtype = 2)
				(@tabtype = 2 AND GETDATE() > SDR.ScheduleEndDate)
			)
	)
	--SELECT * FROM FilteredExams;
	,
    PAGED AS (
        SELECT 
            '0' AS inRownumber,
            SDR.inExamScheduleDetailId,  
            SDR.unExamScheduleDetailId,  
            SDR.stExamName,  
            SDR.inExamTypeId,  
            SDR.inExamCategoryId,  
            SDR.inStatus,  
            SDR.inScheduleStatus,  
            SDR.inSaveType,  
            SDR.ScheduleStartDate,  
            SDR.ScheduleEndDate,
            SC.S_School_Group_Name AS sSchoolProgram,
            STUFF((
                SELECT DISTINCT ',' + ISNULL(C.S_Class_Name, '') 
                FROM T_ERP_Exam_ScheduleSubjects SS 
                LEFT JOIN T_Class C ON C.I_Class_ID = SS.inClassId
                WHERE SS.inExamScheduleDetailId = SDR.inExamScheduleDetailId
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS stClassName
        FROM 
            FilteredExams SDR
        LEFT JOIN 
            T_School_Group SC ON SC.I_School_Group_ID = SDR.inSchoolProgramId
    )
    SELECT 
        (SELECT COUNT(*) FROM PAGED) AS inRecordCount,
        *
    FROM 
        PAGED
END;


