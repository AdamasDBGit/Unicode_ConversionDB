CREATE TABLE [dbo].[T_ERP_Exam_Type] (
    [I_Exam_Type_ID]                TINYINT        IDENTITY (1, 1) NOT NULL,
    [I_School_Group_ID]             INT            NULL,
    [I_Brand_ID]                    INT            NULL,
    [I_Exam_Grade_Master_Header_ID] INT            NULL,
    [S_Exam_Type]                   NVARCHAR (MAX) NULL,
    [Is_Active]                     BIT            NULL,
    CONSTRAINT [PK__T_ERP_Ex__1D1D58202B74EF79] PRIMARY KEY CLUSTERED ([I_Exam_Type_ID] ASC)
);

