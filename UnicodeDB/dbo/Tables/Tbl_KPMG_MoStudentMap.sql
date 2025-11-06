CREATE TABLE [dbo].[Tbl_KPMG_MoStudentMap] (
    [Fld_KPMG_MoStudentMapId]      INT      IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_I_Student_Detail_ID] INT      NOT NULL,
    [Fld_KPMG_I_Installment_No]    INT      NOT NULL,
    [Fld_KPMG_DateOfCreation]      DATETIME CONSTRAINT [DF_Table_1_DateOfCreation] DEFAULT (getdate()) NOT NULL,
    [Fld_KPMG_Status]              INT      CONSTRAINT [DF_Tbl_KPMG_MoStudentMap_Fld_KPMG_Status] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [pk_Tbl_KPMG_MoStudentMap_Fld_KPMG_MoStudentMapId] PRIMARY KEY CLUSTERED ([Fld_KPMG_MoStudentMapId] ASC)
);

