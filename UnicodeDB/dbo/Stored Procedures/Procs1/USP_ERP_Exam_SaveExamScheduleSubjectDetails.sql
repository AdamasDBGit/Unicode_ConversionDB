CREATE PROCEDURE [dbo].[USP_ERP_Exam_SaveExamScheduleSubjectDetails]
	@SaveType INT,
	@CreatedBy INT,
    @ExamScheduleSubjectDetails dbo.UT_ExamScheduleSubjectTableType READONLY 
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

			UPDATE ess
			SET        
				ess.inDisplaySeq = esst.inDisplaySeq,
				ess.inExamMode = esst.inExamMode,
				ess.inExamPlatform = esst.inExamPlatform,
				ess.dcFullMarks = esst.dcFullMarks,
				ess.dcMainExamFullMarks = esst.dcMainExamFullMarks,
				ess.dcInternalFullMarks = esst.dcInternalFullMarks,
				ess.dcOrderallPassMarks = esst.dcOrderallPassMarks,
				ess.isPassMandatory = esst.isPassMandatory,
				ess.dtStartDate = esst.dtStartDate,
				ess.dtEndDate = esst.dtEndDate,
				ess.inExamSlotId = esst.inExamSlotId,
				ess.isDisplayOnApp = esst.isDisplayOnApp,
				ess.inExamInvigilatorId = esst.inExamInvigilatorId,
				ess.inExamGraderId = esst.inExamGraderId,
				ess.inModifiedBy = esst.inModifiedBy,
				ess.dtModifiedDate = GETDATE()
			FROM 
				[dbo].[T_ERP_Exam_ScheduleSubjects] ess
			INNER JOIN 
				@ExamScheduleSubjectDetails esst 
			ON 
				ess.inClassId = esst.inClassId 
				AND ess.inSectionId = esst.inSectionId 
				AND ess.inSubjectID = esst.inSubjectID 
				AND ess.inExamScheduleDetailId = esst.inExamScheduleDetailId
				AND ess.inSubjectTypeID = esst.inSubjectTypeID
				AND (
						ess.inSubjectComponentID = esst.inSubjectComponentID OR 
						esst.inSubjectComponentID IS NULL)
			


		UPDATE esd
            SET 
                esd.inSaveType = 1
            FROM 
                [dbo].[T_ERP_Exam_SchedulesDetails] esd
            INNER JOIN 
                @ExamScheduleSubjectDetails esst
            ON 
                esd.inExamScheduleDetailId = esst.inExamScheduleDetailId;
		
		 IF @SaveType = 1
			BEGIN
				INSERT INTO [dbo].[T_ERP_Exam_ScheduleSubjectDetails]
				(
					inExamScheduleDetailId,
					inClassId,
					stClassName,
					inStreamId,
					stStreamName,
					inSectionId,
					stSectionName,
					inSubjectTypeID,
					stSubjectTypeName,
					inSubjectID,
					stSubjectName,
					inSubjectComponentID,
					stSubjectComponentName,
					inDisplaySeq,
					inExamMode,
					inExamPlatform,
					dcFullMarks,
					dcMainExamFullMarks,
					dcInternalFullMarks,
					dcOrderallPassMarks,
					isPassMandatory,
					dtStartDate,
					dtEndDate,
					inExamSlotId,
					stExamSlotId,
					isDisplayOnApp,
					inExamInvigilatorId,
					stExamInvigilatorName,
					inExamGraderId,
					stExamGraderName,
					inCreatedBy,
					dtCreatedDate
				)
				SELECT 
					inExamScheduleDetailId,
					inClassId,
					C.S_Class_Name,
					inStreamId,
					S.S_Stream,
					inSectionId,
					CS.S_Section_Name,
					inSubjectTypeID,
					ST.S_Subject_Type,
					inSubjectID,
					SM.S_Subject_Name,
					inSubjectComponentID,
					ESC.S_Subject_Component_Name,
					inDisplaySeq,
					ESSD.inExamMode,
					ESSD.inExamPlatform,
					dcFullMarks,
					dcMainExamFullMarks,
					dcInternalFullMarks,
					dcOrderallPassMarks,
					isPassMandatory,
					dtStartDate,
					dtEndDate,
					inExamSlotId,
					NULL,
					isDisplayOnApp,
					inExamInvigilatorId,
					NULL,
					inExamGraderId,
					NULL,
					@CreatedBy,
					GETDATE() 
				FROM 
					@ExamScheduleSubjectDetails ESSD 
					JOIN T_Class C ON C.I_Class_ID = ESSD.inClassId
					LEFT JOIN T_Stream S ON S.I_Stream_ID = ESSD.inStreamId
					LEFT JOIN T_Section CS ON CS.I_Section_ID = ESSD.inSectionId
					LEFT JOIN T_Subject_Master SM ON SM.I_Subject_ID = ESSD.inSubjectID
					LEFT JOIN T_Subject_Type ST ON ST.I_Subject_Type_ID = ESSD.inSubjectTypeID
					LEFT JOIN T_ERP_Subject_Component ESC ON ESC.I_Subject_Component_ID = ESSD.inSubjectComponentID


				UPDATE esd
				SET 
					esd.inSaveType = 2
				FROM 
					[dbo].[T_ERP_Exam_SchedulesDetails] esd
				INNER JOIN 
					@ExamScheduleSubjectDetails esst
				ON 
					esd.inExamScheduleDetailId = esst.inExamScheduleDetailId;
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