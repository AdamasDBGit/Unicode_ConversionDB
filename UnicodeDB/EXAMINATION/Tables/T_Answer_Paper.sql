CREATE TABLE [EXAMINATION].[T_Answer_Paper] (
    [I_Answer_Paper_ID]    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Student_Detail_ID]  INT            NULL,
    [I_Question_Paper_ID]  INT            NULL,
    [I_Question_ID]        INT            NULL,
    [I_Question_Choice_ID] INT            NULL,
    [N_Marks]              NUMERIC (8, 2) NULL,
    [S_Crtd_By]            VARCHAR (20)   NULL,
    [S_Upd_By]             VARCHAR (20)   NULL,
    [Dt_Crtd_On]           DATETIME       NULL,
    [Dt_Upd_On]            DATETIME       NULL,
    CONSTRAINT [PK__T_Answer_Paper__48668981] PRIMARY KEY CLUSTERED ([I_Answer_Paper_ID] ASC)
);

