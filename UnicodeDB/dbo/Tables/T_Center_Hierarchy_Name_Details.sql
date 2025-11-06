CREATE TABLE [dbo].[T_Center_Hierarchy_Name_Details] (
    [I_Center_ID]           INT            NOT NULL,
    [S_Center_Name]         NVARCHAR (MAX) NULL,
    [I_Brand_ID]            INT            NULL,
    [S_Brand_Name]          NVARCHAR (MAX) NULL,
    [I_Region_ID]           INT            NULL,
    [S_Region_Name]         NVARCHAR (MAX) NULL,
    [I_Territory_ID]        INT            NULL,
    [S_Territiry_Name]      NVARCHAR (MAX) NULL,
    [I_City_ID]             INT            NULL,
    [S_City_Name]           NVARCHAR (MAX) NULL,
    [I_Hierarchy_Detail_ID] INT            NULL,
    CONSTRAINT [PK_T_Center_Hierarchy_Name_Details] PRIMARY KEY CLUSTERED ([I_Center_ID] ASC)
);

