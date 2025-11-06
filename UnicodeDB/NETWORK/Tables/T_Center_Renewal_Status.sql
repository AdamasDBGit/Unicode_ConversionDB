CREATE TABLE [NETWORK].[T_Center_Renewal_Status] (
    [I_Center_Renewal_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]         INT           NULL,
    [S_Reason]            VARCHAR (200) NULL,
    [I_Status]            INT           NULL,
    [S_Crtd_By]           VARCHAR (20)  NULL,
    [S_Upd_by]            VARCHAR (20)  NULL,
    [Dt_Crtd_On]          DATETIME      NULL,
    [Dt_Upd_On]           DATETIME      NULL,
    CONSTRAINT [PK__T_Center_Renewal__4FD2A11F] PRIMARY KEY CLUSTERED ([I_Center_Renewal_ID] ASC)
);

