CREATE TABLE [dbo].[T_Student_Upgrade_Detail] (
    [I_Upgrade_ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]          INT            NOT NULL,
    [I_Previous_Invoice_Header_ID] INT            NOT NULL,
    [I_Upgrade_Invoice_Header_ID]  INT            NULL,
    [I_Bridge_ID]                  INT            NOT NULL,
    [I_Course_ID]                  INT            NOT NULL,
    [I_Status]                     INT            NULL,
    [S_Crtd_By]                    NVARCHAR (MAX) NULL,
    [S_Upd_By]                     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                   DATETIME       NULL,
    [Dt_Upd_On]                    DATETIME       NULL
);

