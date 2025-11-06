CREATE TABLE [STUDENTFEATURES].[T_Survey_Question] (
    [I_Survey_Question_ID] INT             IDENTITY (1, 1) NOT NULL,
    [S_Question]           VARCHAR (900)   NOT NULL,
    [I_SQ_Groups_ID]       INT             NULL,
    [I_SQ_SubGroups_ID]    INT             NULL,
    [N_Weightage]          NUMERIC (18, 2) NULL,
    [I_Status]             INT             NULL,
    [S_Crtd_By]            VARCHAR (20)    NULL,
    [S_Upd_By]             VARCHAR (20)    NULL,
    [Dt_Crtd_On]           DATETIME        NULL,
    [Dt_Upd_On]            DATETIME        NULL,
    CONSTRAINT [PK__T_Survey__DBFEC6CF47F9799B] PRIMARY KEY CLUSTERED ([I_Survey_Question_ID] ASC),
    CONSTRAINT [UQ__T_Survey__FA927E284AD5E646] UNIQUE NONCLUSTERED ([S_Question] ASC)
);

