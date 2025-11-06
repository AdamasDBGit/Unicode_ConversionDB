CREATE TABLE [dbo].[T_Student_Sub_Batch_Student_Mapping] (
    [T_Student_Sub_Batch_Student_Mapping_Id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [I_Sub_Batch_ID]                         INT            NULL,
    [S_Student_ID]                           NVARCHAR (MAX) NULL,
    [I_Batch_ID]                             INT            NOT NULL,
    [I_Status]                               INT            NULL,
    [S_Crtd_By]                              NVARCHAR (MAX) NULL,
    [S_Updt_By]                              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                             DATETIME       NULL,
    [Dt_Upd_On]                              DATETIME       NULL,
    [I_Student_Detail_ID]                    INT            NOT NULL,
    CONSTRAINT [PK_T_Student_Sub_Batch_Student_Mapping] PRIMARY KEY CLUSTERED ([T_Student_Sub_Batch_Student_Mapping_Id] ASC)
);

