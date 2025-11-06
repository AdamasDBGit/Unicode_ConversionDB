CREATE TABLE [dbo].[Tbl_KPMG_StudentExaminationDetails] (
    [Fld_KPMG_StudentDetailId]    NVARCHAR (255) NULL,
    [Fld_KPMG_ExaminationId]      INT            NULL,
    [Fld_KPMG_MaterialBarCode]    NVARCHAR (500) NULL,
    [Fld_KPMG_IsMoveOrderCreated] CHAR (1)       CONSTRAINT [DF__Tbl_KPMG___Fld_K__5AE6C31D] DEFAULT ('N') NULL,
    [Fld_KPMG_EnrollId]           INT            IDENTITY (1, 1) NOT NULL,
    [IsRowValid]                  CHAR (1)       CONSTRAINT [DF__Tbl_KPMG___IsRow__609F9C73] DEFAULT ('Y') NULL,
    [I_Student_Detail_ID]         INT            NULL,
    [Fld_KPMG_Admit_Path]         NVARCHAR (500) NULL
);

