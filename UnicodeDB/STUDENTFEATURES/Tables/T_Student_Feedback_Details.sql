CREATE TABLE [STUDENTFEATURES].[T_Student_Feedback_Details] (
    [I_Student_Feedback_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Feedback_Option_Master_ID]  INT            NULL,
    [I_Student_Feedback_ID]        INT            NULL,
    [I_Feedback_Master_ID]         INT            NULL,
    [S_Remarks]                    NVARCHAR (100) NULL,
    CONSTRAINT [PK_T_Student_Feedback_Details] PRIMARY KEY CLUSTERED ([I_Student_Feedback_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_T_Student_Feedback_Details_I_Student_Feedback_ID]
    ON [STUDENTFEATURES].[T_Student_Feedback_Details]([I_Student_Feedback_ID] ASC)
    INCLUDE([I_Student_Feedback_Detail_ID], [I_Feedback_Option_Master_ID], [I_Feedback_Master_ID]);

