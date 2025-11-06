CREATE TABLE [dbo].[T_ERP_Fee_Structure_Installment_Component_backup_all] (
    [I_Fee_Structure_Installment_Component_ID] BIGINT          IDENTITY (1, 1) NOT NULL,
    [R_I_Fee_Structure_ID]                     INT             NULL,
    [R_I_Fee_Component_ID]                     INT             NULL,
    [I_Seq_No]                                 INT             NULL,
    [N_Component_Actual_Total_Annual_Amount]   NUMERIC (12, 2) NULL,
    [Is_OneTime]                               BIT             NULL,
    [R_I_Fee_Pay_Installment_ID]               INT             NULL,
    [Is_During_Admission]                      BIT             NULL,
    [Installm_Range_PreAdm]                    INT             NULL,
    [Dt_PostAdmissionDt]                       DATE            NULL,
    [Dtt_Created_At]                           DATETIME        NULL,
    [Dtt_Modified_At]                          DATETIME        NULL,
    [I_Created_By]                             INT             NULL,
    [I_Modified_By]                            INT             NULL,
    [Is_Active]                                BIT             NULL,
    [I_Lumpsum_Month]                          INT             NULL,
    [I_Start_Period_Month]                     INT             NULL
);

