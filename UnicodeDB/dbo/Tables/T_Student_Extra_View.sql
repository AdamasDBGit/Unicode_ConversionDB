CREATE TABLE [dbo].[T_Student_Extra_View] (
    [I_Student_Detail_ID] INT NOT NULL,
    [I_Batch_ID]          INT NOT NULL,
    [I_Extra_View_Count]  INT NULL,
    CONSTRAINT [PK_T_Student_Extra_View] PRIMARY KEY CLUSTERED ([I_Student_Detail_ID] ASC, [I_Batch_ID] ASC)
);

