CREATE TABLE [dbo].[T_ERP_Stud_HomeWork_Doc_Upload] (
    [I_Home_Work_Doc_Upload_ID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [R_I_Student_HomeWork_ID]   INT            NULL,
    [S_Filepath]                NVARCHAR (MAX) NULL,
    [S_SeqNo]                   INT            NULL,
    [Is_Active]                 BIT            CONSTRAINT [DF__T_ERP_Stu__Is_Ac__7DAF7789] DEFAULT ((1)) NULL,
    [Dtt_Created_At]            DATETIME       CONSTRAINT [DF__T_ERP_Stu__Dtt_C__7EA39BC2] DEFAULT ((1)) NULL,
    [Dtt_Modified_At]           DATETIME       NULL,
    CONSTRAINT [PK__T_ERP_St__9AFECFF3E184C96E] PRIMARY KEY CLUSTERED ([I_Home_Work_Doc_Upload_ID] ASC)
);

