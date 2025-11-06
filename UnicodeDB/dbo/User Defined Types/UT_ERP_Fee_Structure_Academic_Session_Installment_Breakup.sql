CREATE TYPE [dbo].[UT_ERP_Fee_Structure_Academic_Session_Installment_Breakup] AS TABLE (
    [I_Fee_Structure_Installment_Component_ID] INT            NULL,
    [R_I_Fee_Component_ID]                     INT            NULL,
    [I_Seq_No]                                 INT            NULL,
    [N_Component_Actual_Total_Annual_Amount]   DECIMAL (8, 2) NULL,
    [Is_OneTime]                               BIT            NULL,
    [R_I_Fee_Pay_Installment_ID]               INT            NULL,
    [Is_During_Admission]                      BIT            NULL,
    [Expected_Installment_Date]                DATETIME       NULL,
    [Dtt_Created_At]                           DATETIME       NULL,
    [Dtt_Modified_At]                          DATETIME       NULL,
    [I_Created_By]                             INT            NULL,
    [I_Modified_By]                            INT            NULL,
    [I_Fee_Structure_AcademicSession_Map_ID]   INT            NULL);

