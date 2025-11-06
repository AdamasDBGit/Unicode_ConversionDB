CREATE TABLE [dbo].[T_ERP_Country_Master] (
    [I_Country_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [S_Country_Code]  NVARCHAR (MAX) NULL,
    [S_Country_Name]  NVARCHAR (MAX) NULL,
    [R_I_Currency_ID] INT            NULL,
    [Dtt_Created_At]  DATETIME       CONSTRAINT [DF__T_ERP_Cou__Dtt_C__29F80E1B] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Cou__Is_Ac__2AEC3254] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Co__1870C757533D41B6] PRIMARY KEY CLUSTERED ([I_Country_ID] ASC)
);

