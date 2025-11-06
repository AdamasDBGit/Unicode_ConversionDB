CREATE TYPE [dbo].[UT_Discount_Scheme_Comp] AS TABLE (
    [DiscountschemeID]            INT           NULL,
    [I_Discount_Scheme_Detail_ID] INT           NULL,
    [I_Component_ID]              VARCHAR (200) NULL,
    [I_Applicable_From]           INT           NULL,
    [I_Applicable_To]             INT           NULL,
    [N_Discount_Rate]             VARCHAR (100) NULL);

