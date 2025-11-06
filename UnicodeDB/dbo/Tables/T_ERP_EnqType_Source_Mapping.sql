CREATE TABLE [dbo].[T_ERP_EnqType_Source_Mapping] (
    [I_EnqType_Source_Mapping_ID] INT  IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Type_ID]           INT  NULL,
    [I_Info_Source_ID]            INT  NULL,
    [Is_Active]                   BIT  NULL,
    [Dt_Create_Dt]                DATE NULL,
    CONSTRAINT [PK__T_ERP_En__0717C91E55D36849] PRIMARY KEY CLUSTERED ([I_EnqType_Source_Mapping_ID] ASC)
);

