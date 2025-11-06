CREATE TABLE [dbo].[T_ERP_Teacher_Unavailability_Detail] (
    [I_Teacher_Unavailability_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Teacher_Unavailability_Header_ID] INT            NOT NULL,
    [Dt_Date]                            DATE           NOT NULL,
    [I_IsFullDay]                        INT            NOT NULL,
    [I_IsFisrtHalf]                      INT            NOT NULL,
    [I_IsSecondHalf]                     INT            NOT NULL,
    [I_Status]                           INT            NULL,
    [Dt_ApprovedAt]                      DATETIME       NULL,
    [Dt_RejectedAt]                      DATETIME       NULL,
    [Dt_CanceledAt]                      DATETIME       NULL,
    [S_ApprovedRemarks]                  NVARCHAR (MAX) NULL,
    [S_RejectedRemarks]                  NVARCHAR (MAX) NULL,
    [S_CanceledRemarks]                  NVARCHAR (MAX) NULL
);

