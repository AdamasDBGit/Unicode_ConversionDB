CREATE TABLE [dbo].[T_City_Master] (
    [I_City_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [S_City_Code]  NVARCHAR (MAX) NULL,
    [S_City_Name]  NVARCHAR (MAX) NULL,
    [I_Country_ID] INT            NULL,
    [I_Status]     CHAR (1)       NULL,
    [S_Crtd_By]    NVARCHAR (MAX) NULL,
    [S_Upd_By]     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [Dt_Upd_On]    DATETIME       NULL,
    [I_State_ID]   INT            NULL,
    CONSTRAINT [PK__T_City_Master__02932B16] PRIMARY KEY CLUSTERED ([I_City_ID] ASC)
);

