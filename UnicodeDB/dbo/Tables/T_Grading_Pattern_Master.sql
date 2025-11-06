CREATE TABLE [dbo].[T_Grading_Pattern_Master] (
    [I_Grading_Pattern_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Pattern_Name]       NVARCHAR (MAX) NULL,
    [I_Status]             INT            NULL,
    [S_Crtd_By]            NVARCHAR (MAX) NULL,
    [S_Upd_By]             NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]           DATETIME       NULL,
    [Dt_Upd_On]            DATETIME       NULL,
    [I_Brand_ID]           INT            NULL,
    CONSTRAINT [PK__T_Grading_Patter__54425081] PRIMARY KEY CLUSTERED ([I_Grading_Pattern_ID] ASC)
);

