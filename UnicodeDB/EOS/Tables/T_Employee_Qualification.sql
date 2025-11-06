CREATE TABLE [EOS].[T_Employee_Qualification] (
    [I_Employee_Qual_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [I_Qualification_Type_ID] INT            NULL,
    [I_Qualification_Name_ID] INT            NULL,
    [I_Employee_ID]           INT            NULL,
    [I_Passing_Year]          INT            NULL,
    [N_Percentage]            NUMERIC (8, 2) NULL,
    [S_Crtd_By]               VARCHAR (20)   NULL,
    [I_Status]                INT            NULL,
    [S_Upd_By]                VARCHAR (20)   NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    CONSTRAINT [PK__T_Employee_Quali__79C8DAEB] PRIMARY KEY CLUSTERED ([I_Employee_Qual_ID] ASC)
);

