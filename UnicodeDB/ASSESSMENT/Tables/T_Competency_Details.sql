CREATE TABLE [ASSESSMENT].[T_Competency_Details] (
    [I_Competency_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]        INT           NOT NULL,
    [I_Pool_ID]         INT           NOT NULL,
    [S_Competency_Code] VARCHAR (150) NULL,
    [S_Competency_Name] VARCHAR (250) NULL,
    [I_Status]          INT           NULL,
    [S_Crtd_By]         VARCHAR (50)  NULL,
    [S_Upd_By]          VARCHAR (50)  NULL,
    [Dt_Crtd_On]        DATETIME      NULL,
    [Dt_Upd_On]         DATETIME      NULL,
    CONSTRAINT [PK_T_Competency Details] PRIMARY KEY CLUSTERED ([I_Competency_ID] ASC)
);

