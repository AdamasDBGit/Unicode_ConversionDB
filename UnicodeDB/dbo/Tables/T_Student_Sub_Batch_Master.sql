CREATE TABLE [dbo].[T_Student_Sub_Batch_Master] (
    [I_Sub_Batch_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]       INT            NOT NULL,
    [S_Sub_Batch_Code] NVARCHAR (MAX) NULL,
    [S_Sub_Batch_Name] NVARCHAR (MAX) NULL,
    [I_Status]         INT            NULL,
    [S_Crtd_By]        NVARCHAR (MAX) NULL,
    [S_Updt_By]        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]       DATETIME       NULL,
    [Dt_Upd_On]        DATETIME       NULL,
    CONSTRAINT [PK_T_Student_Sub_Batch_Master] PRIMARY KEY CLUSTERED ([I_Sub_Batch_ID] ASC)
);

