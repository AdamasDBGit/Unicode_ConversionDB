CREATE TABLE [dbo].[Tbl_KPMG_TransitMaster] (
    [Fld_KPMG_Transist_Id] INT          IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Mo_Id]       INT          NULL,
    [Fld_KPMG_To_Center]   INT          NULL,
    [Fld_KPMG_From_Center] INT          NULL,
    [Fld_KPMG_Date]        DATETIME     CONSTRAINT [DF_Tbl_KPMG_TransitMaster_Fld_KPMG_Date] DEFAULT (getdate()) NULL,
    [Fld_KPMG_Vehicle_No]  VARCHAR (50) CONSTRAINT [DF_Tbl_KPMG_TransitMaster_Fld_KPMG_Vehicle_No] DEFAULT ((0)) NULL,
    [Fld_KPMG_Status]      INT          CONSTRAINT [DF_Tbl_KPMG_TransitMaster_Fld_KPMG_Status] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Tbl_KPMG_TransitMaster] PRIMARY KEY CLUSTERED ([Fld_KPMG_Transist_Id] ASC)
);

