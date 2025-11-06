CREATE TABLE [dbo].[T_ERP_AdmitCardAndReportCardTemplate] (
    [inAdmitCardAndReportCardTemplateId] INT              IDENTITY (1, 1) NOT NULL,
    [unAdmitCardAndReportCardTemplateId] UNIQUEIDENTIFIER CONSTRAINT [DF__T_ERP_Adm__unAdm__55AC7327] DEFAULT (newid()) NULL,
    [inAcademicSessionId]                INT              NULL,
    [inSchoolProgramId]                  INT              NULL,
    [inClassId]                          INT              NULL,
    [inStreamId]                         INT              NULL,
    [inSectionId]                        INT              NULL,
    [stTemplateName]                     NVARCHAR (300)   NULL,
    [inTemplateType]                     INT              NULL,
    [stTemplatePath]                     NVARCHAR (MAX)   NULL,
    [inStatus]                           BIT              CONSTRAINT [DF__T_ERP_Adm__inSta__56A09760] DEFAULT ((1)) NULL,
    [inCreatedBy]                        INT              NULL,
    [inModifiedBy]                       INT              NULL,
    [dtCreatedDate]                      DATETIME         NULL,
    [dtModifiedDate]                     DATETIME         NULL,
    CONSTRAINT [PK__T_ERP_Ad__A8D861AEBD24AFDF] PRIMARY KEY CLUSTERED ([inAdmitCardAndReportCardTemplateId] ASC)
);

