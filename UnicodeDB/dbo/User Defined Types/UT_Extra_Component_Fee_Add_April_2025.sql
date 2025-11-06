CREATE TYPE [dbo].[UT_Extra_Component_Fee_Add_April_2025] AS TABLE (
    [R_I_Fee_Structure_ID]                 INT             NOT NULL,
    [R_I_Fee_Component_ID]                 INT             NOT NULL,
    [Comp_Seq]                             INT             NULL,
    [N_Component_Actual_Amount]            NUMERIC (18, 2) NOT NULL,
    [I_Fee_Pay_Installment_ID]             INT             NULL,
    [h_I_Stud_Fee_Struct_CompMap_ID]       INT             NULL,
    [I_Stud_Fee_Struct_CompMap_Details_ID] INT             NULL,
    [Expected_Installment_Date]            DATE            NULL,
    [Is_Active]                            BIT             NULL,
    [Is_OneTime]                           BIT             NULL,
    [I_ExtracomponentRef_ID]               INT             NULL,
    [I_ExtracomponentRef__Type]            INT             NULL);

