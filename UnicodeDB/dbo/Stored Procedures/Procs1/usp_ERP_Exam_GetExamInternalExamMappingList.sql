CREATE PROC [dbo].[usp_ERP_Exam_GetExamInternalExamMappingList]
(
    @SessionId INT = NULL,
    @SchoolGroupId INT = NULL,
    @SchoolClassId NVARCHAR(MAX) = NULL,
    @ExamName NVARCHAR(200) = NULL,
    @ExamScheduleStatus INT = NULL,
    @ExamTypeId INT = NULL,
    @ExamCategoryId NVARCHAR(200) = NULL,
    @inSortColumn INT = NULL,
    @stSortOrder NVARCHAR(51) = NULL,
    @inPageNo INT = 1,
    @inPageSize INT = 10,
    @tabtype INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @stSQL AS NVARCHAR(MAX);
    DECLARE @stSort AS NVARCHAR(MAX) = 'inExamScheduleDetailId';
    DECLARE @inStart INT, @inEnd INT;

    SET @stSortOrder = ISNULL(@stSortOrder, 'DESC');
    SET @inStart  = (@inPageNo - 1) * @inPageSize + 1;
    SET @inEnd  = @inPageNo * @inPageSize;

    -- Determine sorting column
    IF @inSortColumn = 1 
        SET @stSort = 'inExamScheduleDetailId';
    ELSE IF @inSortColumn = 2
        SET @stSort = 'stExamName';
    ELSE IF @inSortColumn = 3
        SET @stSort = 'inExamTypeId';
    ELSE IF @inSortColumn = 4
        SET @stSort = 'inExamCategoryId';
    ELSE IF @inSortColumn = 5
        SET @stSort = 'dtCreatedDate';
    ELSE IF @inSortColumn = 6
        SET @stSort = 'dtModifiedDate';

    -- Start constructing the main SQL query
    SET @stSQL = '
    WITH PAGED AS (
        SELECT 
            CAST(ROW_NUMBER() OVER(ORDER BY SD.' + QUOTENAME(@stSort) + ' ' + ISNULL(@stSortOrder, 'ASC') + ') AS INT) AS inRownumber, 
            SD.inExamScheduleDetailId AS inExamScheduleDetailId,
            SD.unExamScheduleDetailId,
            SD.stExamName,
            SD.inExamTypeId,
            SD.inExamCategoryId,
            SC.S_School_Group_Name AS sSchoolProgram,
            C.I_Class_ID AS inClassId,
            C.S_Class_Name +'' - ''+  SCT.S_Section_Name  AS stClassName,
            SSD.inMappingStatus AS inStatus,
            SD.inScheduleStatus,
            SD.inSaveType,
            ETM.stExamTypeName,
            EEC.stExamCategoryName,
            ST.I_Stream_ID AS inStreamId,
            ST.S_Stream AS stStreamName,
            SCT.I_Section_ID AS inSectionId,
            SCT.S_Section_Name AS stSectionName,
            SSD.inSubjectID,
            SSD.stSubjectName,
            SSD.inSubjectTypeID,
            SSD.stSubjectTypeName,
            SSD.inSubjectComponentID,
            SSD.stSubjectComponentName,
            SSD.inExamScheduleSubjectDetailId,
            SSD.unExamScheduleSubjectDetailId
        FROM 
            T_ERP_Exam_SchedulesDetails SD
            LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SSD ON SSD.inExamScheduleDetailId = SD.inExamScheduleDetailId
            LEFT JOIN T_School_Group SC ON SC.I_School_Group_ID = SD.inSchoolProgramId
            LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId
            LEFT JOIN T_ERP_EXAM_CATEGORY EEC ON EEC.inExamCategoryId = SD.inExamCategoryId
            LEFT JOIN T_Class C ON C.I_Class_ID = SSD.inClassId
            LEFT JOIN T_Stream ST ON ST.I_Stream_ID = SSD.inStreamId
            LEFT JOIN T_Section SCT ON SCT.I_Section_ID = SSD.inSectionId
        WHERE 
            ETM.IsMainExam = 1 AND SD.inSaveType = 2';

    -- Apply filters
    IF @SessionId IS NOT NULL
        SET @stSQL = @stSQL + ' AND SD.inAcademicSessionId = @SessionId';

    IF @ExamCategoryId IS NOT NULL
        SET @stSQL = @stSQL + ' AND SD.inExamCategoryId IN (SELECT CAST(Value AS INT) FROM dbo.SplitString(@ExamCategoryId, '',''))';

    IF @SchoolGroupId IS NOT NULL
        SET @stSQL = @stSQL + ' AND SD.inSchoolProgramId = @SchoolGroupId';

    IF @SchoolClassId IS NOT NULL
        SET @stSQL = @stSQL + ' AND SSD.inClassId IN (SELECT CAST(Value AS INT) FROM dbo.SplitString(@SchoolClassId, '',''))';

    IF @ExamName IS NOT NULL
        SET @stSQL = @stSQL + ' AND SD.inExamScheduleDetailId IN (SELECT CAST(Value AS INT) FROM dbo.SplitString(@ExamName, '',''))';

    SET @stSQL = @stSQL + '
    GROUP BY 
        SD.inExamScheduleDetailId,
        SD.unExamScheduleDetailId,
        SD.stExamName,
        SD.inExamTypeId,
        SD.inExamCategoryId,
        SC.S_School_Group_Name,
        SSD.inMappingStatus,
        SD.inScheduleStatus,
        SD.inSaveType,
        ETM.stExamTypeName,
        EEC.stExamCategoryName,
        C.I_Class_ID,
        C.S_Class_Name,
        ST.I_Stream_ID,
        ST.S_Stream,
        SCT.I_Section_ID,
        SCT.S_Section_Name,
        SSD.inSubjectID,
        SSD.stSubjectName,
        SSD.inSubjectTypeID,
        SSD.stSubjectTypeName,
        SSD.inSubjectComponentID,
        SSD.stSubjectComponentName,
        SSD.inExamScheduleSubjectDetailId,
        SSD.unExamScheduleSubjectDetailId
    )
    SELECT 
        (SELECT CAST(COUNT(*) AS INT) FROM PAGED) AS inRecordCount,
        * 
    FROM 
        PAGED 
    WHERE 
        inRownumber BETWEEN ' + CONVERT(NVARCHAR(11), @inStart) + ' AND ' + CONVERT(NVARCHAR(11), @inEnd) + '';

    PRINT(@stSQL);

    EXEC sp_executesql @stSQL,
        N'@SessionId INT, @SchoolGroupId INT, @SchoolClassId VARCHAR(200), @ExamName NVARCHAR(200), @ExamScheduleStatus INT, @ExamCategoryId NVARCHAR(200)',
        @SessionId, @SchoolGroupId, @SchoolClassId, @ExamName, @ExamScheduleStatus, @ExamCategoryId;
END;

