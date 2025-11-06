CREATE TABLE [dbo].[T_Discount_Course_Detail] (
    [I_Discount_Course_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Course_ID]                 INT            NULL,
    [I_Status]                    INT            NULL,
    [I_Discount_Centre_Detail_ID] INT            NULL,
    [S_Crtd_By]                   NVARCHAR (MAX) NULL,
    [S_Upd_By]                    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                  DATETIME       NULL,
    [Dt_Upd_On]                   DATETIME       NULL
);

