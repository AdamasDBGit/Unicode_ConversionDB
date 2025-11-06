CREATE TABLE [dbo].[T_Invoice_Sequence_Number] (
    [I_Brand_ID]        INT            NULL,
    [I_State_ID]        INT            NULL,
    [I_Sequence_Number] INT            CONSTRAINT [DF__T_Invoice__I_Seq__65F3257F] DEFAULT ((0)) NULL,
    [S_Invoice_type]    NVARCHAR (MAX) NULL
);

