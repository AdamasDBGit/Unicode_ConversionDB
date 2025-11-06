CREATE TABLE [LMS].[SMSLMSSyncBrandCenterLists] (
    [LMSSMSBrandID]    INT           IDENTITY (1, 1) NOT NULL,
    [BrandID]          INT           NOT NULL,
    [BrandName]        VARCHAR (MAX) NOT NULL,
    [CenterID]         INT           NOT NULL,
    [ISBrandEligible]  BIT           DEFAULT ((1)) NULL,
    [Dt_Crt_On]        DATETIME      NULL,
    [Dt_Crt_By]        VARCHAR (MAX) NULL,
    [Dt_Upt_On]        DATETIME      NULL,
    [Dt_Upt_By]        VARCHAR (MAX) NULL,
    [ISCenterEligible] INT           DEFAULT ((1)) NULL
);

