CREATE TABLE [CORPORATE].[T_Corporate_Receipt] (
    [I_Corporate_Receipt_Id]   INT           IDENTITY (1, 1) NOT NULL,
    [I_Corporate_Plan_ID]      INT           NULL,
    [S_Crtd_By]                VARCHAR (20)  NULL,
    [S_Upd_By]                 VARCHAR (50)  NULL,
    [Dt_Crtd_On]               DATETIME      NULL,
    [Dt_Upd_On]                DATETIME      NULL,
    [I_Status]                 INT           NULL,
    [S_Corporate_Receipt_Type] VARCHAR (20)  NULL,
    [S_TDS_Comment]            VARCHAR (500) NULL,
    CONSTRAINT [PK_T_Corporate_Receipt] PRIMARY KEY CLUSTERED ([I_Corporate_Receipt_Id] ASC)
);

