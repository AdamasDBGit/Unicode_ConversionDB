CREATE TABLE [EOS].[T_KRA_Master] (
    [I_KRA_ID]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_KRA_Index_ID] INT           NULL,
    [S_KRA_Desc]     VARCHAR (200) NULL,
    [I_KRA_Type]     INT           NULL,
    [Dt_Start_Date]  DATETIME      NULL,
    [Dt_End_Date]    DATETIME      NULL,
    [I_Status]       INT           NULL,
    [S_Crtd_By]      VARCHAR (20)  NULL,
    [S_Upd_By]       VARCHAR (20)  NULL,
    [Dt_Crtd_On]     DATETIME      NULL,
    [Dt_Upd_On]      DATETIME      NULL,
    CONSTRAINT [PK__T_KRA_Master__2E878744] PRIMARY KEY CLUSTERED ([I_KRA_ID] ASC)
);

