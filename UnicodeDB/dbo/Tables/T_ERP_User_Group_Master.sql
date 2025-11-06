CREATE TABLE [dbo].[T_ERP_User_Group_Master] (
    [I_User_Group_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_User_GroupName]       NVARCHAR (MAX) NULL,
    [S_Code]                 NVARCHAR (MAX) NULL,
    [I_Brand_ID]             INT            NULL,
    [Is_Active]              BIT            NULL,
    [Dt_Crtd_Dt]             DATE           CONSTRAINT [DF__T_ERP_Use__Dt_Cr__689F4C0A] DEFAULT (getdate()) NULL,
    [I_Created_By]           INT            NULL,
    CONSTRAINT [PK__T_ERP_Us__883BDA287FCC7B8A] PRIMARY KEY CLUSTERED ([I_User_Group_Master_ID] ASC)
);

