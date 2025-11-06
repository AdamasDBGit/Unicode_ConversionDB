CREATE TABLE [dbo].[T_ERP_Fee_Component] (
    [I_Fee_Component_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [S_Fee_Component_Name]     NVARCHAR (MAX) NOT NULL,
    [I_Is_Refundable]          INT            NULL,
    [I_Is_Special_Fee]         INT            NULL,
    [I_Is_Adhoc]               INT            NULL,
    [S_Financial_Account_Code] NVARCHAR (MAX) NULL,
    [I_CreatedBy]              INT            NULL,
    [Dt_CreatedAt]             DATETIME       NULL,
    [I_UpdatedBy]              INT            NULL,
    [Dt_UpdatedAt]             DATETIME       NULL,
    [I_Brand_ID]               INT            NULL,
    [Is_individual]            BIT            CONSTRAINT [DF_Is_individual] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_ERP_Fee_Component] PRIMARY KEY CLUSTERED ([I_Fee_Component_ID] ASC)
);

