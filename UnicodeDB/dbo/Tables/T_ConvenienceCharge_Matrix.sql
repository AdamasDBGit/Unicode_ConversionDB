CREATE TABLE [dbo].[T_ConvenienceCharge_Matrix] (
    [I_Brand_ID]       INT             NULL,
    [I_PaymentMode_ID] INT             NULL,
    [N_Addl_Amount]    DECIMAL (18, 2) NULL,
    [N_Percentage]     DECIMAL (18, 2) NULL,
    [N_From_Amount]    DECIMAL (18, 2) NULL,
    [N_To_Amount]      DECIMAL (18, 2) NULL,
    [Dt_Valid_From]    DATETIME        NULL,
    [Dt_Valid_To]      DATETIME        NULL,
    [I_Status]         INT             NULL
);

