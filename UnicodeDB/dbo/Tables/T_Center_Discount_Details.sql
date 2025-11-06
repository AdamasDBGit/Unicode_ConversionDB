CREATE TABLE [dbo].[T_Center_Discount_Details] (
    [I_Center_Discount_Id]  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Id]           INT            NULL,
    [I_Hierarchy_Level_Id]  INT            NULL,
    [I_Hierarchy_Detail_ID] INT            NULL,
    [N_Discount_Percentage] DECIMAL (4, 2) NULL,
    [I_Status]              INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [I_Brand_Id]            INT            NULL,
    [I_Discount_Amount]     INT            NULL,
    CONSTRAINT [PK_T_Center_Discount_Details] PRIMARY KEY CLUSTERED ([I_Center_Discount_Id] ASC)
);

