CREATE TABLE [dbo].[Tbl_KPMG_MoveOrderLog] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [fld_KPMG_MoDate]        NVARCHAR (MAX) NULL,
    [fld_KPMG_Status]        NVARCHAR (MAX) NULL,
    [fld_KPMG_IsMoGenerated] CHAR (1)       NULL
);

