CREATE TABLE [dbo].[T_ERP_PreEnq_Siblings] (
    [I_PreEnqSibling_ID]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [R_I_Enquiry_Regn_ID] INT            NULL,
    [S_StudentID]         NVARCHAR (MAX) NULL,
    [S_Stud_Name]         NVARCHAR (MAX) NULL,
    [Is_Running_Stud]     BIT            NULL,
    [S_Passout_Year]      NVARCHAR (MAX) NULL,
    [Dtt_Created_At]      DATETIME       CONSTRAINT [DF__T_ERP_Pre__Dtt_C__0001D44F] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]     DATETIME       NULL,
    [I_Created_By]        NVARCHAR (MAX) NULL,
    [I_Modified_By]       NVARCHAR (MAX) NULL,
    [Is_Active]           BIT            CONSTRAINT [DF__T_ERP_Pre__Is_Ac__00F5F888] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Pr__557A011327BB600D] PRIMARY KEY CLUSTERED ([I_PreEnqSibling_ID] ASC)
);

