CREATE TABLE [dbo].[T_Tax_Country_Fee_Component] (
    [I_Country_FeeComponent_Tax_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Tax_ID]                      INT             NULL,
    [I_Country_ID]                  INT             NULL,
    [I_Fee_Component_ID]            INT             NULL,
    [N_Tax_Rate]                    NUMERIC (10, 6) NULL,
    [Dt_Valid_From]                 DATETIME        NULL,
    [Dt_Valid_To]                   DATETIME        NULL,
    [I_Status]                      INT             NULL,
    [S_Crtd_By]                     NVARCHAR (MAX)  NULL,
    [S_Upd_By]                      NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                    DATETIME        NULL,
    [Dt_Upd_On]                     DATETIME        NULL,
    CONSTRAINT [PK_T_Tax_Country_Fee_Component] PRIMARY KEY CLUSTERED ([I_Country_FeeComponent_Tax_ID] ASC)
);

