CREATE TABLE [dbo].[T_ERP_EnquiryReg_Prev_Details] (
    [I_Enq_PrevD_ID]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [R_I_Prev_Class_ID]   INT            NULL,
    [R_I_Enquiry_Regn_ID] INT            NULL,
    [Is_Marks_Input]      BIT            NULL,
    [N_TotalMarks]        NUMERIC (6, 2) CONSTRAINT [df_N_TotalMarks] DEFAULT ((0)) NULL,
    [N_Obtain_Marks]      NUMERIC (6, 2) NULL,
    [S_Grade]             CHAR (3)       NULL,
    [N_Percentage]        NUMERIC (4, 2) NULL,
    [S_School_Name]       NVARCHAR (MAX) NULL,
    [S_School_Board]      NVARCHAR (MAX) NULL,
    [S_Address]           NVARCHAR (MAX) NULL,
    [Dtt_Created_At]      DATETIME       CONSTRAINT [DF__T_ERP_Enq__Dtt_C__7C31436B] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]     DATETIME       NULL,
    [I_Created_By]        NVARCHAR (MAX) NULL,
    [I_Modified_By]       NVARCHAR (MAX) NULL,
    [Is_Active]           BIT            CONSTRAINT [DF__T_ERP_Enq__Is_Ac__7D2567A4] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_En__58F1CFF0528DFB1B] PRIMARY KEY CLUSTERED ([I_Enq_PrevD_ID] ASC)
);

