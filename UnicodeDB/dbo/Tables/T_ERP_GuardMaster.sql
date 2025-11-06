CREATE TABLE [dbo].[T_ERP_GuardMaster] (
    [I_Guard_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID] INT            NOT NULL,
    [S_Name]     NVARCHAR (100) NOT NULL,
    [S_Phone]    NVARCHAR (20)  NULL,
    [S_Type]     NVARCHAR (50)  NULL,
    [S_Token]    NVARCHAR (255) NULL,
    [S_Emp_No]   NVARCHAR (50)  NULL,
    [Created_At] DATETIME       DEFAULT (getdate()) NOT NULL,
    [Updated_At] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([I_Guard_ID] ASC)
);

