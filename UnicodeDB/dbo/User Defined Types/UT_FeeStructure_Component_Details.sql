CREATE TYPE [dbo].[UT_FeeStructure_Component_Details] AS TABLE (
    [p_R_I_Fee_Structure_HeaderID]               INT             NOT NULL,
    [p_I_Fee_Structure_Installment_Component_ID] BIGINT          NULL,
    [p_R_I_Fee_Component_ID]                     INT             NOT NULL,
    [p_I_Seq_No]                                 INT             NOT NULL,
    [p_N_Component_Actual_Amount]                NUMERIC (18, 2) NOT NULL,
    [p_Is_OneTime]                               BIT             NOT NULL,
    [p_Is_During_Admission]                      BIT             NULL,
    [p_Dt_PostAdmissionDt]                       DATE            NULL,
    [p_R_I_Fee_Pay_Installment_ID]               INT             NULL,
    [p_I_Created_By]                             INT             NULL,
    [p_Is_Active]                                BIT             NULL,
    [p_I_Modified_By]                            INT             NULL);

