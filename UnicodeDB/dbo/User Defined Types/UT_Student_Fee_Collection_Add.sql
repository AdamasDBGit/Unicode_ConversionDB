CREATE TYPE [dbo].[UT_Student_Fee_Collection_Add] AS TABLE (
    [I_Fee_Component_InstallmentID]     INT             NOT NULL,
    [N_Component_Actual_InstallmentAmt] NUMERIC (18, 2) NULL,
    [N_ComponentReceived_Amt]           NUMERIC (18, 2) NULL,
    [N_Total_Received_AMt]              NUMERIC (18, 2) NULL);

