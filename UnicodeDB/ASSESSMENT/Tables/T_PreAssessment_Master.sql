CREATE TABLE [ASSESSMENT].[T_PreAssessment_Master] (
    [I_PreAssessment_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]           INT           NOT NULL,
    [S_PreAssessment_Code] VARCHAR (50)  NULL,
    [S_PreAssessment_Name] VARCHAR (200) NULL,
    [I_Status]             INT           NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    CONSTRAINT [PK_T_PreAssessment_Master] PRIMARY KEY CLUSTERED ([I_PreAssessment_ID] ASC)
);

