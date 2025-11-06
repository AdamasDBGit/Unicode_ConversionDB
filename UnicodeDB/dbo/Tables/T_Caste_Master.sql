CREATE TABLE [dbo].[T_Caste_Master] (
    [I_Caste_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Caste_Name] NVARCHAR (MAX) NULL,
    [I_Status]     INT            NULL,
    [S_Crtd_By]    NVARCHAR (MAX) NULL,
    [S_Upd_By]     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [Dt_Upd_On]    DATETIME       NULL,
    CONSTRAINT [PK_T_Caste_Master] PRIMARY KEY CLUSTERED ([I_Caste_ID] ASC)
);

