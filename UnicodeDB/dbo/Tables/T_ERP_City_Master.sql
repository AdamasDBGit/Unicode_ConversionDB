CREATE TABLE [dbo].[T_ERP_City_Master] (
    [I_City_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [S_City_Code]     NVARCHAR (MAX) NULL,
    [S_City_Name]     NVARCHAR (MAX) NULL,
    [R_I_Country_ID]  INT            NULL,
    [R_I_State_ID]    INT            NULL,
    [Dtt_Created_At]  DATETIME       CONSTRAINT [DF__T_ERP_Cit__Dtt_C__2DC89EFF] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Cit__Is_Ac__2EBCC338] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Ci__52733E0D842EB49F] PRIMARY KEY CLUSTERED ([I_City_ID] ASC)
);

