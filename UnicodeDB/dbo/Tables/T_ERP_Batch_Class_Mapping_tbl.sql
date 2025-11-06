CREATE TABLE [dbo].[T_ERP_Batch_Class_Mapping_tbl] (
    [Batch_Class_Mapping_tbl_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]                 INT            NULL,
    [S_Batch_Name]               NVARCHAR (MAX) NULL,
    [S_Class_Name]               NVARCHAR (MAX) NULL,
    [I_Class_ID]                 INT            NULL,
    [S_StreamName]               NVARCHAR (MAX) NULL,
    [I_StreamID]                 INT            NULL,
    [S_SectionName]              NVARCHAR (MAX) NULL,
    [I_Section_ID]               INT            NULL,
    [S_GroupName]                NVARCHAR (MAX) NULL,
    [I_School_GroupID]           INT            NULL,
    [Dt_CreateDt]                DATETIME       CONSTRAINT [DF__T_ERP_Bat__Dt_Cr__5774C008] DEFAULT (getdate()) NULL
);

