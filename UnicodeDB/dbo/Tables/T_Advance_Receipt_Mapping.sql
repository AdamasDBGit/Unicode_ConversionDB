CREATE TABLE [dbo].[T_Advance_Receipt_Mapping] (
    [I_Advance_Receipt_Map_ID]  INT IDENTITY (1, 1) NOT NULL,
    [I_Receipt_Header_ID]       INT NULL,
    [I_Invoice_Child_Header_ID] INT NULL,
    [I_Invoice_Detail_ID]       INT NULL,
    CONSTRAINT [PK_T_Advance_Receipt_Mapping] PRIMARY KEY CLUSTERED ([I_Advance_Receipt_Map_ID] ASC)
);

