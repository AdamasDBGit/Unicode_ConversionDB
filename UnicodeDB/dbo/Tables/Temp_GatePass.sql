CREATE TABLE [dbo].[Temp_GatePass] (
    [active_gatepass_id]   INT            NULL,
    [gatepass_issue_date]  DATETIME       NULL,
    [gatepass_expiry_date] DATETIME       NULL,
    [gatepass_reason]      NVARCHAR (MAX) NULL,
    [parent_master_id]     INT            NULL,
    [gatepass_issuer_name] NVARCHAR (200) NULL
);

