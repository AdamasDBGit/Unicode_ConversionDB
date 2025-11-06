CREATE TABLE [ASSESSMENT].[T_Step_Details] (
    [I_Step_ID]               INT             IDENTITY (1, 1) NOT NULL,
    [S_Step_Name]             VARCHAR (50)    NULL,
    [I_Parameter_ID]          INT             NOT NULL,
    [S_Parameter_Values]      VARCHAR (250)   NULL,
    [I_EvaluationCriteria_ID] INT             NOT NULL,
    [N_Min_Range]             DECIMAL (18, 2) NULL,
    [N_Max_Range]             DECIMAL (18, 2) NULL,
    [N_Min_Percent_Range]     DECIMAL (18, 2) NULL,
    [N_Max_Percent_Range]     DECIMAL (18, 2) NULL,
    [N_CutOff_Score]          DECIMAL (18, 2) NULL,
    [I_Status]                INT             NULL,
    [S_Crtd_By]               VARCHAR (20)    NULL,
    [Dt_Crtd_On]              DATETIME        NULL,
    [S_Updt_By]               VARCHAR (20)    NULL,
    [Dt_Updt_On]              DATETIME        NULL,
    CONSTRAINT [PK_T_Rule_Step_Details] PRIMARY KEY CLUSTERED ([I_Step_ID] ASC)
);

