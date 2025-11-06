CREATE PROCEDURE [dbo].[usp_ERP_Savings_Grade_Pattern]
    @h_I_Exam_Grade_Master_Header_ID INT = NULL,
    @Grade_Name NVARCHAR(max),
    @p_I_CreatedBy int,
    @Is_Active Int Null,
    @Grade_PatternDetails [UT_Grade_Pattern_Details] READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @OperationType NVARCHAR(max); -- Variable to track the operation type

        -- Check for duplicate Grade_Name
        IF EXISTS (
            SELECT 1 
            FROM T_ERP_Exam_Grade_Master_Header 
            WHERE stGradeHederName = @Grade_Name
              AND (@h_I_Exam_Grade_Master_Header_ID IS NULL 
                   OR inExamGradeHederId != @h_I_Exam_Grade_Master_Header_ID)
        )
        BEGIN
            SELECT 0 AS StatusFlag, 'Grade Pattern Name already exists. Please use a different name.' AS Message;
            ROLLBACK;
            RETURN;
        END

        -- Insert or Update Header Record
        IF @h_I_Exam_Grade_Master_Header_ID IS NULL
        BEGIN
            INSERT INTO T_ERP_Exam_Grade_Master_Header
            (
                stGradeHederName,
                dtCreatedDate,
                inCreatedBy,
                IsActive
            )
            VALUES
            (
                @Grade_Name, 
                GETDATE(), 
                @p_I_CreatedBy, 
                @Is_Active
            );
            
            SET @h_I_Exam_Grade_Master_Header_ID = SCOPE_IDENTITY();
            SET @OperationType = 'Added'; -- Set operation type to 'Added'
        END
        ELSE
        BEGIN
            UPDATE T_ERP_Exam_Grade_Master_Header
            SET stGradeHederName = @Grade_Name,
                dtModifiedDate = GETDATE(),
                inModifiedBy = @p_I_CreatedBy,
                IsActive = @Is_Active
            WHERE inExamGradeHederId = @h_I_Exam_Grade_Master_Header_ID;

            SET @OperationType = 'Updated'; -- Set operation type to 'Updated'
        END

        -- Merge operation for details
        MERGE INTO T_ERP_Exam_Grade_Master AS target
        USING @Grade_PatternDetails AS Source
        ON target.inExamGradeID = Source.I_Exam_Grade_Master_Details_ID
           AND target.inExamGradeHederId = Source.I_Exam_Grade_Master_Header_ID
        WHEN MATCHED THEN
            UPDATE SET stSymbol = Source.Grade_Type,
                       inLowerLimit = Source.I_Lower_Limit,
                       inUpperLimit = Source.I_Upper_Limit,
                       stRemarks = Source.S_Remarks,
                       IsActive = Source.Is_Active,
                       dtModifiedDate = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT
            (
                inExamGradeHederId,
                stSymbol,
                inLowerLimit,
                inUpperLimit,
                stRemarks,
                inCreatedBy,
                dtCreatedDate,
                IsActive
            )
            VALUES
            (
                @h_I_Exam_Grade_Master_Header_ID,
                Source.Grade_Type,
                Source.I_Lower_Limit,
                Source.I_Upper_Limit,
                Source.S_Remarks,
                @p_I_CreatedBy,
                GETDATE(),
                Source.[Is_Active]
            )
        WHEN NOT MATCHED BY SOURCE
        AND target.inExamGradeHederId = @h_I_Exam_Grade_Master_Header_ID
        THEN
            UPDATE SET IsActive = 0,
                       dtModifiedDate = GETDATE();

        -- Select appropriate message based on operation type
        SELECT 
            1 AS StatusFlag,
            CASE 
                WHEN @OperationType = 'Added' THEN 'Grade Pattern Added'
                WHEN @OperationType = 'Updated' THEN 'Grade Pattern Updated'
            END AS Message;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        DECLARE @ErrMsg NVARCHAR(max),
                @ErrSeverity INT;

        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();

        SELECT @ErrMsg AS Message, 0 AS StatusFlag;
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH;
END;


