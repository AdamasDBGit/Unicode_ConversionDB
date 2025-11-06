CREATE TABLE [EXAMINATION].[T_ClassTest_Submission] (
    [I_ClassTest_Submission_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_ClassTest_ID]            INT           NULL,
    [I_Student_Detail_ID]       INT           NULL,
    [Dt_Submission_Date]        DATETIME      NULL,
    [I_Status]                  INT           NULL,
    [S_Crtd_By]                 VARCHAR (MAX) NULL,
    [Dt_Crtd_On]                DATETIME      NULL,
    [S_Updt_By]                 VARCHAR (MAX) NULL,
    [Dt_Upd_On]                 DATETIME      NULL,
    [Dt_Return_Date]            DATETIME      NULL,
    [I_Employee_ID]             INT           NULL,
    [N_Marks]                   VARCHAR (10)  NULL,
    [N_Total_Marks]             VARCHAR (10)  NULL
);

