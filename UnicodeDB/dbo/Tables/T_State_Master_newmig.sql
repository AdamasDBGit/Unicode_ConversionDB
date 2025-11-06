CREATE TABLE [dbo].[T_State_Master_newmig] (
    [I_State_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_State_Code] NVARCHAR (MAX) NULL,
    [S_State_Name] NVARCHAR (MAX) NULL,
    [I_Country_ID] INT            NULL,
    [I_Status]     INT            NULL,
    [S_Crtd_By]    NVARCHAR (MAX) NULL,
    [S_Upd_By]     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [Dt_Upd_On]    DATETIME       NULL
);

