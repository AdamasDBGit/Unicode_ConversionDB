CREATE TABLE [dbo].[T_ERP_GST_Item_Category] (
    [I_GST_FeeComponent_Catagory_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_GST_FeeComponent_Category_Type] NVARCHAR (MAX) NULL,
    [I_Fee_Component_ID]               INT            NULL,
    [S_GST_FeeComponent_Description]   NVARCHAR (MAX) NOT NULL,
    [Is_Active]                        BIT            CONSTRAINT [DF__T_ERP_GST__Is_Ac__6133346C] DEFAULT ((1)) NOT NULL,
    [I_Created_By]                     INT            NULL,
    [Dt_Created_At]                    DATETIME       CONSTRAINT [DF__T_ERP_GST__Dt_Cr__622758A5] DEFAULT (getdate()) NULL,
    [I_Updated_By]                     INT            NULL,
    [Dt_Updated_At]                    DATETIME       NULL,
    [I_Brand_Id]                       INT            NULL,
    [Type]                             INT            NULL,
    CONSTRAINT [PK__T_ERP_GS__15DE29CA1403D6BA] PRIMARY KEY CLUSTERED ([I_GST_FeeComponent_Catagory_ID] ASC)
);

