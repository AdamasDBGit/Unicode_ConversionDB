CREATE TABLE [dbo].[T_APAI_Information] (
    [I_APAI_Info_ID]      INT             IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID] INT             NOT NULL,
    [S_Agent_Name]        NVARCHAR (MAX)  NULL,
    [Dt_Settled_On]       DATETIME        NULL,
    [N_Amount]            DECIMAL (18, 2) NULL,
    [S_Crtd_By]           NVARCHAR (MAX)  NULL,
    [S_Upd_By]            NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]          DATETIME        NULL,
    [Dt_Upd_On]           DATETIME        NULL,
    [I_Status]            INT             NULL,
    CONSTRAINT [PK_T_APAI_Information] PRIMARY KEY CLUSTERED ([I_APAI_Info_ID] ASC)
);

