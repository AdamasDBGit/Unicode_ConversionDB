CREATE TABLE [dbo].[Tbl_KPMG_ProjectionHistorical] (
    [Fld_KPMG_Proj_Hist_Id] INT IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Month]        INT NOT NULL,
    [Fld_KPMG_Year]         INT NOT NULL,
    [Fld_KPMG_Projection]   INT NOT NULL,
    [Fld_KPMG_Branch_Id]    INT NOT NULL,
    [Fld_KPMG_Course_Id]    INT NOT NULL,
    [Fld_KPMG_BufferStock]  INT NULL,
    CONSTRAINT [pk_Tbl_KPMG_ProjectionHistorical_Fld_KPMG_Proj_Hist_Id] PRIMARY KEY CLUSTERED ([Fld_KPMG_Proj_Hist_Id] ASC)
);

