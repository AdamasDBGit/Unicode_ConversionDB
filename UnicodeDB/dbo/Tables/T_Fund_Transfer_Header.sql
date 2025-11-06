CREATE TABLE [dbo].[T_Fund_Transfer_Header] (
    [I_Fund_Transfer_Header_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]               INT             NOT NULL,
    [Dt_Fund_Transfer_Date]     DATETIME        NULL,
    [N_CourseFees]              NUMERIC (18, 2) NULL,
    [N_Other_Collections]       NUMERIC (18, 2) NULL,
    [N_Total_Collection]        NUMERIC (18, 2) NULL,
    [N_RFF_Company]             NUMERIC (18, 2) NULL,
    [N_Total_Receivable]        NUMERIC (18, 2) NULL,
    [N_Total_Share_Center]      NUMERIC (18, 2) NULL,
    [I_Document_ID]             INT             NULL,
    [Dt_Date_From]              DATETIME        NULL,
    [Dt_Date_To]                DATETIME        NULL,
    CONSTRAINT [PK__T_Fund_Transfer___28A3C565] PRIMARY KEY CLUSTERED ([I_Fund_Transfer_Header_ID] ASC)
);

