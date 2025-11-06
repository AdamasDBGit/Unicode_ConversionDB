CREATE TABLE [dbo].[T_ERP_CRMSource_Details] (
    [I_Source_DetailsID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_EnqType_Source_Mapping_ID] INT            NULL,
    [S_Name]                      NVARCHAR (MAX) NULL,
    [Is_Active]                   BIT            NULL
);

