CREATE TABLE [NETWORK].[T_Software_Master] (
    [I_Software_ID]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]       INT           NULL,
    [I_Plan_ID]        INT           NULL,
    [S_Software_Name]  VARCHAR (20)  NULL,
    [S_Rec_Version]    VARCHAR (200) NULL,
    [S_Rec_License_No] VARCHAR (50)  NULL,
    [S_Crtd_By]        VARCHAR (20)  NULL,
    [S_Upd_By]         VARCHAR (20)  NULL,
    [Dt_Crtd_On]       DATETIME      NULL,
    [Dt_Upd_On]        DATETIME      NULL,
    [I_Status]         INT           NULL,
    CONSTRAINT [PK__T_Software_Maste__6D58E265] PRIMARY KEY CLUSTERED ([I_Software_ID] ASC)
);

