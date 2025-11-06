CREATE TABLE [dbo].[T_ERP_Qualification_Name_Master] (
    [I_Qualification_Name_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Qualification_Type_ID] INT            NULL,
    [S_Qualification_Name]    NVARCHAR (MAX) NULL,
    [I_Created_By]            INT            NULL,
    [I_Modified_By]           INT            NULL,
    [Dtt_Created_At]          DATETIME       CONSTRAINT [DF__T_ERP_Qua__Dtt_C__04C6896C] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]         DATETIME       NULL,
    [Is_Active]               BIT            CONSTRAINT [DF__T_ERP_Qua__Is_Ac__05BAADA5] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Qu__0417D36042A5E871] PRIMARY KEY CLUSTERED ([I_Qualification_Name_ID] ASC)
);

