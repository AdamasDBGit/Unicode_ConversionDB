CREATE TABLE [dbo].[T_ERP_Methodology_Category] (
    [I_Methodology_Category_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                  INT            NOT NULL,
    [S_Methodology_Category_Name] NVARCHAR (100) NOT NULL,
    [I_CreatedBy]                 INT            NOT NULL,
    [Dt_CreatedAt]                DATETIME       NOT NULL,
    [I_Status]                    INT            NOT NULL
);

