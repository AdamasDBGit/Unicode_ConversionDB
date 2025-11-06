CREATE TABLE [dbo].[T_Center_Batch_Details_bak22022024] (
    [I_Batch_ID]                     INT             NOT NULL,
    [I_Centre_Id]                    INT             NOT NULL,
    [I_Course_Fee_Plan_ID]           INT             NULL,
    [I_Minimum_Regn_Amt]             DECIMAL (10, 2) NULL,
    [Max_Strength]                   INT             NULL,
    [I_Status]                       INT             NULL,
    [S_Crtd_By]                      NVARCHAR (MAX)  NULL,
    [S_Updt_By]                      NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                     DATETIME        NULL,
    [Dt_Upd_On]                      DATETIME        NULL,
    [I_Employee_ID]                  INT             NULL,
    [B_Is_Eligibility_List_Prepared] BIT             NULL,
    [I_Min_Strength]                 INT             NULL,
    [I_Center_Dispatch_Scheme_ID]    INT             NULL,
    [S_ClassDays]                    NVARCHAR (MAX)  NULL,
    [S_OfflineClassTime]             NVARCHAR (MAX)  NULL,
    [S_OnlineClassTime]              NVARCHAR (MAX)  NULL,
    [S_HandoutClassTime]             NVARCHAR (MAX)  NULL,
    [S_ClassMode]                    NVARCHAR (MAX)  NULL,
    [S_BatchTime]                    NVARCHAR (MAX)  NULL
);

