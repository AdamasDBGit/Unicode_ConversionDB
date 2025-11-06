CREATE TABLE [dbo].[T_CourseList_Master] (
    [I_CourseList_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_CourseList_Name] NVARCHAR (MAX) NULL,
    [I_Status]          INT            NULL,
    [S_Crtd_By]         NVARCHAR (MAX) NULL,
    [S_Upd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    [I_Brand_ID]        INT            NULL,
    CONSTRAINT [PK__T_CourseList_Mas__68294D9D] PRIMARY KEY CLUSTERED ([I_CourseList_ID] ASC)
);

