CREATE TABLE [dbo].[T_ERP_DriverEscortMaster] (
    [I_Driver_Escort_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]         INT            NOT NULL,
    [S_Name]             NVARCHAR (MAX) NOT NULL,
    [S_Phone]            NVARCHAR (MAX) NULL,
    [S_Type]             NVARCHAR (MAX) NULL,
    [S_Token]            NVARCHAR (MAX) NULL,
    [S_Emp_No]           NVARCHAR (MAX) NULL,
    [created_at]         DATETIME       DEFAULT (getdate()) NOT NULL,
    [updated_at]         DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([I_Driver_Escort_ID] ASC)
);

