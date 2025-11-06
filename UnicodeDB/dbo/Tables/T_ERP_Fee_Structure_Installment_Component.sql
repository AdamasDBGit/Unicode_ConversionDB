CREATE TABLE [dbo].[T_ERP_Fee_Structure_Installment_Component] (
    [I_Fee_Structure_Installment_Component_ID] BIGINT          IDENTITY (1, 1) NOT NULL,
    [R_I_Fee_Structure_ID]                     INT             NULL,
    [R_I_Fee_Component_ID]                     INT             NULL,
    [I_Seq_No]                                 INT             NULL,
    [N_Component_Actual_Total_Annual_Amount]   NUMERIC (12, 2) NULL,
    [Is_OneTime]                               BIT             NULL,
    [R_I_Fee_Pay_Installment_ID]               INT             CONSTRAINT [DF__T_ERP_Fee__R_I_F__7CF05D7A] DEFAULT ((0)) NULL,
    [Is_During_Admission]                      BIT             NULL,
    [Installm_Range_PreAdm]                    INT             NULL,
    [Dt_PostAdmissionDt]                       DATE            NULL,
    [Dtt_Created_At]                           DATETIME        CONSTRAINT [DF__T_ERP_Fee__Dtt_C__7DE481B3] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]                          DATETIME        NULL,
    [I_Created_By]                             INT             NULL,
    [I_Modified_By]                            INT             NULL,
    [Is_Active]                                BIT             CONSTRAINT [DF__T_ERP_Fee__Is_Ac__7ED8A5EC] DEFAULT ((1)) NULL,
    [I_Lumpsum_Month]                          INT             NULL,
    [I_Start_Period_Month]                     INT             NULL,
    [I_End_Period_Month]                       INT             NULL,
    [I_Brand_ID]                               INT             NULL,
    CONSTRAINT [PK__T_ERP_Fe__AF6DF128CE2C6E13] PRIMARY KEY CLUSTERED ([I_Fee_Structure_Installment_Component_ID] ASC)
);

