CREATE TABLE [dbo].[T_CourseFamily_Master] (
    [I_CourseFamily_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_CourseFamily_Name] NVARCHAR (MAX) NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [I_Brand_ID]          INT            NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    [I_Status]            INT            NULL,
    [I_IsMTech]           INT            NULL,
    CONSTRAINT [PK__T_CourseFamily_M__251D4D44] PRIMARY KEY CLUSTERED ([I_CourseFamily_ID] ASC)
);

