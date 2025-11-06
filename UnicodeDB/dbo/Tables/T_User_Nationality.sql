CREATE TABLE [dbo].[T_User_Nationality] (
    [I_Nationality_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Nationality]    NVARCHAR (MAX) NULL,
    [I_Status]         INT            NULL,
    [S_Crtd_By]        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]       DATETIME       NULL,
    [S_Updt_By]        NVARCHAR (MAX) NULL,
    [Dt_Updt_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_User_Nationality] PRIMARY KEY CLUSTERED ([I_Nationality_ID] ASC)
);

