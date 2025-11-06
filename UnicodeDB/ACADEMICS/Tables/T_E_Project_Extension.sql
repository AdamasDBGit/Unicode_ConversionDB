CREATE TABLE [ACADEMICS].[T_E_Project_Extension] (
    [I_E_Project_Extension_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_E_Project_Group_ID]     INT           NULL,
    [Dt_New_End_Date]          DATETIME      NULL,
    [S_Reason]                 VARCHAR (500) NULL,
    [I_Status]                 INT           NULL,
    [S_Crtd_By]                VARCHAR (20)  NULL,
    [S_Upd_By]                 VARCHAR (20)  NULL,
    [Dt_Crtd_On]               DATETIME      NULL,
    [Dt_Upd_On]                DATETIME      NULL,
    CONSTRAINT [PK__T_E_Project_Exte__7CDA51C0] PRIMARY KEY CLUSTERED ([I_E_Project_Extension_ID] ASC)
);

