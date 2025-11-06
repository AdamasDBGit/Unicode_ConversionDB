CREATE TABLE [dbo].[T_Registration_Batch] (
    [I_Registration_Batch_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Enquiry_Regn_ID]       INT NULL,
    [I_Batch_ID]              INT NULL,
    [B_IsEnrolled]            BIT NULL,
    CONSTRAINT [PK_T_Registration_Batch] PRIMARY KEY CLUSTERED ([I_Registration_Batch_ID] ASC)
);

