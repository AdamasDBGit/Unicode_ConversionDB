CREATE TABLE [dbo].[T_ERP_Configuration_Type] (
    [I_Config_Type_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Config_Type]    NVARCHAR (MAX) NULL,
    [I_Status]         INT            NULL,
    [S_Created_By]     NVARCHAR (MAX) NULL,
    [Dt_Created_At]    DATETIME       NULL,
    [S_Updated_By]     NVARCHAR (MAX) NULL,
    [Dt_Updated_At]    DATETIME       NULL
);

