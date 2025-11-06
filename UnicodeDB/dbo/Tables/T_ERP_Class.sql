CREATE TABLE [dbo].[T_ERP_Class] (
    [I_Class_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [S_Class_Code]    NVARCHAR (MAX) NULL,
    [S_Class_Name]    NVARCHAR (MAX) NULL,
    [Dtt_Created_At]  DATETIME       CONSTRAINT [DF__T_ERP_Cla__Dtt_C__26277D37] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Cla__Is_Ac__271BA170] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Cl__16D21E6A50EFFBC9] PRIMARY KEY CLUSTERED ([I_Class_ID] ASC)
);

