CREATE TABLE [dbo].[T_ERP_State_Master] (
    [I_State_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_State_Code] NVARCHAR (MAX) NULL,
    [S_State_Name] NVARCHAR (MAX) NULL,
    [I_Country_ID] INT            NULL,
    [I_Status]     INT            NULL,
    [S_Crtd_By]    INT            NULL,
    [S_Upd_By]     INT            NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [Dt_Upd_On]    DATETIME       NULL,
    CONSTRAINT [PK_ERP_T_State_Master__047B7388] PRIMARY KEY CLUSTERED ([I_State_ID] ASC)
);

