CREATE TABLE [LMS].[BKP_14_AUG_T_Enquiry_Customer_Interface] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [EnquiryID]     INT           NULL,
    [CandidateName] VARCHAR (MAX) NULL,
    [ContactNo]     VARCHAR (MAX) NULL,
    [EmailID]       VARCHAR (MAX) NULL,
    [ActionType]    VARCHAR (MAX) NULL,
    [ActionStatus]  VARCHAR (MAX) NULL,
    [NoofAttempts]  INT           NULL,
    [StatusID]      INT           NULL,
    [CreatedOn]     DATETIME      NULL,
    [CompletedOn]   DATETIME      NULL,
    [Remarks]       VARCHAR (MAX) NULL,
    [CustomerID]    VARCHAR (MAX) NULL
);

