CREATE TABLE [dbo].[T_ERP_Fee_FineRangeDetails] (
    [I_FineRangeTagID]  INT             IDENTITY (1, 1) NOT NULL,
    [Dt_FineStartRange] DATE            NULL,
    [Dt_FineEndrange]   DATE            NULL,
    [N_FineAmount]      NUMERIC (12, 2) NULL,
    [Dtt_Created_At]    DATETIME        CONSTRAINT [DF__T_ERP_Fee__Dtt_C__10F75627] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]   DATETIME        NULL,
    [I_Created_By]      INT             NULL,
    [I_Modified_By]     INT             NULL,
    [Is_Active]         BIT             CONSTRAINT [DF__T_ERP_Fee__Is_Ac__11EB7A60] DEFAULT ((1)) NULL,
    [S_Fine_Range_Code] NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK__T_ERP_Fe__E4DE19B122FB34D8] PRIMARY KEY CLUSTERED ([I_FineRangeTagID] ASC)
);

