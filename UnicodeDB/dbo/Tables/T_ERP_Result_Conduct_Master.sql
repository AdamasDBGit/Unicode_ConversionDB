CREATE TABLE [dbo].[T_ERP_Result_Conduct_Master] (
    [I_Result_Conduct_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Conduct_Name]      NVARCHAR (MAX) NULL,
    [Is_Active]           BIT            CONSTRAINT [DF__T_ERP_Res__Is_Ac__778C89DF] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Re__CC22D65BA0A45879] PRIMARY KEY CLUSTERED ([I_Result_Conduct_ID] ASC)
);

