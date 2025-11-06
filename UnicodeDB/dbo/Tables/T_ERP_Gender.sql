CREATE TABLE [dbo].[T_ERP_Gender] (
    [I_Gender_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Gender_Name] NVARCHAR (MAX) NULL,
    [I_Status]      INT            NULL,
    [S_Crtd_By]     INT            NULL,
    [Dt_Crtd_On]    DATETIME       NULL,
    [S_Updt_By]     INT            NULL,
    [Dt_Updt_On]    DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Gender] PRIMARY KEY CLUSTERED ([I_Gender_ID] ASC)
);

