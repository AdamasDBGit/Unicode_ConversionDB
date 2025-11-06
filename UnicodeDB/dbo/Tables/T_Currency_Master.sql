CREATE TABLE [dbo].[T_Currency_Master] (
    [I_Currency_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_Currency_Code]   NVARCHAR (MAX) NULL,
    [S_Currency_Name]   NVARCHAR (MAX) NULL,
    [I_Status]          INT            NULL,
    [Is_Default]        BIT            NULL,
    [S_Crtd_By]         NVARCHAR (MAX) NULL,
    [S_Upd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    [S_Currency]        NVARCHAR (MAX) NULL,
    [S_Currency_Symbol] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Currency_Maste__08B618C0] PRIMARY KEY CLUSTERED ([I_Currency_ID] ASC)
);

