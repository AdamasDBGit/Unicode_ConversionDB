CREATE TABLE [dbo].[T_ERP_Enquiry_CRM_Details] (
    [Enquiry_CRM_ID]              INT            IDENTITY (1, 1) NOT NULL,
    [I_EnqType_Source_Mapping_ID] INT            NULL,
    [I_Source_DetailsID]          INT            NULL,
    [S_Referal]                   NVARCHAR (MAX) NULL,
    [Is_Active]                   BIT            NULL,
    [dt_create_dt]                DATE           NULL,
    [I_Enquiry_ID]                INT            NULL,
    [I_Brand_ID]                  INT            NULL
);

