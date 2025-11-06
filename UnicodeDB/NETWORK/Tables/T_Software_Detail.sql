CREATE TABLE [NETWORK].[T_Software_Detail] (
    [I_Software_Detail_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Software_ID]        INT           NULL,
    [I_Centre_Id]          INT           NULL,
    [S_Act_Version]        VARCHAR (200) NULL,
    [S_Act_License_No]     VARCHAR (50)  NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    [I_Status]             INT           NULL,
    CONSTRAINT [PK__T_Software_Detai__6B7099F3] PRIMARY KEY CLUSTERED ([I_Software_Detail_ID] ASC)
);

