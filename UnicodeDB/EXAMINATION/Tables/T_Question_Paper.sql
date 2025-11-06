CREATE TABLE [EXAMINATION].[T_Question_Paper] (
    [I_Question_Paper_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Exam_ID]           INT          NULL,
    [I_Question_ID]       INT          NULL,
    [I_Student_detail_ID] INT          NULL,
    [S_Crtd_By]           VARCHAR (20) NULL,
    [S_Upd_By]            VARCHAR (20) NULL,
    [Dt_Crtd_On]          DATETIME     NULL,
    [Dt_Upd_On]           DATETIME     NULL,
    CONSTRAINT [PK__T_Question_Paper__2F65D18D] PRIMARY KEY CLUSTERED ([I_Question_Paper_ID] ASC)
);

