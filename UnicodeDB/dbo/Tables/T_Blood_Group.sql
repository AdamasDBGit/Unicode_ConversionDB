CREATE TABLE [dbo].[T_Blood_Group] (
    [I_Blood_Group_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Blood_Group]    NVARCHAR (MAX) NULL,
    [I_Status]         INT            NULL,
    [S_Crtd_By]        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]       DATETIME       NULL,
    [S_Updt_By]        NVARCHAR (MAX) NULL,
    [Dt_Updt_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_Blood_Group] PRIMARY KEY CLUSTERED ([I_Blood_Group_ID] ASC)
);

