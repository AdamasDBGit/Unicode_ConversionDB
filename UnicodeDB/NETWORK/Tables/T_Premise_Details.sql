CREATE TABLE [NETWORK].[T_Premise_Details] (
    [I_Premise_Detail_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]         INT           NULL,
    [I_Premise_ID]        INT           NULL,
    [S_Act_Spec]          VARCHAR (200) NULL,
    [S_Act_No]            VARCHAR (50)  NULL,
    [S_Crtd_By]           VARCHAR (20)  NULL,
    [S_Upd_By]            VARCHAR (20)  NULL,
    [Dt_Crtd_On]          DATETIME      NULL,
    [Dt_Upd_On]           DATETIME      NULL,
    [I_Status]            INT           NULL,
    CONSTRAINT [PK__T_Premise_Detail__67A0090F] PRIMARY KEY CLUSTERED ([I_Premise_Detail_ID] ASC)
);

