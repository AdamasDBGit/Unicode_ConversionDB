CREATE TABLE [dbo].[T_ERP_HomeWork_Type] (
    [I_HomeworkType_ID] TINYINT        IDENTITY (1, 1) NOT NULL,
    [S_Type]            NVARCHAR (MAX) NULL,
    [is_Active]         BIT            NULL,
    CONSTRAINT [PK__T_ERP_Ho__0D6570E1ED3CEEA5] PRIMARY KEY CLUSTERED ([I_HomeworkType_ID] ASC)
);

