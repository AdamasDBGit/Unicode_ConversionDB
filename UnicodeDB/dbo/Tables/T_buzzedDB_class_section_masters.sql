CREATE TABLE [dbo].[T_buzzedDB_class_section_masters] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [class_id]            INT            NULL,
    [section_name]        NVARCHAR (100) NULL,
    [erp_class_id]        INT            NULL,
    [erp_school_group_id] INT            NULL,
    [erp_stream_id]       INT            NULL,
    [erp_section_id]      INT            NULL
);

