CREATE TABLE [dbo].[T_ERP_Saas_Pattern_Header_bak] (
    [I_Pattern_HeaderID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]         INT            NULL,
    [I_Session_ID]       INT            NULL,
    [S_Property_Type]    NVARCHAR (MAX) NULL,
    [S_Property_Name]    NVARCHAR (MAX) NULL,
    [Dt_Create_Dt]       DATETIME       NULL,
    [I_Created_By]       INT            NULL,
    [Dt_Update_Dt]       DATETIME       NULL,
    [I_Updated_By]       INT            NULL,
    [Is_Active]          BIT            NULL,
    [N_help]             NVARCHAR (MAX) NULL,
    [N_iExpession]       NVARCHAR (MAX) NULL,
    [S_Screen]           NVARCHAR (MAX) NULL
);

