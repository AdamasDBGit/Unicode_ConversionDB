CREATE TABLE [dbo].[T_Deleted_Student_Parent_Maps_Log] (
    [I_Student_Parent_Maps_ID] INT            NULL,
    [I_Student_Detail_ID]      INT            NULL,
    [I_Parent_Master_ID]       INT            NULL,
    [S_Student_ID]             NVARCHAR (MAX) NULL,
    [I_Brand_ID]               INT            NULL,
    [Dt_DeletedOn]             DATETIME       NULL,
    [ForStudentID]             NVARCHAR (MAX) NULL
);

