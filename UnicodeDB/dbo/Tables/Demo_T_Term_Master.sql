CREATE TABLE [dbo].[Demo_T_Term_Master] (
    [I_Term_ID]             INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]            INT            NULL,
    [S_Term_Code]           NVARCHAR (MAX) NULL,
    [S_Term_Name]           NVARCHAR (MAX) NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [I_Is_Editable]         INT            NULL,
    [I_Status]              INT            NULL,
    [I_Total_Session_Count] INT            NULL,
    [S_Display_Name]        NVARCHAR (MAX) NULL
);

