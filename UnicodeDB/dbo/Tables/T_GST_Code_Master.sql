CREATE TABLE [dbo].[T_GST_Code_Master] (
    [I_GST_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [I_State_ID]   INT            NULL,
    [S_GST_Code]   NVARCHAR (50)  NULL,
    [S_SAC_Code]   NVARCHAR (50)  NULL,
    [I_Status]     INT            NULL,
    [S_Crtd_By]    NVARCHAR (20)  NULL,
    [S_Upd_By]     NVARCHAR (20)  NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [Dt_Upd_On]    DATETIME       NULL,
    [I_Brand_ID]   INT            NULL,
    [S_State_Code] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_T_GST_Code_Master] PRIMARY KEY CLUSTERED ([I_GST_ID] ASC)
);

