CREATE TABLE [dbo].[T_Student_Status_Details_Archive] (
    [I_Student_Status_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]        INT             NOT NULL,
    [I_Student_Status_ID]        INT             NOT NULL,
    [I_Status]                   INT             NULL,
    [N_Due]                      DECIMAL (14, 2) NULL,
    [Dt_Crtd_On]                 DATETIME        NULL,
    [Dt_Upd_On]                  DATETIME        NULL,
    [S_Crtd_By]                  NVARCHAR (MAX)  NULL,
    [S_Upd_By]                   NVARCHAR (MAX)  NULL,
    [IsEditable]                 BIT             NULL,
    [DefaulterDate]              DATETIME        NULL
);

