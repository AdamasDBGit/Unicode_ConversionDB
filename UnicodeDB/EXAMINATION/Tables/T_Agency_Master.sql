CREATE TABLE [EXAMINATION].[T_Agency_Master] (
    [I_Agency_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [S_Agency_Name]     VARCHAR (200) NULL,
    [S_Agency_Address1] VARCHAR (200) NULL,
    [S_Agency_Address2] VARCHAR (200) NULL,
    [S_Agency_Email]    VARCHAR (200) NULL,
    [S_Crtd_By]         VARCHAR (20)  NULL,
    [S_Upd_By]          VARCHAR (20)  NULL,
    [Dt_Crtd_On]        DATETIME      NULL,
    [Dt_Upd_On]         DATETIME      NULL,
    CONSTRAINT [PK__T_Agency_Master__4F2895A9] PRIMARY KEY CLUSTERED ([I_Agency_ID] ASC)
);

