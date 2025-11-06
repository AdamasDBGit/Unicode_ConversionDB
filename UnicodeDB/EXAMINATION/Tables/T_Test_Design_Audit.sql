CREATE TABLE [EXAMINATION].[T_Test_Design_Audit] (
    [I_Test_Design_Audit_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Test_Design_ID]       INT            NOT NULL,
    [I_Exam_Component_ID]    INT            NULL,
    [I_Eval_Strategy_ID]     INT            NULL,
    [I_Bank_Pool_Mapping_ID] INT            NULL,
    [I_No_Of_Questions]      INT            NOT NULL,
    [I_Complexity_ID]        INT            NULL,
    [N_Marks]                NUMERIC (8, 2) NULL,
    [I_Status_ID]            INT            NULL,
    [S_Crtd_By]              VARCHAR (20)   NULL,
    [S_Upd_by]               VARCHAR (20)   NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK__T_Test_Design_Au__660BFB01] PRIMARY KEY CLUSTERED ([I_Test_Design_Audit_ID] ASC)
);

