CREATE TABLE [dbo].[T_Room_Master] (
    [I_Room_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]      INT             NULL,
    [S_Building_Name] NVARCHAR (MAX)  NULL,
    [S_Block_Name]    NVARCHAR (MAX)  NULL,
    [S_Floor_Name]    NVARCHAR (MAX)  NULL,
    [S_Room_No]       NVARCHAR (MAX)  NULL,
    [I_Room_Type]     INT             NULL,
    [N_Room_Rate]     NUMERIC (18, 2) NULL,
    [I_No_Of_Beds]    INT             NULL,
    [I_Status]        INT             NULL,
    [S_Crtd_by]       NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]      DATETIME        NULL,
    [S_Updt_By]       NVARCHAR (MAX)  NULL,
    [Dt_Updt_On]      DATETIME        NULL,
    [I_Centre_Id]     INT             NULL,
    [I_Room_Capacity] INT             NULL,
    CONSTRAINT [PK_T_Room_Master] PRIMARY KEY CLUSTERED ([I_Room_ID] ASC)
);

