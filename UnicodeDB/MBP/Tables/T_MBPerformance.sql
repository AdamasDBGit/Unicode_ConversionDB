CREATE TABLE [MBP].[T_MBPerformance] (
    [I_MBPerformance_ID]  INT             IDENTITY (1, 1) NOT NULL,
    [I_Product_ID]        INT             NULL,
    [I_Center_ID]         INT             NULL,
    [I_Year]              INT             NULL,
    [I_Month]             INT             NULL,
    [I_Actual_Enquiry]    INT             NULL,
    [I_Actual_Booking]    NUMERIC (18, 2) NULL,
    [I_Actual_Enrollment] INT             NULL,
    [I_Actual_Billing]    NUMERIC (18, 2) NULL,
    [I_Actual_RFF]        NUMERIC (18, 2) NULL,
    [S_Crtd_By]           VARCHAR (20)    NULL,
    [S_Upd_By]            VARCHAR (20)    NULL,
    [Dt_Crtd_On]          DATETIME        NULL,
    [Dt_Upd_On]           DATETIME        NULL,
    [S_Remarks]           VARCHAR (2000)  NULL,
    CONSTRAINT [PK__T_MBPerformance__793574BC] PRIMARY KEY CLUSTERED ([I_MBPerformance_ID] ASC)
);

