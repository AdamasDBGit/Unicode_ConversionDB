CREATE TABLE [EOS].[T_Employee_WorkExp] (
    [I_Employee_WorkExp_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Employee_ID]         INT           NULL,
    [Dt_From_Date]          DATETIME      NULL,
    [Dt_To_Date]            DATETIME      NULL,
    [S_Company]             VARCHAR (100) NULL,
    [S_Industry]            VARCHAR (100) NULL,
    [S_Job_Type]            VARCHAR (20)  NULL,
    [S_Job_Description]     VARCHAR (200) NULL,
    [I_Status]              INT           NULL,
    [S_Crtd_By]             VARCHAR (20)  NULL,
    [S_Upd_By]              VARCHAR (20)  NULL,
    [Dt_Crtd_On]            DATETIME      NULL,
    [Dt_Upd_On]             DATETIME      NULL,
    CONSTRAINT [PK__T_Employee_WorkE__419A5BB8] PRIMARY KEY CLUSTERED ([I_Employee_WorkExp_ID] ASC)
);

