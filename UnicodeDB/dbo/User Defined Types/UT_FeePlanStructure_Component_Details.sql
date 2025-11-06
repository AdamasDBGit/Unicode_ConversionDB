CREATE TYPE [dbo].[UT_FeePlanStructure_Component_Details] AS TABLE (
    [p_R_I_Fee_Structure_HeaderID]               INT             NULL,
    [p_I_Fee_Structure_Installment_Component_ID] BIGINT          NULL,
    [p_R_I_Fee_Component_ID]                     INT             NOT NULL,
    [p_I_Seq_No]                                 INT             NOT NULL,
    [N_Component_Actual_Total_Annual_Amount]     NUMERIC (18, 2) NOT NULL,
    [p_Is_OneTime]                               BIT             NOT NULL,
    [p_R_I_Fee_Pay_Installment_ID]               INT             NULL,
    [p_Is_During_Admission]                      BIT             NULL,
    [p_N_Installment_Range_For_PreAdmission]     INT             NULL,
    [p_Dt_PostAdmissionDt]                       DATE            NULL,
    [p_I_Action_By]                              INT             NOT NULL,
    [p_IsActive]                                 BIT             NOT NULL);

