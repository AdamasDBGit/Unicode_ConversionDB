CREATE TABLE [dbo].[T_ERP_Enquiry_Regn_Address] (
    [I_Enquiry_Regn_Address_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]         INT            NOT NULL,
    [S_Address_Type]            NVARCHAR (10)  NOT NULL,
    [S_Country_ID]              INT            NOT NULL,
    [S_State_ID]                INT            NOT NULL,
    [S_City_ID]                 INT            NOT NULL,
    [S_Address1]                NVARCHAR (MAX) NOT NULL,
    [S_Address2]                NVARCHAR (MAX) NULL,
    [S_Pincode]                 NVARCHAR (10)  NOT NULL,
    [S_Area]                    NVARCHAR (100) NULL,
    [I_Status]                  INT            NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P-Permanent; C-Current', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_Enquiry_Regn_Address', @level2type = N'COLUMN', @level2name = N'S_Address_Type';

