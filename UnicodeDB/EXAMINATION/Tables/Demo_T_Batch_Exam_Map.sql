CREATE TABLE [EXAMINATION].[Demo_T_Batch_Exam_Map] (
    [I_Batch_Exam_ID]     INT          IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]          INT          NOT NULL,
    [I_Term_ID]           INT          NOT NULL,
    [I_Module_ID]         INT          NULL,
    [I_Exam_Component_ID] INT          NOT NULL,
    [I_Status]            INT          NULL,
    [S_Crtd_By]           VARCHAR (20) NULL,
    [Dt_Crtd_On]          DATETIME     NULL,
    [S_Updt_By]           VARCHAR (20) NULL,
    [Dt_Updt_On]          DATETIME     NULL,
    [B_Optional]          BIT          NULL
);

