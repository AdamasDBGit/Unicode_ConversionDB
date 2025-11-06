CREATE TABLE [dbo].[T_ERP_Student_Fee_Payment_Details] (
    [I_Stud_Fee_DetailsID]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [I_Fee_Struct_Payment_ID]       BIGINT          NULL,
    [I_Fee_Component_InstallmentID] INT             NULL,
    [N_Amount_Paid]                 NUMERIC (12, 2) NULL,
    [Is_Active]                     BIT             CONSTRAINT [DF__T_ERP_Stu__Is_Ac__208E9F72] DEFAULT ((1)) NULL,
    [Dtt_Created_At]                DATETIME        CONSTRAINT [DF__T_ERP_Stu__Dtt_C__2182C3AB] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]               DATETIME        NULL,
    [I_Created_By]                  INT             NULL,
    [I_Modified_By]                 INT             NULL,
    [N_Adv_AMt]                     NUMERIC (12, 2) NULL
);

