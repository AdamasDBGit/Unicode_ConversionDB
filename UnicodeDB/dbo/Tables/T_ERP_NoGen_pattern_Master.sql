CREATE TABLE [dbo].[T_ERP_NoGen_pattern_Master] (
    [I_Pttrn_Master_ID] INT            NULL,
    [S_Pattern1]        NVARCHAR (MAX) NULL,
    [S_Pattern2]        NVARCHAR (MAX) NULL,
    [I_Brand_ID]        INT            NULL,
    [Is_Active]         BIT            CONSTRAINT [DF__T_ERP_NoG__Is_Ac__74260D4F] DEFAULT ((1)) NULL
);

