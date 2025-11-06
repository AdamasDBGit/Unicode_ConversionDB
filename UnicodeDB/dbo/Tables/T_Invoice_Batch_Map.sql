CREATE TABLE [dbo].[T_Invoice_Batch_Map] (
    [I_Invoice_Child_Header_ID] INT            NOT NULL,
    [I_Batch_ID]                INT            NOT NULL,
    [I_Status]                  INT            NULL,
    [S_Crtd_By]                 NVARCHAR (MAX) NULL,
    [S_Updt_By]                 NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [Dt_Updt_On]                DATETIME       NULL,
    [I_Brand_ID]                INT            NULL,
    CONSTRAINT [PK_T_Invoice_Batch_Map] PRIMARY KEY CLUSTERED ([I_Invoice_Child_Header_ID] ASC, [I_Batch_ID] ASC)
);

