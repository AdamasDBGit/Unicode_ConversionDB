CREATE TABLE [EXAMINATION].[T_Question_Choices] (
    [I_Question_Choice_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Question_ID]        INT             NULL,
    [B_Is_Answer]          BIT             NULL,
    [S_Answer_Desc]        NVARCHAR (2500) NULL,
    [N_Answer_Marks]       NUMERIC (8, 2)  NULL,
    CONSTRAINT [PK__T_Question_Choic__623B6A1D] PRIMARY KEY CLUSTERED ([I_Question_Choice_ID] ASC)
);

