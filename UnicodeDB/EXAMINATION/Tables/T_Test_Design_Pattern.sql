CREATE TABLE [EXAMINATION].[T_Test_Design_Pattern] (
    [I_Test_Design_Pattern_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Test_Design_ID]         INT            NULL,
    [I_Pool_ID]                INT            NULL,
    [I_No_Of_Questions]        INT            NULL,
    [I_Complexity_ID]          INT            NULL,
    [N_Marks]                  NUMERIC (8, 2) NULL,
    [S_Crtd_By]                VARCHAR (20)   NULL,
    [S_Upd_By]                 VARCHAR (20)   NULL,
    [Dt_Crtd_On]               DATETIME       NULL,
    [Dt_Upd_On]                DATETIME       NULL,
    CONSTRAINT [PK__T_Test_Design_Pa__54E16EFF] PRIMARY KEY CLUSTERED ([I_Test_Design_Pattern_ID] ASC)
);

