CREATE TABLE [dbo].[T_Business_Type] (
    [I_Business_Type_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Business_Type]    NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [S_Updt_By]          NVARCHAR (MAX) NULL,
    [Dt_Updt_On]         DATETIME       NULL,
    CONSTRAINT [PK_T_Business_Type] PRIMARY KEY CLUSTERED ([I_Business_Type_ID] ASC)
);

