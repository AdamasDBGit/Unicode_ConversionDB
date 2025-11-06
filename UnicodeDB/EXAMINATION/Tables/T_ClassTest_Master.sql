CREATE TABLE [EXAMINATION].[T_ClassTest_Master] (
    [I_ClassTest_ID]     INT             IDENTITY (1, 1) NOT NULL,
    [S_ClassTest_Name]   VARCHAR (MAX)   NULL,
    [S_ClassTest_Desc]   VARCHAR (MAX)   NULL,
    [Dt_Submission_Date] DATETIME        NULL,
    [I_Batch_ID]         INT             NULL,
    [I_Center_ID]        INT             NULL,
    [I_Status]           INT             NULL,
    [S_Crtd_By]          VARCHAR (MAX)   NULL,
    [Dt_Crtd_On]         DATETIME        NULL,
    [S_Updt_On]          VARCHAR (MAX)   NULL,
    [Dt_Updt_On]         DATETIME        NULL,
    [I_TimeTable_ID]     INT             NULL,
    [N_Total_Marks]      DECIMAL (14, 1) NULL
);

