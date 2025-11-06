CREATE TABLE [dbo].[T_ERP_Exam_AdmitCardAndReportCardTemplate] (
    [inAdmitCardAndReportCardTemplateId] INT              IDENTITY (1, 1) NOT NULL,
    [unAdmitCardAndReportCardTemplateId] UNIQUEIDENTIFIER CONSTRAINT [DF__T_ERP_Exa__unAdm__3F531DB4] DEFAULT (newid()) NULL,
    [inAcademicSessionId]                INT              NULL,
    [inSchoolProgramId]                  INT              NULL,
    [inClassId]                          INT              NULL,
    [inStreamId]                         INT              NULL,
    [inSectionId]                        INT              NULL,
    [stTemplateName]                     NVARCHAR (300)   NULL,
    [inTemplateType]                     INT              NULL,
    [stTemplatePath]                     NVARCHAR (MAX)   NULL,
    [inStatus]                           BIT              CONSTRAINT [DF__T_ERP_Exa__inSta__404741ED] DEFAULT ((1)) NULL,
    [inCreatedBy]                        INT              NULL,
    [inModifiedBy]                       INT              NULL,
    [dtCreatedDate]                      DATETIME         NULL,
    [dtModifiedDate]                     DATETIME         NULL,
    CONSTRAINT [PK__T_ERP_Ex__A8D861AE1E44B7C5] PRIMARY KEY CLUSTERED ([inAdmitCardAndReportCardTemplateId] ASC)
);

