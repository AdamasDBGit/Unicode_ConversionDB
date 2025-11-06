CREATE TABLE [dbo].[T_ERP_Student_Fee_Payment_Header] (
    [I_Fee_Struct_Payment_ID]      BIGINT          IDENTITY (1, 1) NOT NULL,
    [I_Brand_Id]                   INT             NULL,
    [I_School_Session_ID]          INT             NULL,
    [R_I_Enquiry_Regn_ID]          BIGINT          NULL,
    [N_TotalInstallment_Amount]    NUMERIC (18, 2) NULL,
    [For_Dt_Installment_Dt]        DATE            NULL,
    [N_Total_Received_Amount]      NUMERIC (18, 2) NULL,
    [N_Due_Amount]                 NUMERIC (18, 2) NULL,
    [S_Payment_Receipt_No]         NVARCHAR (MAX)  NULL,
    [Is_Offline]                   BIT             NULL,
    [R_I_PaymentMode_ID]           TINYINT         NULL,
    [I_Payment_Status]             TINYINT         NULL,
    [Dt_Payment_Received_Dt]       DATE            NULL,
    [Dtt_Created_At]               DATETIME        CONSTRAINT [DF__T_ERP_Stu__Dtt_C__61D252EA] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]              DATETIME        NULL,
    [I_Created_By]                 INT             NULL,
    [I_Modified_By]                INT             NULL,
    [Is_Active]                    BIT             CONSTRAINT [DF__T_ERP_Stu__Is_Ac__62C67723] DEFAULT ((1)) NULL,
    [I_Stud_Fee_Struct_CompMap_ID] INT             NULL,
    CONSTRAINT [PK__T_ERP_St__2710937F2A94BCD3] PRIMARY KEY CLUSTERED ([I_Fee_Struct_Payment_ID] ASC)
);

