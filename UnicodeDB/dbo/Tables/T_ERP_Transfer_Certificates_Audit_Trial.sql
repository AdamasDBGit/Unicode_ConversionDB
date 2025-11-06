CREATE TABLE [dbo].[T_ERP_Transfer_Certificates_Audit_Trial] (
    [I_Transfer_Cert_History_Id] INT            IDENTITY (1, 1) NOT NULL,
    [I_Transfer_Cert_Req_ID]     INT            NOT NULL,
    [I_Transfer_Req_Status]      INT            NULL,
    [S_Remarks]                  NVARCHAR (MAX) NULL,
    [Is_Released]                BIT            NULL,
    [I_Created_By]               INT            NULL,
    [Dt_Created_on]              DATETIME       DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_T_ERP_Transfer_Certificates_Audit_Trial] PRIMARY KEY CLUSTERED ([I_Transfer_Cert_History_Id] ASC)
);

