CREATE TABLE [dbo].[T_ERP_Prev_Class] (
    [I_Prev_Class_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Class_Name]    NVARCHAR (MAX) NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Pre__Is_Ac__7954D6C0] DEFAULT ((1)) NULL,
    [Dtt_Created_At]  DATETIME       NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    CONSTRAINT [PK__T_ERP_Pr__5BFA598DA9F9EADF] PRIMARY KEY CLUSTERED ([I_Prev_Class_ID] ASC)
);

