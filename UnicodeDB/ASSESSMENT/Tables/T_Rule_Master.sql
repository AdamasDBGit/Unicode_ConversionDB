CREATE TABLE [ASSESSMENT].[T_Rule_Master] (
    [I_Rule_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]  INT           NOT NULL,
    [S_Rule_Name] VARCHAR (150) NULL,
    [I_Status]    INT           NULL,
    [S_Crtd_By]   VARCHAR (20)  NULL,
    [Dt_Crtd_On]  DATETIME      NULL,
    [S_Updt_By]   VARCHAR (20)  NULL,
    [Dt_Updt_On]  DATETIME      NULL,
    CONSTRAINT [PK_T_Rule_Master] PRIMARY KEY CLUSTERED ([I_Rule_ID] ASC)
);

