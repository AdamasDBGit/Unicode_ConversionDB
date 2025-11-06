CREATE TABLE [dbo].[Tbl_KPMG_SpecialExamination] (
    [Fld_KPMG_ExaminationId]   INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_ExaminationName] NVARCHAR (500) NULL,
    [Fld_KPMG_ValidFrom]       DATETIME       NULL,
    [Fld_KPMG_ValidTo]         DATETIME       NULL,
    [FLd_Kpmg_SM_Id]           INT            CONSTRAINT [DF__Tbl_KPMG___FLd_K__36A962A7] DEFAULT ((0)) NULL,
    [I_Student_Detail_ID]      INT            NULL,
    [Fld_KPMG_Admit_Path]      NVARCHAR (500) NULL,
    CONSTRAINT [PK_KPMG_SpecialExamination] PRIMARY KEY CLUSTERED ([Fld_KPMG_ExaminationId] ASC)
);

