CREATE TABLE [dbo].[T_ERP_User_Group_Master_bak_19] (
    [I_User_Group_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_User_GroupName]       NVARCHAR (MAX) NULL,
    [S_Code]                 NVARCHAR (MAX) NULL,
    [I_Brand_ID]             INT            NULL,
    [Is_Active]              BIT            NULL,
    [Dt_Crtd_Dt]             DATE           NULL,
    [I_Created_By]           INT            NULL
);

