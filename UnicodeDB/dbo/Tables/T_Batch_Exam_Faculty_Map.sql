CREATE TABLE [dbo].[T_Batch_Exam_Faculty_Map] (
    [I_Batch_Exam_ID] INT NOT NULL,
    [I_Employee_ID]   INT NOT NULL,
    CONSTRAINT [PK_T_Batch_Exam_Faculty_Map] PRIMARY KEY CLUSTERED ([I_Batch_Exam_ID] ASC, [I_Employee_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_I_Batch_Exam_ID]
    ON [dbo].[T_Batch_Exam_Faculty_Map]([I_Batch_Exam_ID] ASC);

