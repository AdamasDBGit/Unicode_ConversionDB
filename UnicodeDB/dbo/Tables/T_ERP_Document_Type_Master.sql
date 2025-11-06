CREATE TABLE [dbo].[T_ERP_Document_Type_Master] (
    [I_Document_Type_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_Document_Type_Name]   NVARCHAR (MAX) NULL,
    [Is_Mandatory]           BIT            CONSTRAINT [DF__T_ERP_Doc__Is_Ma__316425B9] DEFAULT ((0)) NULL,
    [Is_Active]              BIT            CONSTRAINT [DF__T_ERP_Doc__Is_Ac__325849F2] DEFAULT ((1)) NULL,
    [I_CreatedBy]            INT            NULL,
    [I_UpdatedBy]            INT            NULL,
    [Dtt_CreatedAt]          DATETIME       CONSTRAINT [DF__T_ERP_Doc__Dtt_C__334C6E2B] DEFAULT (getdate()) NULL,
    [Dtt_UpdatedAt]          DATETIME       NULL,
    [I_Document_Category_ID] INT            NULL,
    CONSTRAINT [PK__T_ERP_Do__07AFFD4572E4CB04] PRIMARY KEY CLUSTERED ([I_Document_Type_ID] ASC)
);

