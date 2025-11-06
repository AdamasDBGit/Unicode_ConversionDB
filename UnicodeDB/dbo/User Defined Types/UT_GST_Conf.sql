CREATE TYPE [dbo].[UT_GST_Conf] AS TABLE (
    [I_GST_Configuration_ID]         INT             NULL,
    [I_GST_FeeComponent_Catagory_ID] INT             NULL,
    [N_Start_Amount]                 NUMERIC (18, 2) NULL,
    [N_End_Amount]                   NUMERIC (18, 2) NULL,
    [N_CGST]                         NUMERIC (18, 2) NULL,
    [N_SGST]                         NUMERIC (18, 2) NULL,
    [N_IGST]                         NUMERIC (18, 2) NULL,
    [Is_Active]                      BIT             NULL);

