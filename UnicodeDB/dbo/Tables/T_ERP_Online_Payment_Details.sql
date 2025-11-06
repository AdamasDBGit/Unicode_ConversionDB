CREATE TABLE [dbo].[T_ERP_Online_Payment_Details] (
    [I_OnlineTrackingID]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [R_I_PaymentID]          INT            NULL,
    [S_Type]                 NVARCHAR (MAX) NULL,
    [S_Transaction_Ref_No]   NVARCHAR (MAX) NULL,
    [S_External_Source_Name] NVARCHAR (MAX) NULL,
    [S_Bank_Name]            NVARCHAR (MAX) NULL,
    [Dtt_Created_At]         DATETIME       CONSTRAINT [DF__T_ERP_Onl__Dtt_C__1C6908D3] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]        DATETIME       NULL,
    [I_Created_By]           INT            NULL,
    [I_Modified_By]          INT            NULL,
    [Is_Active]              BIT            CONSTRAINT [DF__T_ERP_Onl__Is_Ac__1D5D2D0C] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_On__BDFA912371605657] PRIMARY KEY CLUSTERED ([I_OnlineTrackingID] ASC)
);

