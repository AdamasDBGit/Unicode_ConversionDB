-- Author:  Qutub Haider
-- Create date: 2024-08-08

CREATE PROCEDURE [dbo].[usp_ERP_EXAM_InsertOrUpdateExamScheduleData]
    @inExamScheduleDetailId INT = NULL,  
    @stExamName NVARCHAR(200),
    @inExamTypeId INT,
    @inExamCategoryId INT = NULL,
    @inAcademicSessionId INT,
    @inSchoolProgramId INT,
    @inAdmitCardTemplateId INT = NULL,
    @inReportCardTemplateId INT = NULL,
    @inMarksEntryStartAfterExamDays INT = NULL,
    @inMarksEntryCloseDays INT = NULL,
    @inGradingSchemeId INT = NULL,
    @inMarksAndGradePattern INT = NULL,
    @inInternalExamWeightage INT = NULL,
    @inMainInternalExamWeightage INT = NULL,
    @inTotalWeightage INT = NULL,
    @inBrandId INT = NULL,
    @inCreatedBy INT = NULL,
    @tempExamClassStreamSectionInfo dbo.UT_Exam_ClassStreamSectionInfo ReadOnly
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate if the subject exists
        IF NOT EXISTS (
            SELECT 1 
            FROM @tempExamClassStreamSectionInfo temp
            JOIN T_Subject_Master SM ON 
                SM.I_School_Group_ID = @inSchoolProgramId AND
                SM.I_Brand_ID = @inBrandId AND
                (SM.I_Class_ID = temp.inClassId OR SM.I_Stream_ID = temp.inStreamId)
        )
        BEGIN
            SELECT 0 AS StatusFlag, 'No subjects available for the given class, stream, or school program.' AS Message;
            RETURN;
        END

        BEGIN TRANSACTION;

        -- Main Exam Schedule Details Merge
        MERGE INTO [dbo].[T_ERP_Exam_SchedulesDetails] AS target
        USING (SELECT @inExamScheduleDetailId AS inExamScheduleDetailId) AS source
        ON target.inExamScheduleDetailId = source.inExamScheduleDetailId
        WHEN MATCHED THEN
            UPDATE SET
                stExamName = @stExamName,
                inExamTypeId = @inExamTypeId,
                inExamCategoryId = @inExamCategoryId,
                inAcademicSessionId = @inAcademicSessionId,
                inSchoolProgramId = @inSchoolProgramId,
                inAdmitCardTemplateId = @inAdmitCardTemplateId,
                inReportCardTemplateId = @inReportCardTemplateId,
                inMarksEntryStartAfterExamDays = @inMarksEntryStartAfterExamDays,
                inMarksEntryCloseDays = @inMarksEntryCloseDays,
                inGradingSchemeId = @inGradingSchemeId,
                inExamGradeID = @inMarksAndGradePattern,
                inInternalExamWeightage = @inInternalExamWeightage,
                inMainInternalExamWeightage = @inMainInternalExamWeightage,
                inTotalWeightage = @inTotalWeightage,
                inBrandId = @inBrandId,
                inModifiedBy = @inCreatedBy,
                dtModifiedDate = GETDATE(),
                inSaveType = 0
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                stExamName,
                inExamTypeId,
                inExamCategoryId,
                inAcademicSessionId,
                inSchoolProgramId,
                inAdmitCardTemplateId,
                inReportCardTemplateId,
                inMarksEntryStartAfterExamDays,
                inMarksEntryCloseDays,
                inGradingSchemeId,
                inExamGradeID,
                inInternalExamWeightage,
                inMainInternalExamWeightage,
                inTotalWeightage,
                inBrandId,
                inCreatedBy,
                dtCreatedDate,
                inScheduleStatus,
                inAttendanceStatus,
                inSaveType
            )
            VALUES (
                @stExamName,
                @inExamTypeId,
                @inExamCategoryId,
                @inAcademicSessionId,
                @inSchoolProgramId,
                @inAdmitCardTemplateId,
                @inReportCardTemplateId,
                @inMarksEntryStartAfterExamDays,
                @inMarksEntryCloseDays,
                @inGradingSchemeId,
                @inMarksAndGradePattern,
                @inInternalExamWeightage,
                @inMainInternalExamWeightage,
                @inTotalWeightage,
                @inBrandId,
                @inCreatedBy,
                GETDATE(),
                1,
                1,
                0
            );

        SET @inExamScheduleDetailId = (SELECT ISNULL(@inExamScheduleDetailId, SCOPE_IDENTITY()));

        -- Exam Schedule Subjects Merge
        MERGE INTO T_ERP_Exam_ScheduleSubjects AS target
        USING (
            SELECT 
                @inExamScheduleDetailId AS inExamScheduleDetailId,
                temp.inClassId, 
                temp.inStreamId, 
                temp.inSectionId,
                SM.I_Subject_ID AS inSubjectID,
                SM.I_Subject_Type AS inSubjectTypeID,
                SCM.I_Subject_Component_ID AS inSubjectComponentID
            FROM @tempExamClassStreamSectionInfo AS temp
            JOIN T_Subject_Master AS SM ON
                SM.I_School_Group_ID = @inSchoolProgramId AND
                SM.I_Brand_ID = @inBrandId AND
                (SM.I_Class_ID = temp.inClassId OR SM.I_Stream_ID = temp.inStreamId)
            LEFT JOIN T_ERP_Subject_Component_Mapping AS SCM
                ON SCM.I_Subject_ID = SM.I_Subject_ID AND SCM.Is_Active = 1
        ) AS source
        ON target.inExamScheduleDetailId = source.inExamScheduleDetailId
           AND target.inClassId = source.inClassId
           AND target.inStreamId = source.inStreamId
           AND target.inSectionId = source.inSectionId
        WHEN MATCHED THEN
            UPDATE SET
                target.inClassId = source.inClassId,
                target.inStreamId = source.inStreamId,
                target.inSectionId = source.inSectionId,
                target.inSubjectID = source.inSubjectID,
                target.inSubjectTypeID = source.inSubjectTypeID,
                target.inSubjectComponentID = source.inSubjectComponentID,
                target.inModifiedBy = @inCreatedBy,
                target.dtModifiedDate = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                inExamScheduleDetailId, 
                inClassId, 
                inStreamId, 
                inSectionId, 
                inSubjectID, 
                inSubjectTypeID, 
                inSubjectComponentID, 
                inCreatedBy, 
                dtCreatedDate
            )
            VALUES (
                @inExamScheduleDetailId, 
                source.inClassId, 
                source.inStreamId, 
                source.inSectionId, 
                source.inSubjectID, 
                source.inSubjectTypeID, 
                source.inSubjectComponentID, 
                @inCreatedBy, 
                GETDATE()
            );

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
