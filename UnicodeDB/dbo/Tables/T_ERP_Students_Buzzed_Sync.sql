CREATE TABLE [dbo].[T_ERP_Students_Buzzed_Sync] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_detail_ID] INT            NULL,
    [student_erp_id]      NVARCHAR (MAX) NULL,
    [buzzed_student_id]   INT            NULL,
    [Erp_parent_id]       INT            NULL,
    [Relation_ID]         INT            NULL,
    [buzzed_parent_id]    INT            NULL,
    [dt_Created_dt]       DATETIME       CONSTRAINT [DF__T_ERP_Stu__dt_Cr__4A05B651] DEFAULT (getdate()) NULL,
    [dt_Modified_dt]      DATETIME       NULL,
    [is_Synced]           BIT            NULL,
    [I_Status_ID]         BIT            NULL
);

