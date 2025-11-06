CREATE TABLE [dbo].[T_ERP_Fee_Structure_Category] (
    [I_Fee_Structure_Catagory_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Fee_Structure_Catagory_Name] NVARCHAR (MAX) NOT NULL,
    [I_Status]                      INT            NOT NULL,
    [I_CreatedBy]                   INT            NULL,
    [Dt_CreatedAt]                  DATETIME       NULL,
    [I_UpdatedBy]                   INT            NULL,
    [Dt_UpdatedAt]                  DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Fee_Catagory] PRIMARY KEY CLUSTERED ([I_Fee_Structure_Catagory_ID] ASC)
);

