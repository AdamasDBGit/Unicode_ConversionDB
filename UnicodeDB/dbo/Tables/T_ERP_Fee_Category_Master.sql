CREATE TABLE [dbo].[T_ERP_Fee_Category_Master] (
    [I_ERP_Fee_Category_Master_ID]         INT            IDENTITY (1, 1) NOT NULL,
    [S_Fee_Category_Name]                  NVARCHAR (MAX) NULL,
    [I_Fee_Category_FeeStructure_Capacity] INT            NULL,
    [I_Status_ID]                          INT            NULL,
    [Dt_Created_By]                        DATETIME       NULL,
    [S_Created_By]                         NVARCHAR (MAX) NULL,
    [Dt_Updated_By]                        DATETIME       NULL,
    [S_Updated_By]                         NVARCHAR (MAX) NULL,
    [I_Brand_ID]                           INT            NULL
);

