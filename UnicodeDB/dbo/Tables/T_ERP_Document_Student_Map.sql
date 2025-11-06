CREATE TABLE [dbo].[T_ERP_Document_Student_Map] (
    [I_Document_StudRegn_ID] INT            IDENTITY (1, 1) NOT NULL,
    [R_I_Enquiry_Regn_ID]    BIGINT         NULL,
    [R_I_Document_Type_ID]   INT            NULL,
    [I_Seq_No]               INT            NULL,
    [Is_verified]            INT            CONSTRAINT [DF__T_ERP_Doc__Is_ve__39F96BBA] DEFAULT ((0)) NULL,
    [Dtt_Verified_date]      DATETIME       NULL,
    [Is_Active]              BIT            NULL,
    [I_CreatedBy]            INT            NULL,
    [I_UpdatedBy]            INT            NULL,
    [Dtt_CreatedAt]          DATETIME       CONSTRAINT [DF__T_ERP_Doc__Dtt_C__3AED8FF3] DEFAULT (getdate()) NULL,
    [Dtt_UpdatedAt]          DATETIME       NULL,
    [S_Imagepath]            NVARCHAR (500) NULL
);

