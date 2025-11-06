CREATE TABLE [dbo].[T_Student_Leave_Request] (
    [I_Student_Leave_ID]  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Student_Detail_ID] INT            NULL,
    [S_Leave_Type]        NVARCHAR (MAX) NULL,
    [Dt_From_Date]        DATETIME       NULL,
    [Dt_To_Date]          DATETIME       NULL,
    [S_Reason]            NVARCHAR (MAX) NULL,
    [S_Comments]          NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    CONSTRAINT [PK__T_Student_Leave___304F08CE] PRIMARY KEY CLUSTERED ([I_Student_Leave_ID] ASC)
);

