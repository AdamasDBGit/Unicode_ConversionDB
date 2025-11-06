CREATE TABLE [dbo].[T_Marital_Status] (
    [I_Marital_Status_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Marital_Status]    NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [S_Updt_By]           NVARCHAR (MAX) NULL,
    [Dt_Updt_On]          DATETIME       NULL,
    CONSTRAINT [PK_T_Marital_Status] PRIMARY KEY CLUSTERED ([I_Marital_Status_ID] ASC)
);

