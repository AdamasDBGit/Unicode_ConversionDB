CREATE TABLE [SMManagement].[T_Dispatch_Scheme_Details] (
    [DispatchSchemeDetailsID] INT          IDENTITY (1, 1) NOT NULL,
    [DispatchSchemeID]        INT          NULL,
    [ItemType]                INT          NULL,
    [BarcodePrefix]           VARCHAR (20) NULL,
    [StatusID]                INT          NULL,
    [CreatedBy]               VARCHAR (50) NULL,
    [CreatedOn]               DATETIME     NULL,
    [UpdatedBy]               VARCHAR (50) NULL,
    [UpdatedOn]               DATETIME     NULL,
    [I_Delivery]              INT          NULL
);

