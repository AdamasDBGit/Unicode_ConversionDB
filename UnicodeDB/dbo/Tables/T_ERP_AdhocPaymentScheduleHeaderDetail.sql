CREATE TABLE [dbo].[T_ERP_AdhocPaymentScheduleHeaderDetail] (
    [inAdhocPaymentScheduleHeaderDetailID] INT IDENTITY (1, 1) NOT NULL,
    [inAdhocPaymentScheduleHeaderID]       INT NOT NULL,
    [inClassID]                            INT NOT NULL,
    [inStreamID]                           INT NULL,
    [inSectionID]                          INT NOT NULL
);

