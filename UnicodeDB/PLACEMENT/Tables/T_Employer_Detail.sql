CREATE TABLE [PLACEMENT].[T_Employer_Detail] (
    [I_Employer_ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_State_ID]             INT           NULL,
    [I_Nature_of_Business]   INT           NULL,
    [I_Country_ID]           INT           NULL,
    [I_City_ID]              INT           NOT NULL,
    [S_Company_Code]         VARCHAR (50)  NULL,
    [S_Company_Name]         VARCHAR (250) NULL,
    [Dt_First_Enquiry_Date]  DATETIME      NULL,
    [S_Group_Company_Code]   VARCHAR (50)  NULL,
    [S_Address]              VARCHAR (200) NULL,
    [S_Pincode]              VARCHAR (50)  NULL,
    [S_Crtd_By]              VARCHAR (20)  NULL,
    [S_Upd_By]               VARCHAR (20)  NULL,
    [Dt_Crtd_On]             DATETIME      NULL,
    [Dt_Upd_On]              DATETIME      NULL,
    [I_Status]               INT           NOT NULL,
    [S_Phone_No]             VARCHAR (20)  NULL,
    [S_Mobile_No]            VARCHAR (20)  NULL,
    [S_GroupCompanyTurnOver] VARCHAR (MAX) NULL,
    [S_MCAList]              VARCHAR (6)   NULL,
    CONSTRAINT [PK__T_Employer_Detai__116B5A52] PRIMARY KEY CLUSTERED ([I_Employer_ID] ASC)
);

