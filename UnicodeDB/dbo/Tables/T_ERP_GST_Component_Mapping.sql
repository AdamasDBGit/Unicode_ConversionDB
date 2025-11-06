CREATE TABLE [dbo].[T_ERP_GST_Component_Mapping] (
    [GST_Component_Mapping_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [I_GST_FeeComponent_Catagory_ID] INT      NOT NULL,
    [I_Fee_Component_ID]             INT      NOT NULL,
    [Is_Active]                      BIT      NULL,
    [dt_create]                      DATETIME NULL,
    [dt_modify]                      DATETIME NULL,
    [I_GST_Component_Type]           INT      NOT NULL,
    PRIMARY KEY CLUSTERED ([I_GST_FeeComponent_Catagory_ID] ASC, [I_Fee_Component_ID] ASC, [I_GST_Component_Type] ASC)
);

