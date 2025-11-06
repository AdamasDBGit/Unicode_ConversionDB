CREATE TABLE [EXAMINATION].[T_Test_Design] (
    [I_Test_Design_ID]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Exam_Component_ID] INT           NULL,
    [I_Eval_Strategy_ID]  INT           NULL,
    [S_Question_Bank_ID]  VARCHAR (500) NULL,
    [I_Status_ID]         INT           NULL,
    [S_Crtd_By]           VARCHAR (20)  NULL,
    [S_Upd_By]            VARCHAR (20)  NULL,
    [Dt_Crtd_On]          DATETIME      NULL,
    [Dt_Upd_On]           DATETIME      NULL,
    CONSTRAINT [PK__T_Test_Design__0C519F7A] PRIMARY KEY CLUSTERED ([I_Test_Design_ID] ASC)
);

