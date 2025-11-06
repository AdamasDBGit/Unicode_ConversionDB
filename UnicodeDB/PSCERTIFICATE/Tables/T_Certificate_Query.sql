CREATE TABLE [PSCERTIFICATE].[T_Certificate_Query] (
    [I_Certificate_Query_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [S_Replied_By]           VARCHAR (20)   NULL,
    [S_Query]                VARCHAR (4000) NULL,
    [B_PS_Flag]              INT            NULL,
    [S_Reply]                VARCHAR (4000) NULL,
    [I_Status]               INT            NULL,
    [S_Crtd_By]              VARCHAR (20)   NULL,
    [S_Upd_By]               VARCHAR (20)   NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL
);

