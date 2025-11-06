CREATE TABLE [dbo].[zzz_mig_T_ERP_User_Group_Master] (
    [I_User_Group_Master_ID] INT            NOT NULL,
    [S_User_GroupName]       NVARCHAR (MAX) NULL,
    [S_Code]                 NVARCHAR (MAX) NULL,
    [I_Brand_ID]             INT            NULL,
    [Is_Active]              BIT            NULL,
    [Dt_Crtd_Dt]             DATE           NULL,
    [I_Created_By]           INT            NULL
);

