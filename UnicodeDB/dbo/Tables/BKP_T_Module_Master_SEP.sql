CREATE TABLE [dbo].[BKP_T_Module_Master_SEP] (
    [I_Module_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [I_Skill_ID]      INT            NULL,
    [I_Brand_ID]      INT            NULL,
    [S_Module_Code]   NVARCHAR (MAX) NULL,
    [S_Module_Name]   NVARCHAR (MAX) NULL,
    [I_No_Of_Session] INT            NULL,
    [S_Crtd_By]       NVARCHAR (MAX) NULL,
    [S_Upd_By]        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    [I_Is_Editable]   INT            NULL,
    [I_Status]        INT            NULL,
    [S_Display_Name]  NVARCHAR (MAX) NULL
);

