CREATE TABLE [dbo].[T_Employee_Dtls] (
    [I_Employee_ID]         INT            IDENTITY (1, 1) NOT NULL,
    [I_Centre_Id]           INT            NULL,
    [S_Emp_ID]              NVARCHAR (MAX) NULL,
    [S_Title]               NVARCHAR (MAX) NULL,
    [S_First_Name]          NVARCHAR (MAX) NULL,
    [S_Middle_Name]         NVARCHAR (MAX) NULL,
    [S_Last_Name]           NVARCHAR (MAX) NULL,
    [S_Basic_Address]       NVARCHAR (MAX) NULL,
    [Dt_DOB]                DATETIME       NULL,
    [S_Phone_No]            NVARCHAR (MAX) NULL,
    [S_Email_ID]            NVARCHAR (MAX) NULL,
    [Dt_Joining_Date]       DATETIME       NULL,
    [Dt_Resignation_Date]   DATETIME       NULL,
    [I_Job_Type_ID]         INT            NULL,
    [I_Experience_Type_ID]  INT            NULL,
    [I_Document_ID]         INT            NULL,
    [I_Status]              INT            NULL,
    [Dt_Start_Date]         DATETIME       NULL,
    [Dt_End_Date]           DATETIME       NULL,
    [Dt_Activation_Date]    DATETIME       NULL,
    [Dt_DeactivationDate]   DATETIME       NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [Is_Interview_Cleared]  INT            NULL,
    [Dt_Registration_Date]  DATETIME       NULL,
    [S_Remarks]             NVARCHAR (MAX) NULL,
    [B_IsRoamingFaculty]    BIT            NULL,
    [S_LeaveDay]            NVARCHAR (MAX) NULL,
    [S_TeacherAvailability] NVARCHAR (MAX) NULL,
    [S_CenterAvailability]  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Employee_Dtls__79F2F81D] PRIMARY KEY CLUSTERED ([I_Employee_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_I_Status]
    ON [dbo].[T_Employee_Dtls]([I_Status] ASC);

