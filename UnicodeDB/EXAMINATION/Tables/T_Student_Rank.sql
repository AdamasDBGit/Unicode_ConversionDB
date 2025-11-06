CREATE TABLE [EXAMINATION].[T_Student_Rank] (
    [I_Examination_Rank]  INT             IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID] INT             NOT NULL,
    [I_Batch_ID]          INT             NOT NULL,
    [I_Term_ID]           INT             NOT NULL,
    [I_Course_ID]         INT             NOT NULL,
    [I_Module_ID]         INT             NOT NULL,
    [I_Session_ID]        INT             NOT NULL,
    [D_Total_Marks]       DECIMAL (18, 2) NULL,
    [I_Rank]              INT             NULL,
    CONSTRAINT [PK_T_Student_Rank] PRIMARY KEY CLUSTERED ([I_Examination_Rank] ASC)
);

