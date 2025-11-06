CREATE TABLE [NETWORK].[T_Hardware_Detail] (
    [I_Hardware_Detail_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Hardware_ID]        INT           NULL,
    [I_Centre_Id]          INT           NULL,
    [S_Act_Spec]           VARCHAR (200) NULL,
    [S_Act_No]             VARCHAR (50)  NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    [I_Status]             INT           NULL,
    CONSTRAINT [PK__T_Hardware_Detai__61E72FB9] PRIMARY KEY CLUSTERED ([I_Hardware_Detail_ID] ASC)
);

