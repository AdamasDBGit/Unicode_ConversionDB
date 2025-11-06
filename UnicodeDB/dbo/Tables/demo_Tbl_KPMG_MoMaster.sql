CREATE TABLE [dbo].[demo_Tbl_KPMG_MoMaster] (
    [Fld_KPMG_Mo_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_GrnNumber]    NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Branch_Id]    INT            NOT NULL,
    [Fld_KPMG_Created Date] DATETIME       NOT NULL,
    [Fld_KPMG_RequiredDate] DATETIME       NOT NULL,
    [Fld_KPMG_IsMo]         INT            NOT NULL,
    [Fld_KPMG_Status]       INT            NOT NULL,
    [Fld_KPMG_ISCollected]  CHAR (1)       NULL,
    [Fld_KPMG_Context]      NVARCHAR (255) NULL,
    [Fld_KPMG_MoLineId]     INT            NULL,
    [Fld_KPMG_MoLineNumber] INT            NULL
);

