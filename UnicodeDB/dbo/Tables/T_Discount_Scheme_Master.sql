CREATE TABLE [dbo].[T_Discount_Scheme_Master] (
    [I_Discount_Scheme_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Discount_Scheme_Name] NVARCHAR (MAX) NULL,
    [Dt_Valid_From]          DATETIME       NULL,
    [Dt_Valid_To]            DATETIME       NULL,
    [I_Status]               INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    [I_Brand_ID]             INT            NULL,
    [S_Discount_Scheme_Code] NVARCHAR (MAX) NULL
);

