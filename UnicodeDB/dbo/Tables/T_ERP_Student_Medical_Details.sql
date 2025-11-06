CREATE TABLE [dbo].[T_ERP_Student_Medical_Details] (
    [I_Student_Medical_Details_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]          INT            NOT NULL,
    [I_Is_Allergies]               INT            NULL,
    [S_Allergies]                  NVARCHAR (MAX) NULL,
    [I_Is_Chronic]                 INT            NULL,
    [S_Chronic]                    NVARCHAR (MAX) NULL,
    [I_Is_Disabilities]            INT            NULL,
    [S_Disabilities]               NVARCHAR (MAX) NULL,
    [S_Additional]                 NVARCHAR (MAX) NULL,
    [S_CreatedBy]                  NVARCHAR (50)  NULL,
    [Dt_CreatedAt]                 DATETIME       NULL,
    [Dt_UpdatedAt]                 DATETIME       NULL
);

