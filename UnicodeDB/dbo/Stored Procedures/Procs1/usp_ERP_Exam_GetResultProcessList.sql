-- =============================================        
-- Author:  Qutub Haider        
-- Create date: 26th July 2024        
-- Description: Get Exam Attendance List        
-- =============================================        
--EXEC [usp_ERP_Exam_GetResultProcessList] 35,null, null,'126',null,null,null,1,'desc',1,10    
CREATE PROC [dbo].[usp_ERP_Exam_GetResultProcessList]         
(           
    @SessionId INT = NULL,        
    @SchoolGroupId INT = NULL,        
	@SchoolClassId NVARCHAR(200) = NULL,        
    @ExamName NVARCHAR(200) = NULL,        
    @ExamScheduleStatus INT = NULL,        
	@ExamTypeId NVARCHAR(200) = NULL,        
	@ExamCategoryId NVARCHAR(200) = NULL,        
    @inSortColumn INT = NULL,         
    @stSortOrder NVARCHAR(51) = NULL,         
    @inPageNo INT = 1,         
    @inPageSize INT = 10         
)         
AS         
BEGIN         
    SET NOCOUNT ON;          
        
    DECLARE @stSQL AS NVARCHAR(MAX)         
    DECLARE @stSort AS NVARCHAR(MAX) = 'inExamScheduleDetailId'         
    DECLARE @inStart INT, @inEnd INT         
         
    SET @stSortOrder = ISNULL(@stSortOrder, 'DESC')         
    SET @inStart  = (@inPageNo - 1) * @inPageSize + 1         
    SET @inEnd  = @inPageNo * @inPageSize         
         
    -- Determine sorting column        
    IF @inSortColumn = 1         
    BEGIN         
        SET @stSort = 'inExamScheduleDetailId';         
    END          
    ELSE IF @inSortColumn = 2        
    BEGIN         
        SET @stSort = 'stExamName';         
    END        
    ELSE IF @inSortColumn = 3        
    BEGIN         
        SET @stSort = 'inExamTypeId';         
    END        
    ELSE IF @inSortColumn = 4        
    BEGIN         
        SET @stSort = 'inExamCategoryId';         
    END        
    ELSE IF @inSortColumn = 5        
    BEGIN         
        SET @stSort = 'dtCreatedDate';         
    END        
    ELSE IF @inSortColumn = 6        
    BEGIN         
        SET @stSort = 'dtModifiedDate';         
    END        
        
    SET @stSQL = '        
    WITH PAGED AS (        
			SELECT        
					CAST(ROW_NUMBER() OVER(ORDER BY SD.' + QUOTENAME(@stSort) + ' ' + ISNULL(@stSortOrder,'ASC') + ') AS INT) AS inRownumber,            
					SD.inExamScheduleDetailId AS inExamScheduleDetailId,        
					SD.unExamScheduleDetailId,        
					SD.stExamName,        
					SD.inExamTypeId,        
					SD.inExamCategoryId,        
					SC.S_School_Group_Name AS sSchoolProgram,        
				    SD.inAttendanceStatus,        
				    C.I_Class_ID AS inClassId,        
					C.S_Class_Name AS stClassName,        
					SD.inStatus,        
					SD.inScheduleStatus,  
					SSD.dtPublishDate,
		   ECM.stExamCategoryName,        
		   ETM.stExamTypeName,    
		   --CONVERT(VARCHAR(10), SSD.dtPublishDate, 120) AS dtPublishDate , 
		   SSD.inResultPublishStatus  ,
		   SSD.inResultProcessStatus
				FROM         
					T_ERP_Exam_SchedulesDetails SD        
					LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SSD ON SSD.inExamScheduleDetailId = SD.inExamScheduleDetailId        
					LEFT JOIN T_School_Group SC ON SC.I_School_Group_ID = SD.inSchoolProgramId        
		   LEFT JOIN T_ERP_Exam_Slot_Master SM ON SM.inSlotID= SSD.inExamSlotId        
		   LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId        
			  LEFT JOIN T_ERP_Exam_Category ECM ON ECM.inExamCategoryId = SD.inExamCategoryId        
		   LEFT JOIN T_Class C ON C.I_Class_ID = SSD.inClassId        
		   LEFT JOIN T_Stream ST ON ST.I_Stream_ID = SSD.inStreamId        
		   LEFT JOIN T_Section SCT ON SCT.I_Section_ID = SSD.inSectionId        
		  WHERE SD.inResultProcessStatus = 2'        
        
		 -- Apply filters
		 IF @SessionId IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inAcademicSessionId = @SessionId'

			IF @ExamTypeId IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inExamTypeId IN (SELECT Value FROM dbo.SplitString(@ExamTypeId, '',''))'

			IF @ExamCategoryId IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inExamCategoryId IN (SELECT Value FROM dbo.SplitString(@ExamCategoryId, '',''))'

		 IF @SchoolGroupId IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inSchoolProgramId = @SchoolGroupId'

		 IF @SchoolClassId IS NOT NULL	
			 SET @stSQL = @stSQL + ' AND SSD.inClassId IN (SELECT Value FROM dbo.SplitString(@SchoolClassId, '',''))';	

		 IF @ExamName IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inExamScheduleDetailId IN (SELECT Value FROM dbo.SplitString(@ExamName, '',''))'

		 IF @ExamScheduleStatus IS NOT NULL
			 SET @stSQL = @stSQL + ' AND SD.inSaveType = @ExamScheduleStatus'       
        
    SET @stSQL = @stSQL + '        
        
  GROUP BY         
            SD.inExamScheduleDetailId,        
            SD.unExamScheduleDetailId,        
            SD.stExamName,        
            SD.inExamTypeId,        
            SD.inExamCategoryId,        
            SC.S_School_Group_Name,        
            SD.inStatus,        
            SD.inScheduleStatus,        
		   SD.inAttendanceStatus,        
		   ECM.stExamCategoryName,        
		   ETM.stExamTypeName,        
		   C.I_Class_ID,        
		   C.S_Class_Name,
		   SSD.dtPublishDate,  
		   SSD.inResultPublishStatus  ,
		   SSD.inResultProcessStatus
        
    )        
    SELECT         
        (SELECT CAST(COUNT(*) AS INT) FROM PAGED) AS inRecordCount,         
        *           
    FROM         
        PAGED         
    WHERE         
        inRownumber BETWEEN ' + CONVERT(NVARCHAR(11), @inStart) + ' AND ' + CONVERT(NVARCHAR(11), @inEnd) + '        
         
    '        
        
    PRINT(@stSQL)         
        
    EXEC sp_executesql @stSQL,        
        N'@SessionId INT, @SchoolGroupId INT, @SchoolClassId NVARCHAR(200), @ExamName NVARCHAR(200), @ExamScheduleStatus INT, @ExamTypeId NVARCHAR(200), @ExamCategoryId NVARCHAR(200)',        
        @SessionId, @SchoolGroupId, @SchoolClassId, @ExamName, @ExamScheduleStatus, @ExamTypeId, @ExamCategoryId        
END 