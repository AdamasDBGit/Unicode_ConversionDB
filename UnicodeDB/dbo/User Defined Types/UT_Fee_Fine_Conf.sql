CREATE TYPE [dbo].[UT_Fee_Fine_Conf] AS TABLE (
    [I_Fee_Fine_H_ID] INT             NULL,
    [I_Fee_Fine_D_ID] INT             NULL,
    [I_Frm_Range]     INT             NULL,
    [I_To_Range]      INT             NULL,
    [Is_Active]       BIT             NULL,
    [N_Fine_Amount]   NUMERIC (12, 2) NULL);

