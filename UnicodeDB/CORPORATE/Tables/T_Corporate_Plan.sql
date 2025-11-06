CREATE TABLE [CORPORATE].[T_Corporate_Plan] (
    [I_Corporate_Plan_ID]      INT             IDENTITY (1, 1) NOT NULL,
    [S_Corporate_Plan_Name]    VARCHAR (200)   NULL,
    [I_Corporate_ID]           INT             NULL,
    [Dt_Valid_From]            DATETIME        NULL,
    [Dt_Valid_To]              DATETIME        NULL,
    [B_Is_Fund_Shared]         BIT             NULL,
    [I_Corporate_Plan_Type_ID] INT             NULL,
    [I_Minimum_Strength]       INT             NULL,
    [I_Maximum_Strength]       INT             NULL,
    [N_Percent_Student_Share]  DECIMAL (18, 2) NULL,
    [I_Status]                 INT             NULL,
    [S_Crtd_By]                VARCHAR (20)    NULL,
    [S_Updt_by]                VARCHAR (20)    NULL,
    [Dt_Crtd_On]               DATETIME        NULL,
    [Dt_Updt_On]               DATETIME        NULL,
    [IsCertificate_Eligible]   BIT             NULL,
    CONSTRAINT [PK_T_Corporate_Plan_1] PRIMARY KEY CLUSTERED ([I_Corporate_Plan_ID] ASC)
);

