CREATE TABLE [ACADEMICS].[T_Training_Calendar] (
    [I_Training_ID]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_User_ID]            INT            NULL,
    [S_Training_Name]      VARCHAR (200)  NULL,
    [Dt_Training_Date]     DATETIME       NULL,
    [Dt_Training_End_Date] DATETIME       NULL,
    [S_Description]        VARCHAR (2000) NULL,
    [S_Venue]              VARCHAR (1000) NULL,
    [I_Status]             INT            NULL,
    [I_Document_ID]        INT            NULL,
    [S_Crtd_By]            VARCHAR (20)   NULL,
    [S_Upd_By]             VARCHAR (20)   NULL,
    [Dt_Crtd_On]           DATETIME       NULL,
    [Dt_Upd_On]            DATETIME       NULL,
    CONSTRAINT [PK__T_Training_Calen__24A84BF8] PRIMARY KEY CLUSTERED ([I_Training_ID] ASC)
);

