CREATE PROCEDURE [dbo].[uspInsertMarksTemp]
(
@StdID INT,
@TermID INT,
@ModuleID INT,
@CompID INT,
@BatchID INT
)
AS
BEGIN

DECLARE @BatchExamID INT

INSERT INTO EXAMINATION.T_Batch_Exam_Map
    (
        I_Batch_ID,
        I_Term_ID,
        I_Module_ID,
        I_Exam_Component_ID,
        I_Status,
        S_Crtd_By,
        Dt_Crtd_On,
        S_Updt_By,
        Dt_Updt_On,
        B_Optional
    )
VALUES
    (
        @BatchID,         -- I_Batch_ID - int
        @TermID,         -- I_Term_ID - int
        @ModuleID,         -- I_Module_ID - int
        @CompID,         -- I_Exam_Component_ID - int
        1,         -- I_Status - int
        'rice-group-admin',        -- S_Crtd_By - nvarchar(max)
        GETDATE(), -- Dt_Crtd_On - datetime
        NULL,        -- S_Updt_By - nvarchar(max)
        NULL, -- Dt_Updt_On - datetime
        NULL       -- B_Optional - bit
    )

SET @BatchExamID=SCOPE_IDENTITY()

INSERT INTO EXAMINATION.T_Student_Marks
    (
        I_Student_Detail_ID,
        I_Exam_ID,
        I_Exam_Total,
        S_Crtd_By,
        S_Upd_By,
        Dt_Crtd_On,
        Dt_Upd_On,
        Dt_Exam_Date,
        I_Batch_Exam_ID,
        S_Remarks,
        I_Center_ID
    )
VALUES
    (
        @StdID,         -- I_Student_Detail_ID - int
        NULL,         -- I_Exam_ID - int
        NULL,      -- I_Exam_Total - numeric(8, 2)
        'rice-group-admin',        -- S_Crtd_By - nvarchar(max)
        NULL,        -- S_Upd_By - nvarchar(max)
        GETDATE(), -- Dt_Crtd_On - datetime
        NULL, -- Dt_Upd_On - datetime
        GETDATE(), -- Dt_Exam_Date - datetime
        @BatchExamID,         -- I_Batch_Exam_ID - int
        '',        -- S_Remarks - nvarchar(max)
        1          -- I_Center_ID - int
    )

END
