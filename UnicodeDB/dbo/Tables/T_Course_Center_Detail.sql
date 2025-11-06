CREATE TABLE [dbo].[T_Course_Center_Detail] (
    [I_Course_Center_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Centre_Id]        INT            NULL,
    [I_Course_ID]        INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [Dt_Valid_From]      DATETIME       NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Valid_To]        DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    [I_Status]           INT            NULL,
    CONSTRAINT [PK__T_Course_Center___558B7A75] PRIMARY KEY CLUSTERED ([I_Course_Center_ID] ASC)
);

