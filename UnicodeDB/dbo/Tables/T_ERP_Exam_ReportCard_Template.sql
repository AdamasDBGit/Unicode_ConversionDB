CREATE TABLE [dbo].[T_ERP_Exam_ReportCard_Template] (
    [iTemplateID]       INT           IDENTITY (1, 1) NOT NULL,
    [sTemplateName]     NVARCHAR (50) NOT NULL,
    [iTemplateFooterID] INT           NOT NULL,
    [iTemplateHeaderID] INT           NOT NULL,
    [iStatus]           INT           NOT NULL,
    [dtCreatedBy]       DATETIME      NULL,
    [iBrandID]          INT           NULL
);

