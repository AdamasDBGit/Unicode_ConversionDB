CREATE TABLE [dbo].[T_ERP_Fee_Fine_Header] (
    [I_Fee_Fine_H_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Name]          NVARCHAR (MAX) NULL,
    [FreqType]        TINYINT        NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Fee__Is_Ac__0A6A5429] DEFAULT ((1)) NULL,
    [Dt_Create_DT]    DATETIME       CONSTRAINT [DF__T_ERP_Fee__Dt_Cr__0B5E7862] DEFAULT (getdate()) NULL,
    [I_Brand_ID]      INT            NULL,
    [I_Center_ID]     INT            NULL
);

