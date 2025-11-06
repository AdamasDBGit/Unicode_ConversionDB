CREATE TABLE [dbo].[T_ERP_Saas_Pattern_Child_Header_bak] (
    [I_Saas_Pattern_Child_Header_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Pattern_HeaderID]             INT            NULL,
    [I_Increment_ID]                 BIGINT         NULL,
    [Pattern1]                       NVARCHAR (MAX) NULL,
    [Is_Active]                      BIT            NULL,
    [N_Value]                        NVARCHAR (MAX) NULL,
    [Pattern2]                       INT            NULL,
    [Pattern3]                       NVARCHAR (MAX) NULL
);

