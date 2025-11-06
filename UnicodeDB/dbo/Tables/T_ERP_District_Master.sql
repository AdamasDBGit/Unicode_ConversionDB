CREATE TABLE [dbo].[T_ERP_District_Master] (
    [I_District_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_District_Code] NVARCHAR (MAX) NULL,
    [S_District_Name] NVARCHAR (MAX) NULL,
    [I_Country_ID]    INT            NULL,
    [I_State_ID]      INT            NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       INT            NULL,
    [S_Upd_By]        INT            NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_District_Master] PRIMARY KEY CLUSTERED ([I_District_ID] ASC)
);

