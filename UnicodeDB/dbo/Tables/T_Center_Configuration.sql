CREATE TABLE [dbo].[T_Center_Configuration] (
    [I_Config_ID]    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Id]    INT            NULL,
    [S_Config_Code]  NVARCHAR (MAX) NOT NULL,
    [S_Config_Value] NVARCHAR (MAX) NOT NULL,
    [I_Status]       INT            NOT NULL,
    [Dt_Valid_From]  DATETIME       NOT NULL,
    [Dt_Valid_To]    DATETIME       NULL,
    [S_Crtd_By]      NVARCHAR (MAX) NOT NULL,
    [S_Upd_by]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]     DATETIME       NOT NULL,
    [Dt_Upd_On]      DATETIME       NULL,
    [I_Brand_ID]     INT            NULL,
    CONSTRAINT [PK__T_Center_Configu__3BEBA403] PRIMARY KEY CLUSTERED ([I_Config_ID] ASC)
);

