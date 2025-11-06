CREATE TABLE [dbo].[T_Content_Employee_Dtl] (
    [I_Content_Emp_Dtl_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_Content_Details_ID] INT            NOT NULL,
    [I_Brand_ID]                 INT            NULL,
    [I_User_ID]                  INT            NULL,
    [Dt_Expiry_Date]             DATETIME       NULL,
    [I_Status_Id]                INT            NULL,
    [S_Crtd_By]                  NVARCHAR (MAX) NULL,
    [S_Upd_By]                   NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [Dt_Upd_On]                  DATETIME       NULL,
    CONSTRAINT [PK_T_Content_Employee_Dtl] PRIMARY KEY CLUSTERED ([I_Content_Emp_Dtl_ID] ASC)
);

