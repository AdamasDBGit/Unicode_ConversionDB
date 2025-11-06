CREATE TABLE [NETWORK].[T_Termination_Request] (
    [I_Center_Termination_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]             INT           NULL,
    [I_Document_ID]           INT           NULL,
    [S_Reason]                VARCHAR (200) NULL,
    [I_Status]                INT           NULL,
    [S_Crtd_By]               VARCHAR (20)  NULL,
    [S_Upd_By]                VARCHAR (20)  NULL,
    [Dt_Crtd_On]              DATETIME      NULL,
    [Dt_Upd_On]               DATETIME      NULL,
    CONSTRAINT [PK__T_Termination_Re__5773C2E7] PRIMARY KEY CLUSTERED ([I_Center_Termination_ID] ASC)
);

