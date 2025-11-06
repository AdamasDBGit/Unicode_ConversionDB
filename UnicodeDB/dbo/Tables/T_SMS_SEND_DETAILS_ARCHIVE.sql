CREATE TABLE [dbo].[T_SMS_SEND_DETAILS_ARCHIVE] (
    [I_SMS_SEND_DETAILS_ARCHIVE_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_SMS_SEND_DETAILS_ID]         INT            NULL,
    [S_MOBILE_NO]                   NVARCHAR (MAX) NOT NULL,
    [I_SMS_STUDENT_ID]              INT            NULL,
    [I_SMS_TYPE_ID]                 INT            NOT NULL,
    [S_SMS_BODY]                    NVARCHAR (MAX) NULL,
    [I_IS_SUCCESS]                  INT            NULL,
    [I_NO_OF_ATTEMPT]               INT            NULL,
    [S_RETURN_CODE_FROM_PROVIDER]   NVARCHAR (MAX) NULL,
    [I_REFERENCE_ID]                INT            NULL,
    [I_REFERENCE_TYPE_ID]           INT            NOT NULL,
    [Dt_SMS_SEND_ON]                DATETIME       NULL,
    [I_Status]                      INT            NULL,
    [S_Crtd_By]                     NVARCHAR (MAX) NULL,
    [S_Upd_By]                      NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                    DATETIME       NULL,
    [Dt_Upd_On]                     DATETIME       NULL,
    [Dt_Archived_On]                DATETIME       CONSTRAINT [DF__T_SMS_SEN__Dt_Ar__54BA7F29] DEFAULT (getdate()) NOT NULL
);

