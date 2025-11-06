CREATE TABLE [dbo].[T_buzzedDB_academic_years] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [client_id]    INT           NULL,
    [name]         NVARCHAR (58) NULL,
    [start_date]   DATE          NULL,
    [end_date]     DATE          NULL,
    [is_current]   INT           NULL,
    [erp_ay_id]    INT           NULL,
    [erp_brand_id] INT           NULL
);

