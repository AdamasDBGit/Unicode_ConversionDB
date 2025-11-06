CREATE TABLE [dbo].[T_ERP_Teacher_Unavailability_Header] (
    [I_Teacher_Unavailability_Header_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Faculty_Master_ID]                INT            NOT NULL,
    [Dt_From]                            DATETIME       NOT NULL,
    [Dt_To]                              DATETIME       NOT NULL,
    [Dt_CreatedAt]                       DATETIME       NULL,
    [S_Reason]                           NVARCHAR (MAX) NULL,
    [I_CreatedBy]                        INT            NULL,
    [I_Status]                           INT            NULL,
    [S_CancelReason]                     NVARCHAR (MAX) NULL,
    [Dt_CanceledDate]                    DATETIME       NULL,
    [Dt_Approved]                        DATETIME       NULL,
    [S_ApprovedRemarks]                  NVARCHAR (MAX) NULL,
    [I_AprrovedBy]                       INT            NULL,
    [Dt_Rejected]                        DATETIME       NULL,
    [S_RejectedRemarks]                  NVARCHAR (MAX) NULL,
    [I_RejectedBy]                       INT            NULL,
    [I_RaisedDeleteRequest]              INT            NULL,
    [Dt_RaisedDeleteRequest]             DATETIME       NULL,
    [S_RaisedDeleteRequestReason]        NVARCHAR (MAX) NULL
);

