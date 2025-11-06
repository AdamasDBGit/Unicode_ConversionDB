CREATE TABLE [dbo].[T_Brand_Center_Details] (
    [I_Brand_Center_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Centre_Id]       INT            NULL,
    [I_Brand_ID]        INT            NULL,
    [S_Crtd_By]         NVARCHAR (MAX) NULL,
    [Dt_Valid_From]     DATETIME       NULL,
    [S_Upd_By]          NVARCHAR (MAX) NULL,
    [Dt_Valid_To]       DATETIME       NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    [I_Status]          INT            NULL,
    CONSTRAINT [PK__T_Brand_Center_D__233504D2] PRIMARY KEY CLUSTERED ([I_Brand_Center_ID] ASC)
);

