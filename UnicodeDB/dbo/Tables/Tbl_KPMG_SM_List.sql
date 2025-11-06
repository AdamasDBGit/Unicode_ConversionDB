CREATE TABLE [dbo].[Tbl_KPMG_SM_List] (
    [Fld_KPMG_SM_Id]                INT             IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_CourseId]             INT             NULL,
    [Fld_KPMG_ItemCode]             NVARCHAR (MAX)  NOT NULL,
    [Fld_KPMG_ItemType]             INT             NOT NULL,
    [Fld_KPMG_I_Installment_No]     INT             CONSTRAINT [DF_Tbl_KPMG_SM_List_Fld_KPMG_I_Installment_No] DEFAULT ((1)) NOT NULL,
    [Fld_KPMG_ItemCode_Description] NVARCHAR (MAX)  NULL,
    [Fld_KPMG_Item_Price]           INT             CONSTRAINT [DF_Tbl_KPMG_SM_List_Fld_KPMG_Item_Price] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Tax]                  DECIMAL (10, 2) NULL,
    [Fld_KPMG_Price]                DECIMAL (10, 2) NULL,
    [Fld_KPMG_Segment]              NVARCHAR (255)  CONSTRAINT [DF__Tbl_KPMG___Fld_K__0CB328DB] DEFAULT ('') NULL,
    [Fld_KPMG_IsValid]              CHAR (1)        CONSTRAINT [DF__Tbl_KPMG___Fld_K__0DA74D14] DEFAULT ('N') NULL,
    [Fld_KPMG_IsEnable]             CHAR (1)        CONSTRAINT [DF__Tbl_KPMG___Fld_K__1918FFC0] DEFAULT ('Y') NULL,
    [Fld_KPMG_Prefix]               NVARCHAR (MAX)  NULL,
    [Fld_KPMG_AllowedDigitCount]    INT             NULL,
    CONSTRAINT [pk_Tbl_KPMG_SM_List_Fld_KPMG_SM_Id] PRIMARY KEY CLUSTERED ([Fld_KPMG_SM_Id] ASC)
);

