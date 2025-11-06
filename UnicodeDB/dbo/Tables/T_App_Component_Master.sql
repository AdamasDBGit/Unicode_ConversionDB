CREATE TABLE [dbo].[T_App_Component_Master] (
    [I_App_Component_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Component_Code]          NVARCHAR (50)  NULL,
    [S_Component_Name]          NVARCHAR (100) NULL,
    [I_Status]                  INT            NULL,
    [I_Type]                    INT            NULL,
    [I_Sequence]                INT            NULL
);

