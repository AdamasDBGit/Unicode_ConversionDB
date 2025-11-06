CREATE PROCEDURE [dbo].[usp_ERP_Delete_Grade_Pattern]
    @h_I_Exam_Grade_Master_Header_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if the grade pattern exists
        IF EXISTS (SELECT 1 FROM T_ERP_Exam_Grade_Master_Header WHERE inExamGradeHederId = @h_I_Exam_Grade_Master_Header_ID)
        BEGIN
            -- Deactivate related grade patterns
            UPDATE T_ERP_Exam_Grade_Master
            SET IsActive = 0
              , dtModifiedDate = GETDATE()
            WHERE inExamGradeHederId = @h_I_Exam_Grade_Master_Header_ID;

            -- Delete the grade header
            DELETE FROM T_ERP_Exam_Grade_Master_Header
            WHERE inExamGradeHederId = @h_I_Exam_Grade_Master_Header_ID;

            -- Return success message
            SELECT 
                1 AS StatusFlag,
                'Grade Pattern Deleted' AS Message;
        END
        ELSE
        BEGIN
            -- If no record found, return an error message
            SELECT 
                0 AS StatusFlag,
                'Grade Pattern Not Found' AS Message;
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        DECLARE @ErrMsg NVARCHAR(max)
              , @ErrSeverity INT;

        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();

        SELECT @ErrMsg AS Message, 0 AS StatusFlag;
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH;
END;
