CREATE TABLE [PSCERTIFICATE].[T_Template_Certificate] (
    [I_Template_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [S_Template_Code]      VARCHAR (20)  NULL,
    [S_Template_ShortDesc] VARCHAR (100) NULL,
    [C_Template_Type]      CHAR (1)      NULL,
    [I_Document_ID]        INT           NULL,
    [I_Status]             INT           NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL
);

