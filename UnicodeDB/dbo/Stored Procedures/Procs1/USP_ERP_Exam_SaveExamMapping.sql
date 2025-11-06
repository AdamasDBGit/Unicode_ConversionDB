CREATE PROCEDURE [dbo].[USP_ERP_Exam_SaveExamMapping]
    @ExamMapping dbo.UT_Exam_ExamMappingType READONLY,
    @SaveType INT,
    @CreatedBy INT 
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

    DECLARE @inMapExamId INT;
   
    SELECT TOP 1 @inMapExamId = inMapExamId
    FROM T_ERP_Exam_MapExam
    WHERE inExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping);

    IF @inMapExamId IS NULL
    BEGIN
        INSERT INTO T_ERP_Exam_MapExam (inExamScheduleDetailId, inCreatedBy, dtCreatedDate)
        VALUES ((SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping), @CreatedBy, GETDATE());

        SET @inMapExamId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE T_ERP_Exam_MapExam
        SET inModifiedBy = @CreatedBy,
            dtModifiedDate = GETDATE()
        WHERE inMapExamId = @inMapExamId;
    END

    MERGE INTO T_ERP_Exam_MapExamDetails AS target
    USING @ExamMapping AS source
    ON target.inMapExamId = @inMapExamId
       AND target.inExamScheduleDetailId = source.inExamScheduleDetailId
       AND target.inMapWithExamId = source.inMapWithExamId
	   AND target.inClassId = source.inClassId
	   AND target.inSubjectId = source.inSubjectId
	   AND target.inSubjectTypeId = source.inSubjectTypeId
	   AND target.inSubjectComponentID = source.inSubjectComponentID
	   AND target.inSectionId = source.inSectionId
	   AND target.inStreamId = source.inStreamId
    WHEN MATCHED THEN
        UPDATE SET 
            target.dcFullMarks = source.dcFullMarks,
            target.dcAvgClassMarks = source.dcAvgClassMarks,
            target.dcWeightageInMainExam = source.dcWeightageInMainExam,
			target.inClassId = source.inClassId,
			target.inSubjectId = source.inSubjectId,
			target.inSubjectTypeID = source.inSubjectTypeID,
			target.inSubjectComponentID = source.inSubjectComponentID,
			target.inSectionId = source.inSectionId,
			target.inStreamId = source.inStreamId,
            target.inModifiedBy = @CreatedBy,
            target.dtModifiedDate = GETDATE()
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (inMapExamId, inExamScheduleDetailId, inMapWithExamId, dcFullMarks, dcAvgClassMarks, dcWeightageInMainExam, inCreatedBy, dtCreatedDate, inClassId, inSubjectId, inSubjectTypeID, inSubjectComponentID,inSectionId, inStreamId)
        VALUES (@inMapExamId, source.inExamScheduleDetailId, source.inMapWithExamId, source.dcFullMarks, source.dcAvgClassMarks, source.dcWeightageInMainExam, @CreatedBy, GETDATE() ,source.inClassId, source.inSubjectId,
				source.inSubjectTypeID, source.inSubjectComponentID, source.inSectionId, source.inStreamId);

   
        IF @SaveType = 1
        BEGIN
            UPDATE T_ERP_Exam_SchedulesDetails 
            SET inMappingStatus = 3
            WHERE inExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping);

            UPDATE T_ERP_Exam_ScheduleSubjectDetails
            SET 
                inMappingStatus = 3
            WHERE inExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping)
              AND inClassId = (SELECT TOP 1 inClassId FROM @ExamMapping)
              AND inSubjectId = (SELECT TOP 1 inSubjectId FROM @ExamMapping)
              AND inSubjectTypeID = (SELECT TOP 1 inSubjectTypeID FROM @ExamMapping)
              AND inSubjectComponentID = (SELECT TOP 1 inSubjectComponentID FROM @ExamMapping)
			  AND inSectionId = (SELECT TOP 1 inSectionId FROM @ExamMapping)
			  AND inStreamId = (SELECT TOP 1 inStreamId FROM @ExamMapping);
        END
		ELSE IF @SaveType = 0
		BEGIN
            UPDATE T_ERP_Exam_SchedulesDetails 
            SET inMappingStatus = 2
            WHERE inExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping);

            UPDATE T_ERP_Exam_ScheduleSubjectDetails
            SET 
                inMappingStatus = 2
            WHERE inExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId FROM @ExamMapping)
              AND inClassId = (SELECT TOP 1 inClassId FROM @ExamMapping)
              AND inSubjectId = (SELECT TOP 1 inSubjectId FROM @ExamMapping)
              AND inSubjectTypeID = (SELECT TOP 1 inSubjectTypeID FROM @ExamMapping)
              AND inSubjectComponentID = (SELECT TOP 1 inSubjectComponentID FROM @ExamMapping)
			  AND inSectionId = (SELECT TOP 1 inSectionId FROM @ExamMapping)
			  AND inStreamId = (SELECT TOP 1 inStreamId FROM @ExamMapping);
        END

    
    COMMIT TRANSACTION;
       
        SELECT 1 AS StatusFlag, 'Exam schedule saved successfully!' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
 ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END

