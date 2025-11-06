CREATE TABLE [dbo].[T_ERP_Saas_Pattern_Child_Details] (
    [I_Saas_Pattern_Child_Details_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Saas_Pattern_Child_Header_ID]  INT            NOT NULL,
    [I_Increment_ID]                  BIGINT         NULL,
    [ch_Pattern1]                     NVARCHAR (MAX) NULL,
    [Is_Active]                       BIT            NULL,
    CONSTRAINT [PK__T_ERP_Sa__25BD323AB08C0A34] PRIMARY KEY CLUSTERED ([I_Saas_Pattern_Child_Header_ID] ASC)
);

