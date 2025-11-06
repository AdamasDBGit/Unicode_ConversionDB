CREATE TABLE [EXAMINATION].[T_Homework_Submission] (
    [I_Homework_Submission_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [I_Homework_ID]              INT             NOT NULL,
    [I_Student_Detail_ID]        INT             NOT NULL,
    [Dt_Submission_Date]         DATETIME        NULL,
    [I_Status]                   INT             NULL,
    [S_Crtd_By]                  VARCHAR (20)    NULL,
    [Dt_Crtd_On]                 DATETIME        NULL,
    [S_Updt_By]                  VARCHAR (20)    NULL,
    [Dt_Updt_On]                 DATETIME        NULL,
    [Dt_Return_Date]             DATETIME        NULL,
    [I_Employee_ID]              INT             NULL,
    [S_Remarks]                  VARCHAR (100)   NULL,
    [Dt_CCO_Submission_Date]     DATETIME        NULL,
    [Dt_Faculty_Submission_Date] DATETIME        NULL,
    [S_Material_BarCode]         NVARCHAR (500)  NULL,
    [N_Marks]                    DECIMAL (14, 2) NULL,
    CONSTRAINT [PK_T_Homework_Submission] PRIMARY KEY CLUSTERED ([I_Homework_Submission_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IndxHwID]
    ON [EXAMINATION].[T_Homework_Submission]([I_Homework_ID] ASC, [I_Student_Detail_ID] ASC);

