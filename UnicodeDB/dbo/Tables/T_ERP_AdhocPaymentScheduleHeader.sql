CREATE TABLE [dbo].[T_ERP_AdhocPaymentScheduleHeader] (
    [inAdhocPaymentScheduleHeaderID] INT             IDENTITY (1, 1) NOT NULL,
    [inAdHocFeeComponentID]          INT             NOT NULL,
    [nAmount]                        DECIMAL (18, 2) NOT NULL,
    [inSchoolProgramID]              INT             NOT NULL,
    [dtStartDate]                    DATETIME        NOT NULL,
    [dtEndDate]                      DATETIME        NOT NULL,
    [inBrandID]                      INT             NOT NULL,
    [inSessionID]                    INT             NOT NULL,
    [sDescription]                   NVARCHAR (MAX)  NULL,
    [IsCollectWithHighPriority]      BIT             CONSTRAINT [DF__T_ERP_Adh__IsCol__12EBF075] DEFAULT ((0)) NOT NULL,
    [EventId]                        INT             NULL,
    [NotifyRecipient]                BIT             DEFAULT ((0)) NOT NULL,
    [inNotificationScheduleID]       INT             NULL
);

